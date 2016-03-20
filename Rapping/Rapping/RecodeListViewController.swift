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
    UITableViewDelegate
{
    @IBOutlet weak var recodeListTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        AudioManager.sharedInstance.start()
    }
        
    //MARK: UITableViewDataSource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return RapManager.sharedInstance.allRap.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "Cell")
        
        let recode = RapManager.sharedInstance.allRap[indexPath.row]
        
        cell.textLabel?.text = recode.name
        return cell
    }
    
    func tableView(table: UITableView, didSelectRowAtIndexPath indexPath:NSIndexPath) {
        let path = RapManager.sharedInstance.allRap[indexPath.row].path
        AudioManager.sharedInstance.playWithSetupPlayer(path)
    }
}
