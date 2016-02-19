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
UITableViewDataSource
{
    @IBOutlet weak var recListView: UITableView!
    
    var rapArray:[Rap] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.recListView.delegate = self
        self.recListView.dataSource = self
        
        self.registNib()
        self.setupRapArray()
        // Do any additional setup after loading the view.
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
        var cell = self.recListView.dequeueReusableCellWithIdentifier("Cell") as! RapListTableViewCell
        let beat = BeatManager.sharedInstance.allBeat[indexPath.row]
       
        return cell
    }
  
    //MARK: UITableViewDelegate
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 84;
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50;
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var cell = self.recListView.dequeueReusableCellWithIdentifier("sectionCell") as! RapListViewSectionCell
        return cell
    }
   
}
