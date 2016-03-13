//
//  MyPageViewController.swift
//  Rapping
//
//  Created by 小出健人 on 2016/02/18.
//  Copyright © 2016年 Dorirus. All rights reserved.
//

import UIKit

class MyPageViewController: UIViewController,
UITableViewDelegate,
UITableViewDataSource,
RapListTableViewCellDelegate
{
    @IBOutlet weak var recListView: UITableView!
    
    private var rapArray:[Rap] = []
    private var selectedIndexPath:NSIndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.registNib()
        self.setupRapArray()
    }

    func setupRapArray() {
        self.rapArray = RapManager.sharedInstance.allRap
    }

    func registNib() {
        let nib = UINib(nibName: "RapListTableViewCell", bundle: nil)
        self.recListView.registerNib(nib, forCellReuseIdentifier: "Cell")
        
        let nib2 = UINib(nibName: "RapListViewSectionCell", bundle: nil)
        self.recListView.registerNib(nib2, forCellReuseIdentifier: "sectionCell")
    }
    
    //MARK: UITableViewDataSource
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1;
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.rapArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.recListView.dequeueReusableCellWithIdentifier("Cell") as! RapListTableViewCell
        
        cell.delegate = self
        let rap = RapManager.sharedInstance.allRap[indexPath.row]
      
        cell.openCellIfNeeded(self.selectedIndexPath == indexPath)
        
        return cell
    }
  
    //MARK: UITableViewDelegate
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.recListView.deselectRowAtIndexPath(indexPath, animated: false)
        
        if self.selectedIndexPath == indexPath {
            self.selectedIndexPath = nil //TODO:定数化
            self.recListView.reloadData()
            return
        }
        
        self.selectedIndexPath = indexPath
        
        let cell = self.recListView.cellForRowAtIndexPath(indexPath) as! RapListTableViewCell
        let rap = RapManager.sharedInstance.allRap[indexPath.row]
        
        cell.openCellIfNeeded(true)
        cell.setupSeek(rap)
       
        self.recListView.reloadData()
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
        return self.recListView.dequeueReusableCellWithIdentifier("sectionCell") as! RapListViewSectionCell
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
}
