import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart' show rootBundle;
import 'package:llama_cpp_dart/llama_cpp_dart.dart';
import 'package:path_provider/path_provider.dart';

/// Service singleton yang mengelola siklus hidup `LlamaParent` (managed isolate)
/// dan menyediakan fungsi [generateFeedback] untuk menghasilkan
/// respons teks dari model SmolLM2-360M secara asinkronus.
///
/// Semua inferensi berjalan di background isolate terpisah via [LlamaParent]
/// sehingga **tidak memblokir UI thread** Flutter.
///
/// ## Cara pakai
/// ```dart
/// // Di main() atau provider init:
/// await LlmService.instance.init();
///
/// // Di manapun butuh feedback:
/// final feedback = await LlmService.instance.generateFeedback(
///   'Berikan evaluasi gerakan Push Up anak.',
/// );
/// ```
class LlmService {
  // ---------------------------------------------------------------------------
  // Singleton
  // ---------------------------------------------------------------------------
  LlmService._();
  static final LlmService instance = LlmService._();

  // ---------------------------------------------------------------------------
  // Konfigurasi
  // ---------------------------------------------------------------------------

  /// Nama file model GGUF di folder assets/models/
  static const String _modelAsset =
      'assets/models/smollm2-360m-instruct-q4_k_m.gguf';

  /// Jumlah konteks token (semakin kecil, semakin hemat RAM di perangkat mobile).
  static const int _contextSize = 2048;

  /// Jumlah thread CPU yang digunakan untuk inferensi.
  static const int _nThreads = 4;

  /// Jumlah maksimum token yang dihasilkan per panggilan generate (default).
  static const int _defaultMaxTokens = 256;

  // ---------------------------------------------------------------------------
  // State internal
  // ---------------------------------------------------------------------------
  LlamaParent? _llamaParent;
  bool _isInitialized = false;
  bool _isGenerating = false;

  /// Apakah engine sudah di-load dan siap digunakan.
  bool get isReady => _isInitialized;

  /// Apakah sedang ada proses generasi berjalan.
  bool get isBusy => _isGenerating;

  // ---------------------------------------------------------------------------
  // Inisialisasi
  // ---------------------------------------------------------------------------

  /// Inisialisasi model: salin dari bundle assets ke filesystem lokal
  /// (karena llama.cpp memerlukan path file fisik), lalu spawn isolate worker.
  ///
  /// Panggil method ini **sekali** saat aplikasi startup, misalnya di `main()`
  /// sebelum `runApp()`.
  ///
  /// Parameter opsional:
  /// - [temperature] : kreativitas sampling default (default 0.7).
  /// - [nThreads] : jumlah thread CPU (default 4).
  /// - [contextSize] : ukuran konteks token (default 2048).
  Future<void> init({
    double temperature = 0.7,
    int nThreads = _nThreads,
    int contextSize = _contextSize,
  }) async {
    if (_isInitialized) return;

    final modelPath = await _ensureModelFile();

    // Konfigurasi parameter model
    final modelParams = ModelParams();

    // Konfigurasi parameter konteks
    final contextParams = ContextParams()
      ..nCtx = contextSize
      ..nThreads = nThreads;

    // Konfigurasi parameter sampling
    final samplerParams = SamplerParams()..temp = temperature;

    // Buat perintah load untuk model SmolLM2
    final loadCommand = LlamaLoad(
      path: modelPath,
      modelParams: modelParams,
      contextParams: contextParams,
      samplingParams: samplerParams,
    );

    // Spawn isolate worker
    _llamaParent = LlamaParent(loadCommand);
    await _llamaParent!.init();

    _isInitialized = true;
  }

  // ---------------------------------------------------------------------------
  // Generasi Teks
  // ---------------------------------------------------------------------------

  /// Menghasilkan respons teks dari model berdasarkan [prompt] yang diberikan.
  ///
  /// Parameter opsional:
  /// - [maxTokens] : batas jumlah token yang dihasilkan (default 256).
  /// - [systemPrompt] : instruksi sistem opsional yang ditambahkan
  ///   di awal prompt (format ChatML).
  ///
  /// Mengembalikan `Future<String>` berisi teks respons lengkap.
  ///
  /// Melempar [StateError] jika engine belum diinisialisasi atau sedang sibuk.
  ///
  /// ```dart
  /// final feedback = await LlmService.instance.generateFeedback(
  ///   'Berikan feedback untuk gerakan Sit Up anak.',
  ///   systemPrompt: 'Kamu adalah asisten fisioterapi anak.',
  /// );
  /// ```
  Future<String> generateFeedback(
    String prompt, {
    int maxTokens = _defaultMaxTokens,
    String? systemPrompt,
  }) async {
    _assertReady();

    if (_isGenerating) {
      throw StateError(
        'LlmService: generasi sedang berjalan. '
        'Tunggu hingga selesai sebelum memanggil generateFeedback lagi.',
      );
    }

    _isGenerating = true;

    try {
      final buffer = StringBuffer();
      final completer = Completer<String>();
      var tokenCount = 0;

      // Subscribe ke stream token dari isolate worker
      late final StreamSubscription<String> subscription;
      subscription = _llamaParent!.stream.listen(
        (token) {
          // Token kosong atau hanya whitespace di awal bisa di-skip
          if (buffer.isEmpty && token.trim().isEmpty) return;

          buffer.write(token);
          tokenCount++;

          // Hentikan jika sudah mencapai batas token
          if (tokenCount >= maxTokens) {
            _llamaParent!.stop();
          }
        },
        onDone: () {
          if (!completer.isCompleted) {
            completer.complete(buffer.toString().trim());
          }
        },
        onError: (Object error) {
          if (!completer.isCompleted) {
            completer.completeError(error);
          }
        },
      );

      // Bangun prompt lengkap dengan system prompt jika ada
      final fullPrompt = _buildPrompt(prompt, systemPrompt: systemPrompt);

      // Kirim prompt ke isolate
      _llamaParent!.sendPrompt(fullPrompt);

      // Tunggu sampai generasi selesai
      final result = await completer.future;
      await subscription.cancel();

      return result;
    } finally {
      _isGenerating = false;
    }
  }

