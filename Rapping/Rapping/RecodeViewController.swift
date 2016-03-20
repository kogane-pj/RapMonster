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
    @IBOutlet weak var beatTitle: UILabel! {
        didSet {
            beatTitle.text = beat.name
        }
    }
    
    var beat:Beat! = nil
    
    @IBOutlet weak var audioPlot: EZAudioPlot! {
        didSet {
            audioPlot.plotType = EZPlotType.Buffer
            audioPlot.shouldFill = true
            audioPlot.shouldMirror = true
        }
    }
    
    private var mic: EZMicrophone! = {
        let _mic = EZMicrophone.sharedMicrophone()
        _mic.startFetchingAudio()
        _mic.device = EZAudioDevice.inputDevices().last as! EZAudioDevice!
        return _mic
    }()
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        AudioManager.sharedInstance.start()
        self.mic.delegate = self
        
        self.updateSeekTime()
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        AudioManager.sharedInstance.stop()
    }
    
    // MARK: - privae method
    
    private func showSaveAlert() {
        AudioManager.sharedInstance.stopRecord()
        
        let alertView = UNAlertView(title: "録音終了", message: "保存しますか？")
        alertView.addButton("No", backgroundColor: Color.RapOrangeColor, action: {
            AudioManager.sharedInstance.deleteRecordFile()
        })
       
        weak var _self = self
        alertView.addButton("Yes", backgroundColor: Color.RapOrangeColor, action: {
            AudioManager.sharedInstance.saveRecordFile(_self!.beat)
        })
        
        // Show
        alertView.show()
    }
    
    @objc private func updateSeekTime() {
        self.currentTime.text = AudioManager.sharedInstance.getCurretTimeForString()
    }
    
    @IBAction func didTapRecodeButton(sender: AnyObject) {
        if AudioManager.sharedInstance.isRecording() == true {
            self.recodeButton.setImage(UIImage(named: "rec_button"), forState: .Normal)
            AudioManager.sharedInstance.stopRecord()
            showSaveAlert()
            return
        }
        
        self.recodeButton.setImage(UIImage(named: "recode_stop"), forState: .Normal)
        AudioManager.sharedInstance.startRecord(self.beat)
        
        _ = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: Selector("updateSeekTime"), userInfo: nil, repeats: true)
    }
    
    @IBAction func didTapExitButton(sender: AnyObject) {
        self.navigationController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: - Audio mic input delegate

    func microphone(microphone: EZMicrophone!, hasAudioReceived buffer: UnsafeMutablePointer<UnsafeMutablePointer<Float>>, withBufferSize bufferSize: UInt32, withNumberOfChannels numberOfChannels: UInt32) {
        
        dispatch_async(dispatch_get_main_queue(), {() -> Void in
            self.audioPlot.updateBuffer(buffer[0], withBufferSize: bufferSize)
        })
    }
}