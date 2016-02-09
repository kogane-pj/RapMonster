//
//  RecodeViewController.swift
//  Rapping
//
//  Created by 小出健人 on 2016/02/07.
//  Copyright © 2016年 Dorirus. All rights reserved.
//

import UIKit
import AVFoundation

class RecodeViewController: UIViewController,
    AVAudioRecorderDelegate,
    AVAudioPlayerDelegate
{
    @IBOutlet weak var seek: UISlider!
    @IBOutlet weak var currentTime: UILabel!
    @IBOutlet weak var endTime: UILabel!
    @IBOutlet weak var resultView: UIView!
    
    var audioPlayer: AVAudioPlayer!
    var audioSession: AVAudioSession!
    var audioRecorder: AVAudioRecorder!
    var recodeFilePath:NSURL!
    
    @IBOutlet weak var recodeButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupAudioSession()
        self.setupAudioRecoder()
        self.setupSeek()
        
        self.resultView.hidden = true
    }
    
    func setupSeek() {
        self.currentTime.text = String(Float(self.audioPlayer.currentTime))
        self.endTime.text = String(Float(self.audioPlayer.duration))
    }
    
    func setupAudioSession() {
        self.audioSession = AVAudioSession.sharedInstance()
        
        do {
            try self.audioSession.setCategory(AVAudioSessionCategoryMultiRoute)
        } catch { }
        
        do {
            try self.audioSession.setActive(true)
        } catch { }
        
        let path = BeatManager.sharedInstance.allBeat[0].path
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOfURL: path)
        } catch {
            print("error")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func updateSeekTime() {
        self.currentTime.text = String(Float(self.audioPlayer.currentTime))
        self.seek.value = Float(self.audioPlayer.currentTime)
    }
    
    @IBAction func sliderMove(sender: AnyObject) {
        self.audioPlayer.currentTime = Double(seek.value)
        self.updateSeekTime()
    }
    
    @IBAction func didTapRecodeButton(sender: AnyObject) {
        print(self.audioRecorder.recording)
        if self.audioRecorder!.recording == true {
            self.audioRecorder!.stop()
            self.recodeButton.setTitle("録音", forState: .Normal)
            self.audioPlayer.stop()
            
            self.resultView.hidden = false
            return
        }
       
        self.resultView.hidden = true
        let path = BeatManager.sharedInstance.allBeat[0].path
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOfURL: path)
        } catch {
            print("error")
        }
        
        self.audioPlayer.delegate = self
        self.audioPlayer.volume = 1.0
        self.audioPlayer.prepareToPlay()
        self.seek.maximumValue = Float(self.audioPlayer.duration)
        
        self.audioPlayer.play()
        
        var timer = NSTimer()
        
        timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: Selector("updateSeekTime"), userInfo: nil, repeats: true)
        
        print(self.audioRecorder!.record())
        
        self.recodeButton.setTitle("停止", forState: .Normal)
        
    }
    
   
    
    @IBAction func didTapRecodePlayBackButton(sender: AnyObject) {
        //TODO:ここも共通化
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
    
    
    
    
    //TODO:以下共通化する
    func setupAudioRecoder() {
        // 録音用URLを設定
        let dirURL = documentsDirectoryURL()
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
    
    /// DocumentsのURLを取得
    func documentsDirectoryURL() -> NSURL {
        let urls = NSFileManager.defaultManager().URLsForDirectory(NSSearchPathDirectory.DocumentDirectory,
            inDomains: NSSearchPathDomainMask.UserDomainMask)
        
        if urls.isEmpty {
            fatalError("URLs for directory are empty.")
        }
        
        print(urls.description)
        return urls[0]
    }
}

