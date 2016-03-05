//
//  AudioController.swift
//  Rapping
//
//  Created by 千葉 俊輝 on 2016/03/05.
//  Copyright © 2016年 Dorirus. All rights reserved.
//

import AVFoundation

class AudioController: NSObject, AVAudioRecorderDelegate, AVAudioPlayerDelegate {
    
    static let sharedInstance = AudioController()
    
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
    }
    
    func stop() {
        self.audioPlayer.delegate = nil
        self.audioRecorder.stop()
        self.audioPlayer.stop()
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
        let path = BeatManager.sharedInstance.allBeat[index].path
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOfURL: path)
        } catch {
            print("error")
        }
        
        self.audioPlayer.delegate = self
        self.audioPlayer.volume = 1.0
        self.audioPlayer.prepareToPlay()
        self.audioPlayer.play()
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
        self.audioPlayer.stop()
        self.audioPlayer.prepareToPlay()
        
        let path = self.recodeFilePath
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOfURL: path)
        } catch {
            print("error")
        }
        
        self.audioPlayer.delegate = self
        self.audioPlayer.volume = 1.0
        self.audioPlayer.prepareToPlay()
        self.audioPlayer.play()
    }
    
    func isRecording() -> Bool {
        return self.audioRecorder.recording
    }
    
    func getCurrentTime() -> String {
        return String(Float(self.audioPlayer.currentTime))
    }
}
