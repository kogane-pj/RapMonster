//
//  RecodeListViewController.swift
//  Rapping
//
//  Created by 小出健人 on 2016/02/07.
//  Copyright © 2016年 Dorirus. All rights reserved.
//

import UIKit
import AVFoundation

class RecodeListViewController: UIViewController,
    AVAudioRecorderDelegate,
    AVAudioPlayerDelegate,
    UITableViewDataSource,
    UITableViewDelegate
{
    @IBOutlet weak var recodeListTableView: UITableView!
    
    var audioPlayer: AVAudioPlayer!
    var audioSession: AVAudioSession!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.recodeListTableView.delegate = self;
        self.recodeListTableView.dataSource = self;
        
        self.setupAudioSession();
    }
    
    func setupAudioSession() {
        self.audioSession = AVAudioSession.sharedInstance()
        
        do {
            try self.audioSession.setCategory(AVAudioSessionCategoryPlayback)
        } catch { }
        
        do {
            try self.audioSession.setActive(true)
        } catch { }
    }
    
    //MARK: UITableViewDataSource
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return RecodeManager.sharedInstance.allRecode.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "Cell")
        
        let recode = RecodeManager.sharedInstance.allRecode[indexPath.row]
        
        cell.textLabel?.text = recode.name
        return cell
    }
    
    func tableView(table: UITableView, didSelectRowAtIndexPath indexPath:NSIndexPath) {
        let path = RecodeManager.sharedInstance.allRecode[indexPath.row].path
        
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
}
