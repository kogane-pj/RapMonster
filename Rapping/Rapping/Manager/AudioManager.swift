//
//  AudioManager.swift
//  Rapping
//
//  Created by 千葉 俊輝 on 2016/03/05.
//  Copyright © 2016年 Dorirus. All rights reserved.
//

import AVFoundation

class AudioManager: NSObject, AVAudioRecorderDelegate, AVAudioPlayerDelegate {
    
    static let sharedInstance = AudioManager()
    
    private var audioPlayer: AVAudioPlayer!
    private var audioSession: AVAudioSession!
    private var audioRecorder: AVAudioRecorder!
    private var recodeFilePath:NSURL!
    
    override init() {
        super.init()
        start()
    }
    
    func start() {
        setupAudioSession()
        setupAudioRecoder()
        self.audioPlayer.delegate = self
        self.audioRecorder.delegate = self
    }
    
    func stop() {
        self.audioRecorder.stop()
        self.audioPlayer.stop()
        self.audioPlayer.delegate = nil
        self.audioRecorder.delegate = nil
    }
    
    func setupAudioSession() {
        setAudioSessionWithBeatIndex(0)
    }
    
    func setAudioSessionWithBeatIndex(index: Int) {
        self.audioSession = AVAudioSession.sharedInstance()
        
        do {
            try self.audioSession.setCategory(AVAudioSessionCategoryMultiRoute)
        } catch { }
        
        do {
            try self.audioSession.setActive(true)
        } catch { }
        
        let path = BeatManager.sharedInstance.allBeat[index].path
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOfURL: path)
        } catch {
            print("error")
        }
    }
    
    func setupAudioRecoder() {
        // 録音用URLを設定
        let dirURL = getDocumentsDirectoryURL()
        let format = NSDateFormatter()
        format.dateFormat="yyyy-MM-dd-HH-mm-ss"
        let fileName = "recording-\(format.stringFromDate(NSDate())).caf"
        let recordingsURL = dirURL.URLByAppendingPathComponent(fileName)
        
        self.recodeFilePath = recordingsURL
        // 録音設定
        let recordSettings: [String: AnyObject] =
        [AVEncoderAudioQualityKey: AVAudioQuality.Max.rawValue,
            AVEncoderBitRateKey: 16,
            AVNumberOfChannelsKey: 2,
            AVSampleRateKey: 44100.0]
        
        do {
            self.audioRecorder = try AVAudioRecorder(URL: recordingsURL, settings: recordSettings)
        } catch {
            self.audioRecorder = nil
        }
        
        self.audioRecorder.prepareToRecord()
    }
    
    private func getDocumentsDirectoryURL() -> NSURL {
        let urls = NSFileManager.defaultManager().URLsForDirectory(NSSearchPathDirectory.DocumentDirectory,
            inDomains: NSSearchPathDomainMask.UserDomainMask)
        
        if urls.isEmpty {
            fatalError("URLs for directory are empty.")
        }
        
        print(urls.description)
        return urls[0]
    }
    
    private func playBeat() {
        playBeat(0)
    }
    
    private func playBeat(index: Int) {
        playWithSetupPlayer(BeatManager.sharedInstance.allBeat[index].path)
    }
    
    func startRecord(beatIndex: Int) {
        playBeat(beatIndex)
        self.audioRecorder.record()
    }
    
    func startRecord() {
        playBeat()
        self.audioRecorder.record()
    }
    
    func stopRecord() {
        if isRecording() == true {
            self.audioRecorder.stop()
            self.audioPlayer.stop()
        }
    }
    
    func playBackRecord() {
        stopPlayer()
        playWithSetupPlayer(self.recodeFilePath)
    }
    
    func isRecording() -> Bool {
        return self.audioRecorder.recording
    }
  
    func isPlaying() -> Bool {
        return self.audioPlayer.playing
    }
    
    //MARK: - Play Rap
    
    func playRap(filePath:NSURL) {
        stopPlayer()
        
        // 一時停止の場合を考慮
        // TODO:playRap以外も同じ処理必要そう
        if self.audioPlayer.currentTime > 0 {
            play()
            return
        }
        
        playWithSetupPlayer(filePath)
    }
   
    func getCurrentTime() -> Float {
        return Float(self.audioPlayer.currentTime)
    }
   
    // 00:00形式にフォーマットされた現在再生時間を返す
    func getCurretTimeForString() -> String {
        return convertTimeFormat("%02d:%02d", time: self.audioPlayer.currentTime)
    }
    
    func setCurrentTime(value:Double) {
        self.audioPlayer.currentTime = value
    }
    
    func saveRecordFile() {
        FileManager.sharedInstance.uploadFile(NSUUID().UUIDString + ".caf",
            url: self.audioRecorder.url)
    }
    
    func deleteRecordFile() {
        self.audioRecorder.deleteRecording()
    }
   
    //あとで細分化するかも
    func getPlayEndTimeInfo(contentsOfURL:NSURL) -> (endTimeString:String, endTime:Float) {
        setupPlayerWithContentsOfURL(contentsOfURL)
        
        // 秒数から分数を計算
        let endTimeString   = convertTimeFormat("%02d:%02d", time: self.audioPlayer.duration)
        
        return (endTimeString,Float(self.audioPlayer.duration))
    }
    
    // MARK: - Private Method
    
    private func stopPlayer() {
        self.audioPlayer.stop()
        self.audioPlayer.prepareToPlay()
    }
    
    private func playWithSetupPlayer(contentsOfURL: NSURL) {
        do {
            audioPlayer = try AVAudioPlayer(contentsOfURL: contentsOfURL)
        } catch {
            print("error")
        }
        
        self.audioPlayer.delegate = self
        self.audioPlayer.volume = 1.0
        self.audioPlayer.prepareToPlay()
        self.audioPlayer.play()
    }
    
    private func play () {
        self.audioPlayer.delegate = self
        self.audioPlayer.volume = 1.0
        self.audioPlayer.prepareToPlay()
        self.audioPlayer.play()
    }
    
    private func setupPlayerWithContentsOfURL(contentsOfURL: NSURL) {
        do {
            audioPlayer = try AVAudioPlayer(contentsOfURL: contentsOfURL)
        } catch {
            print("error")
        }
        
        self.audioPlayer.delegate = self
    }
    
    private func convertTimeFormat(format:String,time:NSTimeInterval) -> String {
        let time = Int(time)
        return String(format:format, (time/60)%60, time%60)
    }
    
    
    // MARK: - AudioRecorderDelgate
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder, successfully flag: Bool) {
    }
}
