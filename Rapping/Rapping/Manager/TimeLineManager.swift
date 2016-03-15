//
//  TimeLineManager.swift
//  Rapping
//
//  Created by 千葉 俊輝 on 2016/03/14.
//  Copyright © 2016年 Dorirus. All rights reserved.
//

import Foundation
import NCMB

class TimeLineManager: NSObject {
    private let CLASS_NAME = "Rap"
    
    static let sharedInstance = TimeLineManager()
    
    var data: [RecordRap] = []
    
    // TODO: ソートして配列に持たせて更新通知送る
    func findRecordRap() {
        let q = NCMBQuery(className: CLASS_NAME)
        q.findObjectsInBackgroundWithBlock({
            (array, error) in
            print(array)
        })
    }
}