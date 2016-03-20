//
//  ViewController.swift
//  Rapping
//
//  Created by 小出健人 on 2016/01/27.
//  Copyright © 2016年 Dorirus. All rights reserved.
//

import UIKit
import GoogleMobileAds

class BeatListViewController: UIViewController,
    UITableViewDataSource,
    UITableViewDelegate,
    GADBannerViewDelegate,
    BeatTableViewCellDelegate
{
    @IBOutlet weak var beatTable: UITableView!
    @IBOutlet weak var banner: GADBannerView!
    
    private var selectedIndexPath:NSIndexPath?
    
    // MARK: - Lyfe cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerNib()
        setupBanner()
        testLog()
        
        AudioManager.sharedInstance.start()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Private
    private func registerNib() {
        let nib = UINib(nibName: "BeatTableViewCell", bundle: nil)
        self.beatTable.registerNib(nib, forCellReuseIdentifier: "Cell")
    }
    
    private func setupBanner() {
        self.banner.delegate = self
        self.banner.adUnitID = "ca-app-pub-1112425838421412/4652740283"
        self.banner.rootViewController = self
        self.banner.adSize = kGADAdSizeSmartBannerPortrait
        
        let request:GADRequest = GADRequest()
        
        //TODO:マクロ書く
        #if DEBUG
            print("debug")
            request.testDevices = ["754506767786e0acce9090c3c9028753"]
        #endif
        
        self.banner.loadRequest(request)
    }

    private func testLog() {
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
    
    /// DocumentsのURLを取得
    private func documentsDirectoryURL() -> NSURL {
        let urls = NSFileManager.defaultManager().URLsForDirectory(NSSearchPathDirectory.DocumentDirectory,
            inDomains: NSSearchPathDomainMask.UserDomainMask)
        
        if urls.isEmpty {
            fatalError("URLs for directory are empty.")
        }
        
        print(urls.description)
        return urls[0]
    }
    
    // MARK: - IBAction
    @IBAction func didTapRecodeButton(sender: AnyObject) {
        AudioManager.sharedInstance.startRecord()
    }
    
    @IBAction func didTapRecodeStopButton(sender: AnyObject) {
        AudioManager.sharedInstance.stopRecord()
    }
    
    @IBAction func didTapPlayBackButton(sender: AnyObject) {
        AudioManager.sharedInstance.playBackRecord()
    }
    
    @IBAction func didTapBeatButton(sender: AnyObject) {
        // 再生する audio ファイルのパスを取得
        let audioPath = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("FS_89BPM", ofType: "mp3")!)
        // auido を再生するプレイヤーを作成する
        AudioManager.sharedInstance.playWithSetupPlayer(audioPath)
    }
    
    
    //MARK: UITableViewDelegate
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return BeatManager.sharedInstance.allBeat.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.beatTable.dequeueReusableCellWithIdentifier("Cell") as! BeatTableViewCell
        
        let beat = BeatManager.sharedInstance.allBeat[indexPath.row]
        cell.titleLabel.text    = beat.name
        cell.beatImage.image    = beat.image
        cell.artistLabel.text   = beat.artist
        cell.delegate           = self
        
        cell.practiceButton.hidden = (self.selectedIndexPath != indexPath)
        
        return cell
    }
    
    // 7. セルがタップされた時
    func tableView(table: UITableView, didSelectRowAtIndexPath indexPath:NSIndexPath) {
        if self.selectedIndexPath == indexPath {
            AudioManager.sharedInstance.stopPlayer()
            self.selectedIndexPath = nil //TODO:定数化
            self.beatTable.reloadData()
            return
        }
        
        let path = BeatManager.sharedInstance.allBeat[indexPath.row].path
        AudioManager.sharedInstance.playWithSetupPlayer(path)

        self.selectedIndexPath = indexPath
        self.beatTable.reloadData()
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        print(indexPath)
        if self.selectedIndexPath == indexPath {
            return 204
        }
        
        return 112
    }
    
    //MARK: BeatTableViewCellDelegate
    func didTapSelectButton() {
        AudioManager.sharedInstance.stopPlayer()
        performSegueWithIdentifier("presentRecVC" ,sender: nil)
    }
    
    //MARK: Ad
    
    func adViewDidReceiveAd(bannerView: GADBannerView!) {
        print("sucess")
    }
    
    func adView(bannerView: GADBannerView!, didFailToReceiveAdWithError error: GADRequestError!) {
        print(error)
    }
  
    //MARK: Segue
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        guard let _ = segue.identifier else {
            return
        }
        
        //TODO:UIUtilまとめたい
        //TODO:他のVCも立ち上げる必要があればここで分岐処理
        let naviCon = segue.destinationViewController as! UINavigationController
        let recodeVC = naviCon.viewControllers.first as! RecodeViewController
       
        recodeVC.beat = BeatManager.sharedInstance.allBeat[self.selectedIndexPath!.row]
    }
}

