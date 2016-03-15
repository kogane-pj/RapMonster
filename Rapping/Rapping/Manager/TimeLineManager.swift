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
    func didLoadData(raps: [RecordRap])
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
                self.delegate?.didLoadData(raps)
            }
        })
    }
    
    func getRaps() -> [RecordRap] {
        return self._data
    }
}