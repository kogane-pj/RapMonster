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
    
    var audioPlayer: AVAudioPlayer!
    var audioSession: AVAudioSession!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupAudioSession()
        self.setupSeek()
    }
   
    func setupSeek() {
        self.currentTime.text = String(Float(self.audioPlayer.currentTime))
        self.endTime.text = String(Float(self.audioPlayer.duration))
    }
    
    func setupAudioSession() {
        self.audioSession = AVAudioSession.sharedInstance()
        
        do {
            try self.audioSession.setCategory(AVAudioSessionCategoryPlayback)
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
        
        self.audioPlayer.delegate = self
        self.audioPlayer.volume = 1.0
        self.audioPlayer.prepareToPlay()
        self.seek.maximumValue = Float(self.audioPlayer.duration)
        
        self.audioPlayer.play()
       
        var timer = NSTimer()
        
        timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: Selector("updateSeekTime"), userInfo: nil, repeats: true)
        
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
}
