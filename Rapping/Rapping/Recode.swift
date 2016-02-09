//
//  Recode.swift
//  Rapping
//
//  Created by 小出健人 on 2016/02/07.
//  Copyright © 2016年 Dorirus. All rights reserved.
//

import UIKit

class RecodeManager: NSObject {
    
    static let sharedInstance = RecodeManager()
    var allRecode:Array<Recode> = []
    
    override init() {
        super.init()
        self.allRecode = self.getAll()
    }
    
    func getAll() -> Array<Recode> {
        
        var recodeList:[Recode] = []
        var recodes = [NSURL]()
        
        //TODO:いつかFileクラスにまとめる
        let documentsDirectory = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)[0]
        do {
            let urls = try NSFileManager.defaultManager().contentsOfDirectoryAtURL(documentsDirectory, includingPropertiesForKeys: nil, options: NSDirectoryEnumerationOptions.SkipsHiddenFiles)
            recodes = urls.filter( { (name: NSURL) -> Bool in
                return name.lastPathComponent!.hasSuffix("caf")
            })
        } catch let error as NSError {
            print(error.localizedDescription)
        } catch {
            print("something went wrong listing recordings")
        }
        
        for path in recodes {
            let recode = Recode()
            recode.path = path
            recode.name = path.lastPathComponent!
            
            print(recode.name)
            
            recodeList.append(recode)
        }
        
        return recodeList
    }
}

class Recode: NSObject {
    var name:String = ""
    var path:NSURL! = nil
}