  /// Versi streaming dari [generateFeedback] yang mengembalikan token
  /// satu per satu via `Stream<String>`.
  ///
  /// Berguna untuk menampilkan teks bertahap di UI (efek "mengetik").
  ///
  /// ```dart
  /// await for (final token in LlmService.instance.generateFeedbackStream(
  ///   'Berikan evaluasi gerakan Sit Up.',
  /// )) {
  ///   setState(() => _responseText += token);
  /// }
  /// ```
  Stream<String> generateFeedbackStream(
    String prompt, {
    int maxTokens = _defaultMaxTokens,
    String? systemPrompt,
  }) {
    _assertReady();

    if (_isGenerating) {
      throw StateError(
        'LlmService: generasi sedang berjalan. '
        'Tunggu hingga selesai sebelum memanggil generateFeedbackStream lagi.',
      );
    }

    _isGenerating = true;

    final controller = StreamController<String>();
    var tokenCount = 0;

    late final StreamSubscription<String> subscription;
    subscription = _llamaParent!.stream.listen(
      (token) {
        controller.add(token);
        tokenCount++;

        if (tokenCount >= maxTokens) {
          _llamaParent!.stop();
        }
      },
      onDone: () {
        _isGenerating = false;
        controller.close();
      },
      onError: (Object error) {
        _isGenerating = false;
        controller.addError(error);
        controller.close();
      },
    );

    // Tutup subscription saat controller di-cancel
    controller.onCancel = () {
      _isGenerating = false;
      subscription.cancel();
    };

    final fullPrompt = _buildPrompt(prompt, systemPrompt: systemPrompt);
    _llamaParent!.sendPrompt(fullPrompt);

    return controller.stream;
  }

  // ---------------------------------------------------------------------------
  // Dispose
  // ---------------------------------------------------------------------------

  /// Melepas resource native engine. Panggil saat aplikasi benar-benar ditutup
  /// atau saat service tidak lagi diperlukan.
  Future<void> dispose() async {
    _llamaParent?.dispose();
    _llamaParent = null;
    _isInitialized = false;
    _isGenerating = false;
  }

  // ---------------------------------------------------------------------------
  // Helper privat
  // ---------------------------------------------------------------------------

  /// Menyusun prompt dalam format ChatML yang dipakai oleh SmolLM2 instruct.
  ///
  /// Format:
  /// ```
  /// <|im_start|>system
  /// {system prompt}<|im_end|>
  /// <|im_start|>user
  /// {user prompt}<|im_end|>
  /// <|im_start|>assistant
  /// ```
  String _buildPrompt(String userPrompt, {String? systemPrompt}) {
    final buffer = StringBuffer();

    // System prompt
    if (systemPrompt != null && systemPrompt.isNotEmpty) {
      buffer.writeln('<|im_start|>system');
      buffer.writeln('$systemPrompt<|im_end|>');
    }

    // User prompt
    buffer.writeln('<|im_start|>user');
    buffer.writeln('$userPrompt<|im_end|>');

    // Mulai respons asisten
    buffer.write('<|im_start|>assistant\n');

    return buffer.toString();
  }

  /// Memastikan file model GGUF sudah tersalin dari bundle assets ke
  /// directory lokal perangkat. File hanya disalin sekali; panggilan
  /// berikutnya langsung mengembalikan path yang sudah ada.
  Future<String> _ensureModelFile() async {
    final appDir = await getApplicationDocumentsDirectory();
    final modelFile = File('${appDir.path}/smollm2-360m-instruct-q4_k_m.gguf');

    if (!await modelFile.exists()) {
      // Salin dari Flutter asset bundle ke filesystem lokal.
      // rootBundle.load mengembalikan ByteData dari asset yang di-bundle.
      final data = await rootBundle.load(_modelAsset);
      await modelFile.writeAsBytes(
        data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes),
        flush: true,
      );
    }

    return modelFile.path;
  }

  /// Memastikan engine sudah siap sebelum operasi apapun.
  void _assertReady() {
    if (!_isInitialized || _llamaParent == null) {
      throw StateError(
        'LlmService belum diinisialisasi. '
        'Panggil LlmService.instance.init() terlebih dahulu.',
      );
    }
  }
}
