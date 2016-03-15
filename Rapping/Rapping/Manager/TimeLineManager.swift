//
//  TimeLineManager.swift
//  Rapping
//
//  Created by 千葉 俊輝 on 2016/03/14.
//  Copyright © 2016年 Dorirus. All rights reserved.
//

import Foundation
import NCMB

protocol TimeLineManagerDelegate: class {
    func didLoadData()
    //func didLoadData(raps: [RecordRap])
}

class TimeLineManager: NSObject {
    private let CLASS_NAME = "Rap"
    private var _data: [RecordRap] = []

    static let sharedInstance = TimeLineManager()
    weak var delegate: TimeLineManagerDelegate?
    
    override init() {
        super.init()
        reloadRapsData()
    }
    
    func reloadRapsData() {
        self._data = []
        let q = NCMBQuery(className: CLASS_NAME)
        q.findObjectsInBackgroundWithBlock({
            (array, error) in
            if let raps = array as? [RecordRap] {
                self._data = raps
                self.delegate?.didLoadData()
                //self.delegate?.didLoadData(raps)
            }
        })
    }
    
    func getRaps() -> [RecordRap] {
        return self._data
    }
}

class TimeLineDataSource: NSObject, UITableViewDataSource, TimeLineManagerDelegate {
    private let CELL_NAME = ""
    
    @IBOutlet weak var tableView: UITableView!
    
    override init() {
        super.init()
        TimeLineManager.sharedInstance.delegate = self
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return TimeLineManager.sharedInstance.getRaps().count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCellWithIdentifier(CELL_NAME) {
            return cell
        }
        
        return UITableViewCell()
    }
    
    // MARK: - TimeLineManagerDelegate
    func didLoadData() {
        self.tableView.reloadData()
    }
}