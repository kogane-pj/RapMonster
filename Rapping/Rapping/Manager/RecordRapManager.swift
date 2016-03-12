//
//  RecordRapManager.swift
//  Rapping
//
//  Created by 千葉 俊輝 on 2016/03/13.
//  Copyright © 2016年 Dorirus. All rights reserved.
//


import Foundation
import NCMB

class RecordRapManager: NSObject {
    static let sharedInstance = RecordRapManager()
    
    func save(fileName: String, url: NSURL) {
        if let _url = FileManager.sharedInstance.uploadFile(fileName, url: url, defaultUrl: nil) {
            let rap = RecordRap()
            rap.url = _url.description
            rap.rapperId = UserManager.sharedInstance.currentUser().id
            var error: NSError?
            rap.save(&error)
        }
    }
}

class RecordRap: NCMBObject, NSCoding {
    private let CLASS_NAME = "Rap"
    
    var rapperId: String = "" {
        didSet {
            self.setObject(rapperId, forKey: RecordRapKey.rapperIdKey)
        }
    }
    var title: String = "" {
        didSet {
            self.setObject(title, forKey: RecordRapKey.titleKey)
        }
    }
    var url: String = "" {
        didSet {
            self.setObject(url, forKey: RecordRapKey.urlKey)
        }
    }
    var beatTitle: String = "" {
        didSet {
            self.setObject(beatTitle, forKey: RecordRapKey.beatTitleKey)
        }
    }
    var beatCreaterName: String = "" {
        didSet {
            self.setObject(beatCreaterName, forKey: RecordRapKey.beatCreaterNameKey)
        }
    }
    var like: Int = 0 {
        didSet {
            self.setObject(like, forKey: RecordRapKey.likeKey)
        }
    }
    
    override init() {
        super.init(className: CLASS_NAME)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(className: CLASS_NAME)
        if let o = aDecoder.decodeObjectForKey(RecordRapKey.objIdKey) as? String {
            self.objectId = o
        }
        if let ri = aDecoder.decodeObjectForKey(RecordRapKey.rapperIdKey) as? String {
            self.rapperId = ri
            self.setObject(ri, forKey: RecordRapKey.rapperIdKey)
        }
        if let t = aDecoder.decodeObjectForKey(RecordRapKey.titleKey) as? String {
            self.title = t
            self.setObject(t, forKey: RecordRapKey.titleKey)
        }
        if let u = aDecoder.decodeObjectForKey(RecordRapKey.urlKey) as? String {
            self.url = u
            self.setObject(u, forKey: RecordRapKey.urlKey)
        }
        if let bt = aDecoder.decodeObjectForKey(RecordRapKey.beatTitleKey) as? String {
            self.beatTitle = bt
            self.setObject(bt, forKey: RecordRapKey.beatTitleKey)
        }
        if let bc = aDecoder.decodeObjectForKey(RecordRapKey.beatCreaterNameKey) as? String {
            self.beatCreaterName = bc
            self.setObject(bc, forKey: RecordRapKey.beatCreaterNameKey)
        }
        if let l = aDecoder.decodeObjectForKey(RecordRapKey.likeKey) as? Int {
            self.like = l
            self.setObject(l, forKey: RecordRapKey.likeKey)
        }
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(objectId, forKey: RecordRapKey.objIdKey)
        aCoder.encodeObject(rapperId, forKey: RecordRapKey.rapperIdKey)
        aCoder.encodeObject(title, forKey: RecordRapKey.titleKey)
        aCoder.encodeObject(url, forKey: RecordRapKey.urlKey)
        aCoder.encodeObject(beatTitle, forKey: RecordRapKey.beatTitleKey)
        aCoder.encodeObject(beatCreaterName, forKey: RecordRapKey.beatCreaterNameKey)
        aCoder.encodeObject(like, forKey: RecordRapKey.likeKey)
    }
}

struct RecordRapKey {
    static let objIdKey: String             = "objectId"
    static let rapperIdKey: String          = "rapperId"
    static let titleKey: String             = "title"
    static let urlKey: String               = "url"
    static let beatTitleKey: String         = "beatTitle"
    static let beatCreaterNameKey: String   = "beatCreaterName"
    static let likeKey: String              = "like"
}
