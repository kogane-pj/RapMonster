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
    
    var audioPlayer: AVAudioPlayer!
    var audioSession: AVAudioSession!
    var audioRecorder: AVAudioRecorder!
    var recodeFilePath:NSURL!
    
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
   
    //MARK: - Play Rap
    
    func playRap(filePath:NSURL) {
        stopPlayer()
        playWithSetupPlayer(filePath)
    }
   
    func getCurrentTime() -> String {
        return String(Float(self.audioPlayer.currentTime))
    }
    
    func saveRecordFile() {
        FileManager.sharedInstance.uploadFile(NSUUID().UUIDString + ".caf",
            url: self.audioRecorder.url)
    }
    
    func deleteRecordFile() {
        self.audioRecorder.deleteRecording()
    }
    
    func getPlayTimeInfo(contentsOfURL:NSURL) -> (startTime:String, endTime:String) {
        setupPlayerWithContentsOfURL(contentsOfURL)
        
        let startTime = Int(self.audioPlayer.currentTime)
        // 秒数から分数を計算
        let startTimeString = String(format:"%02d:%02d", (startTime/60)%60, startTime%60)
        
        let endTime = Int(self.audioPlayer.duration)
        let endTimeString = String(format:"%02d:%02d", (endTime/60)%60, endTime%60)
        
        return (startTimeString,endTimeString)
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
    
    private func setupPlayerWithContentsOfURL(contentsOfURL: NSURL) {
        do {
            audioPlayer = try AVAudioPlayer(contentsOfURL: contentsOfURL)
        } catch {
            print("error")
        }
        
        self.audioPlayer.delegate = self
    }
    
    // MARK: - AudioRecorderDelgate
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder, successfully flag: Bool) {
    }
}
