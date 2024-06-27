import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';
import 'package:path/path.dart' as path;
import 'package:vv/Notes/voice/home/manager/audio_recorder_manager/audio_recorder_file_helper.dart';
import 'package:vv/Notes/voice/home/model/voice_note_model.dart';


class AudioRecorderController{
  final AudioRecorderFileHelper _audioRecorderFileHelper;
  final Function(String message) onError;
  AudioRecorderController(this._audioRecorderFileHelper, this.onError);

  //CONTROLLERS
  final StreamController<int> _recordDurationController = StreamController<int>.broadcast()..add(0);

  //SINK
  Sink<int> get recordDurationInput => _recordDurationController.sink;

  //STREAMS
  Stream<double> get amplitudeStream => _audioRecorder
      .onAmplitudeChanged(const Duration(milliseconds: 180)).map((amp) => amp.current);
  Stream<RecordState> get recordStateStream => _audioRecorder.onStateChanged();

  Stream<int> get recordDurationOutput => _recordDurationController.stream;

  //VARIABLES
  final AudioRecorder _audioRecorder = AudioRecorder();
  Timer? _timer;
  int _recordDuration = 0;

  void _startTimer(){
    _timer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
      _recordDuration++;
      recordDurationInput.add(_recordDuration);
    });
  }

  //METHODS
  Future<void> start() async{
    final isMicPermissionGranted = await _checkMicPermissions();

    if(!isMicPermissionGranted){
      onError("Could not grant mic permission");
      return;
    }

    try{
      final filePath = path.join(
         (await _audioRecorderFileHelper.getRecordsDirectory).path,
        "${DateTime.now().millisecondsSinceEpoch}" /////////////////////////////////////////
      );

      await _audioRecorder.start(
        const RecordConfig(),
        path: filePath
      );

      _startTimer();
    }catch(e){
      onError("Could not start the record");
    }
  }

  void resume(){
    _startTimer();
    _audioRecorder.resume();
  }

  Future<void> pause() async{
    _timer?.cancel();
    await _audioRecorder.pause();
  }

  void stop(Function(VoiceNoteModel? voiceNoteModel) onStop) async{
    final recordPath = await _audioRecorder.stop();
    if (recordPath != null){
      onStop(
        VoiceNoteModel(
          name: path.basename(recordPath),
          createAt: DateTime.now().subtract(Duration(seconds: _recordDuration)),
          path: recordPath
        )
      );
    }else{
      onStop(null);
      onError("Could not stop the record".tr());
    }

  }

  Future<void> delete(String filePath) async{
    await pause();

    try{
      await _audioRecorderFileHelper.deleteRecord(filePath);
    }catch(e){
      onError("Could not delete the record".tr());
    }
  }

  void dispose(){
    _recordDurationController.close();
    _timer?.cancel();
    _timer = null;
    _audioRecorder.dispose();
  }

  Future<bool> _checkMicPermissions() async{
    const micPermission = Permission.microphone;

    if (await micPermission.isGranted){
      return true;
    }else{
      final permissionStatus = await micPermission.request();

      if(permissionStatus.isGranted || permissionStatus.isLimited){
        return true;
      }else{
        return false;
      }
    }
  }
}