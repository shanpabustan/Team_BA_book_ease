import 'dart:async';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class VoiceToTextService {
  final stt.SpeechToText _speech = stt.SpeechToText();
  bool _isListening = false;
  bool get isListening => _isListening;

  Future<bool> initialize() async {
    bool available = await _speech.initialize(
      onStatus: (status) {
        print('Speech status: $status');
        if (status == 'notListening') {
          _isListening = false;
        }
      },
      onError: (error) {
        print('Speech error: $error');
        _isListening = false;
      },
    );

    return available;
  }

  Future<String?> startListening() async {
    Completer<String?> completer = Completer<String?>();

    if (!_speech.isAvailable) {
      print("Speech recognition is not available.");
      return null;
    }

    if (_isListening) {
      print("Already listening...");
      return null;
    }

    _isListening = true;

    _speech.listen(
      onResult: (result) {
        if (result.finalResult) {
          _isListening = false;
          completer.complete(result.recognizedWords);
        }
      },
      cancelOnError: true,
      partialResults: false,
    );

    return completer.future;
  }

  void stopListening() {
    if (_isListening) {
      _speech.stop();
      _isListening = false;
    }
  }
}
