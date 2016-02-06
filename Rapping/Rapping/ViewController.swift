//
//  ViewController.swift
//  Rapping
//
//  Created by 小出健人 on 2016/01/27.
//  Copyright © 2016年 Dorirus. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController,
    AVAudioRecorderDelegate,
    AVAudioPlayerDelegate,
    UITableViewDataSource,
    UITableViewDelegate
{
    var audioRecorder: AVAudioRecorder?
    var audioPlayer: AVAudioPlayer!
    // 再生とか録音周りを制御
    var audioSession: AVAudioSession!
    @IBOutlet weak var beatTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.beatTable.delegate = self;
        self.beatTable.dataSource = self;
        self.setupAudioSession()
    
    }
    
    func setupAudioSession() {
        self.audioSession = AVAudioSession.sharedInstance()
        
        do {
            try self.audioSession.setCategory(AVAudioSessionCategoryMultiRoute)
        } catch { }
        
        do {
            try self.audioSession.setActive(true)
        } catch { }
    }
    
    func setupAudioRecorder() {
        // 録音用URLを設定
        let dirURL = documentsDirectoryURL()
        let fileName = "recording" + ".wav"
        let recordingsURL = dirURL.URLByAppendingPathComponent(fileName)
        
        // 録音設定
        let recordSettings: [String: AnyObject] =
        [AVEncoderAudioQualityKey: AVAudioQuality.Max.rawValue,
            AVEncoderBitRateKey: 16,
            AVNumberOfChannelsKey: 2,
            AVSampleRateKey: 44100.0]
        
        do {
            audioRecorder = try AVAudioRecorder(URL: recordingsURL, settings: recordSettings)
        } catch {
            audioRecorder = nil
        }
        
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
    
    @IBAction func didTapRecodeButton(sender: AnyObject) {
        self.setupAudioRecorder();
        self.audioRecorder?.record()
    }
    
    @IBAction func didTapRecodeStopButton(sender: AnyObject) {
        self.audioRecorder?.stop()
    }
    
    @IBAction func didTapPlayBackButton(sender: AnyObject) {
        
        // 録音用URLを設定
        let dirURL = documentsDirectoryURL()
        let fileName = "recording.wav"
        let recordingsURL = dirURL.URLByAppendingPathComponent(fileName)
       
        
        // auido を再生するプレイヤーを作成する
    
        do {
            audioPlayer = try AVAudioPlayer(contentsOfURL: recordingsURL)
        }
        catch {
            print("error")
        }
        
        self.audioPlayer!.delegate = self
        self.audioPlayer!.prepareToPlay()
        self.audioPlayer.play()
    }
    
    @IBAction func didTapBeatButton(sender: AnyObject) {
        // 再生する audio ファイルのパスを取得
        let audioPath = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("FS_89BPM", ofType: "mp3")!)
        // auido を再生するプレイヤーを作成する

        do {
            audioPlayer = try AVAudioPlayer(contentsOfURL: audioPath)
        } catch {
            print("error")
        }

        
        self.audioPlayer.delegate = self
        self.audioPlayer.volume = 1.0   
        self.audioPlayer.prepareToPlay()
        self.audioPlayer.play()
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return BeatManager.sharedInstance.getAll().count
    }
    
    
    // セルのテキストを追加
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "Cell")
       
        let beat = BeatManager.sharedInstance.getAll()[indexPath.row]
        cell.textLabel?.text = beat.name
        return cell
    }
    
    // 7. セルがタップされた時
    func tableView(table: UITableView, didSelectRowAtIndexPath indexPath:NSIndexPath) {
        let path = BeatManager.sharedInstance.getAll()[indexPath.row].path
 
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
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    
}

