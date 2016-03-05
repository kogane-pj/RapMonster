//
//  RecodeViewController.swift
//  Rapping
//
//  Created by 小出健人 on 2016/02/07.
//  Copyright © 2016年 Dorirus. All rights reserved.
//

import UIKit
import EZAudio
import UNAlertView

class RecodeViewController: UIViewController, EZMicrophoneDelegate
{
    @IBOutlet weak var currentTime: UILabel!
    @IBOutlet weak var recodeButton: UIButton!
    @IBOutlet weak var audioPlot: EZAudioPlot! {
        didSet {
            audioPlot.plotType = EZPlotType.Buffer
            audioPlot.shouldFill = true
            audioPlot.shouldMirror = true
        }
    }
    
    private var audioFile: EZAudioFile!
    private var mic: EZMicrophone! = {
        let _mic = EZMicrophone.sharedMicrophone()
        _mic.startFetchingAudio()
        _mic.device = EZAudioDevice.inputDevices().last as! EZAudioDevice!
        return _mic
    }()
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        AudioController.sharedInstance.start()
        self.mic.delegate = self
        
        self.setupSeek()
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        AudioController.sharedInstance.stop()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func microphone(microphone: EZMicrophone!, hasAudioReceived buffer: UnsafeMutablePointer<UnsafeMutablePointer<Float>>, withBufferSize bufferSize: UInt32, withNumberOfChannels numberOfChannels: UInt32) {
        
        dispatch_async(dispatch_get_main_queue(), {() -> Void in
            self.audioPlot.updateBuffer(buffer[0], withBufferSize: bufferSize)
        })
    }
    
    func setupSeek() {
        self.currentTime.text = AudioController.sharedInstance.getCurrentTime()
    }
    
    func updateSeekTime() {
        self.currentTime.text = AudioController.sharedInstance.getCurrentTime()
    }
    
    
    // MARK: - IBAction
    @IBAction func sliderMove(sender: AnyObject) {
        self.updateSeekTime()
    }
    
    @IBAction func didTapRecodeButton(sender: AnyObject) {
        if AudioController.sharedInstance.isRecording() == true {
            AudioController.sharedInstance.stopRecord()
            self.recodeButton.setTitle("録音", forState: .Normal)
            AudioController.sharedInstance.stop()
            showSaveAlert()
            return
        }
        let randomIndex = Int(arc4random()) % BeatManager.sharedInstance.allBeat.count
        AudioController.sharedInstance.startRecord(randomIndex)
        
        _ = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: Selector("updateSeekTime"), userInfo: nil, repeats: true)
        
        self.recodeButton.setTitle("停止", forState: .Normal)
    }
    
    private func showSaveAlert() {
        let alertView = UNAlertView(title: "録音終了", message: "保存しますか？")
        
        alertView.addButton("No", backgroundColor: RapOrangeColor, action: {
            print("No action")
        })
        
        alertView.addButton("Yes", backgroundColor: RapOrangeColor, action: {
            
            self.saveData()
            print("Yes action")
        })
        // Show
        alertView.show()
    }
    
    private func saveData() {
        // TODO: 録音したファイルをアップロード
    }
   
    
    @IBAction func didTapRecodePlayBackButton(sender: AnyObject) {
        AudioController.sharedInstance.playBackRecord()
    }
    
    @IBAction func didTapExitButton(sender: AnyObject) {
        self.navigationController?.dismissViewControllerAnimated(true, completion: nil)
    }
}