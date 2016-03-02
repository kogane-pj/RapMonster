//
//  ViewController.swift
//  Rapping
//
//  Created by 小出健人 on 2016/01/27.
//  Copyright © 2016年 Dorirus. All rights reserved.
//

import UIKit
import AVFoundation
import GoogleMobileAds

class BeatListViewController: UIViewController,
    AVAudioRecorderDelegate,
    AVAudioPlayerDelegate,
    UITableViewDataSource,
    UITableViewDelegate,
    GADBannerViewDelegate,
    BeatTableViewCellDelegate
{
    var audioRecorder: AVAudioRecorder?
    var audioPlayer: AVAudioPlayer!
    // 再生とか録音周りを制御
    var audioSession: AVAudioSession!
    @IBOutlet weak var beatTable: UITableView!
    
    
    @IBOutlet weak var banner: GADBannerView!
    var selectedIndexPath:NSIndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.registerNib()
        self.beatTable.delegate = self;
        self.beatTable.dataSource = self;
        self.setupAudioSession()
        self.setupBanner()
        
        print(GADRequest.sdkVersion)
        let documentsDirectory = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)[0]
        do {
            var recodes = [NSURL]()
            let urls = try NSFileManager.defaultManager().contentsOfDirectoryAtURL(documentsDirectory, includingPropertiesForKeys: nil, options: NSDirectoryEnumerationOptions.SkipsHiddenFiles)
            recodes = urls.filter( { (name: NSURL) -> Bool in
                return name.lastPathComponent!.hasSuffix("mp3")
            })
        } catch let error as NSError {
            print(error.localizedDescription)
        } catch {
            print("something went wrong listing recordings")
        }
       
    }
    
    func setupBanner() {
        self.banner.delegate = self
        self.banner.adUnitID = "ca-app-pub-1112425838421412/4652740283"
        self.banner.rootViewController = self
        self.banner.adSize = kGADAdSizeSmartBannerPortrait
        
        var request:GADRequest = GADRequest()
        
        //TODO:マクロ書く
        #if DEBUG
            print("debug")
            request.testDevices = ["754506767786e0acce9090c3c9028753"]
        #endif
        
        self.banner.loadRequest(request)
        
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
        let format = NSDateFormatter()
        format.dateFormat="yyyy-MM-dd-HH-mm-ss"
        let fileName = "recording-\(format.stringFromDate(NSDate())).caf"
        print(fileName);
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
    
    func registerNib() {
        let nib = UINib(nibName: "BeatTableViewCell", bundle: nil)
        self.beatTable.registerNib(nib, forCellReuseIdentifier: "Cell")
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
        let format = NSDateFormatter()
        format.dateFormat="yyyy-MM-dd-HH-mm-ss"
        let fileName = "recording-\(format.stringFromDate(NSDate())).m4a"
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
    
    //MARK: UITableViewDelegate
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return BeatManager.sharedInstance.allBeat.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = self.beatTable.dequeueReusableCellWithIdentifier("Cell") as! BeatTableViewCell
        
        let beat = BeatManager.sharedInstance.allBeat[indexPath.row]
        cell.titleLabel.text = beat.name
        cell.delegate = self
        
        cell.practiceButton.hidden = (self.selectedIndexPath != indexPath)
        return cell
    }
    
    // 7. セルがタップされた時
    func tableView(table: UITableView, didSelectRowAtIndexPath indexPath:NSIndexPath) {
        if self.selectedIndexPath == indexPath {
            self.audioPlayer.stop()
            self.audioPlayer.prepareToPlay()
            
            return
        }
        
        let path = BeatManager.sharedInstance.allBeat[indexPath.row].path
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOfURL: path)
        } catch {
            print("error")
        }
        
        self.audioPlayer.delegate = self
        self.audioPlayer.volume = 1.0
        self.audioPlayer.prepareToPlay()
        self.audioPlayer.play()
        
        self.selectedIndexPath = indexPath
        self.beatTable.reloadData()
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        print(indexPath)
        if self.selectedIndexPath == indexPath {
            return 204
        }
        
        return 110
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: BeatTableViewCell
    func didTapSelectButton() {
        performSegueWithIdentifier("presentRecVC" ,sender: nil)
    }
    
    //MARK: Ad
    
    func adViewDidReceiveAd(bannerView: GADBannerView!) {
        print("sucess")
    }
    
    func adView(bannerView: GADBannerView!, didFailToReceiveAdWithError error: GADRequestError!) {
        print(error)
    }
   
}

