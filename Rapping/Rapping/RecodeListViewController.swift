//
//  RecodeListViewController.swift
//  Rapping
//
//  Created by 小出健人 on 2016/02/07.
//  Copyright © 2016年 Dorirus. All rights reserved.
//

import UIKit

class RecodeListViewController: UIViewController,
UITableViewDataSource,
UITableViewDelegate,
RapListTableViewCellDelegate
{
    @IBOutlet weak var rapListTableView: UITableView!
    
    private var selectedIndexPath:NSIndexPath?
    private var rapArray:[Rap] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        AudioManager.sharedInstance.start()
        self.rapArray = RapManager.sharedInstance.allRap
        self.registNib()
    }
    
    private func registNib() {
        let nib = UINib(nibName: "RapListTableViewCell", bundle: nil)
        self.rapListTableView.registerNib(nib, forCellReuseIdentifier: "Cell")
        
        let nib2 = UINib(nibName: "RapListViewSectionCell", bundle: nil)
        self.rapListTableView.registerNib(nib2, forCellReuseIdentifier: "sectionCell")
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1;
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.rapArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.rapListTableView.dequeueReusableCellWithIdentifier("Cell") as! RapListTableViewCell
        
        cell.delegate = self
        let rap = RapManager.sharedInstance.allRap[indexPath.row]
        
        cell.openCellIfNeeded(self.selectedIndexPath == indexPath)
        
        return cell
    }
    
    //MARK: UITableViewDelegate
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.rapListTableView.deselectRowAtIndexPath(indexPath, animated: false)
        
        if self.selectedIndexPath == indexPath {
            self.selectedIndexPath = nil //TODO:定数化
            self.rapListTableView.reloadData()
            return
        }
        
        self.selectedIndexPath = indexPath
        
        let cell = self.rapListTableView.cellForRowAtIndexPath(indexPath) as! RapListTableViewCell
        let rap = RapManager.sharedInstance.allRap[indexPath.row]
        
        cell.openCellIfNeeded(true)
        cell.setupSeek(rap)
        
        self.rapListTableView.reloadData()
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if self.selectedIndexPath == indexPath {
            return 167
        }
        
        return 110;
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 66;
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return self.rapListTableView.dequeueReusableCellWithIdentifier("sectionCell") as! RapListViewSectionCell
    }
    
    //MARK: RapListTableViewCell Delegate
    
    func didTapPlayButton() {
        guard let row = self.selectedIndexPath?.row else{
            //TODO:Alert
            return
        }
        
        if AudioManager.sharedInstance.isPlaying() {
            AudioManager.sharedInstance.stop()
            return
            //TODO:stopボタンがきたらそれを埋め込む
        }
        
        let path = RapManager.sharedInstance.allRap[row].path
        AudioManager.sharedInstance.playRap(path)
    }
    
    func didTapShareButton() {
        ActivityController().showActivityView(self)
    }
    
}
