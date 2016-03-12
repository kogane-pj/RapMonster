//
//  User.swift
//  Rapping
//
//  Created by 千葉 俊輝 on 2016/03/11.
//  Copyright © 2016年 Dorirus. All rights reserved.
//

import Foundation
import NCMB
import KeychainAccess

protocol UserManagerDelegate: class {
    func refreshUserInfo()
}

class UserManager: NSObject {
    static let sharedInstance = UserManager()
    private let keychain = Keychain(service: "com.rapmonster")
    private let USER_KEY = "UserKey"
    
    weak var delegate: UserManagerDelegate?
    
    override init() {
        super.init()
    }
    
    func currentUser() -> User {
        if let data = NSUserDefaults.standardUserDefaults().objectForKey(USER_KEY) as? NSData {
            if let user = NSKeyedUnarchiver.unarchiveObjectWithData(data) as? User {
                return user
            }
        }
        
        let _user = User()
        if let userID = keychain[KeychainUserKey.idKey] {
            _user.id = userID
        }
        else {
            _user.id = NSUUID().UUIDString
            keychain[KeychainUserKey.idKey] = _user.id
        }
        if let objectID = keychain[KeychainUserKey.objectIdKey] {
            _user.objectId = objectID
        }

        saveUser(_user)
        return _user
    }
    
    func updateName(name: String) {
        let user = currentUser()
        user.name = name
        user.setObject(name, forKey: UserKey.nameKey)
        saveUser(user)
      }
    
    func updateImage(image: String) {
        let user = currentUser()
        user.image = image
        user.setObject(image, forKey: UserKey.imageKey)
        saveUser(user)
    }
    
    private func saveUser(user: User) {
        var error: NSError?
        user.save(&error)
        if error == nil {
            let encodedData = NSKeyedArchiver.archivedDataWithRootObject(user)
            NSUserDefaults.standardUserDefaults().setObject(encodedData, forKey: USER_KEY)
            NSUserDefaults.standardUserDefaults().synchronize()
            keychain[KeychainUserKey.objectIdKey] = user.objectId
            self.delegate?.refreshUserInfo()
        }
    }
}

struct KeychainUserKey {
    static let idKey: String            = "USER_ID"
    static let objectIdKey: String      = "OBJECT_ID"
}

class User: NCMBObject, NSCoding {
    var id: String = "" {
        didSet {
            self.setObject(id, forKey: UserKey.idKey)
        }
    }
    var name: String = "" {
        didSet {
            self.setObject(name, forKey: UserKey.nameKey)
        }
    }
    var image: String = "" {
        didSet {
            self.setObject(image, forKey: UserKey.imageKey)
        }
    }
    
    private let CLASS_NAME = "User"
    
    override init() {
        super.init(className: CLASS_NAME)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(className: CLASS_NAME)
        if let o = aDecoder.decodeObjectForKey(UserKey.objIdKey) as? String {
            self.objectId = o
        }
        if let i = aDecoder.decodeObjectForKey(UserKey.idKey) as? String {
            self.id = i
            self.setObject(i, forKey: UserKey.idKey)
        }
        if let n = aDecoder.decodeObjectForKey(UserKey.nameKey) as? String {
            self.name = n
            self.setObject(n, forKey: UserKey.nameKey)
        }
        if let im = aDecoder.decodeObjectForKey(UserKey.imageKey) as? String {
            self.image = im
            self.setObject(im, forKey: UserKey.imageKey)
        }
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(objectId, forKey: UserKey.objIdKey)
        aCoder.encodeObject(id, forKey: UserKey.idKey)
        aCoder.encodeObject(name, forKey: UserKey.nameKey)
        aCoder.encodeObject(image, forKey: UserKey.imageKey)
    }
}

struct UserKey {
    static let objIdKey: String = "objectId"
    static let idKey: String    = "id"
    static let nameKey: String  = "name"
    static let imageKey: String = "image"
}

