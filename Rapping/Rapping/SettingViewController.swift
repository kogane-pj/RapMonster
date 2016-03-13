//
//  SettingViewController.swift
//  Rapping
//
//  Created by 小出健人 on 2016/03/13.
//  Copyright © 2016年 Dorirus. All rights reserved.
//

import UIKit

class SettingViewController: UIViewController
{

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func didTapExitButton(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

}
