//
//  Recode.swift
//  Rapping
//
//  Created by 小出健人 on 2016/02/07.
//  Copyright © 2016年 Dorirus. All rights reserved.
//

import UIKit

class RapManager: NSObject {
    
    static let sharedInstance = RapManager()
    var allRap:Array<Rap> = []
    
    override init() {
        super.init()
        self.allRap = self.getAll()
    }
    
    func getAll() -> Array<Rap> {
        
        var recodeList:[Rap] = []
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
            let recode = Rap()
            recode.path = path
            recode.name = path.lastPathComponent!
            
            print(recode.name)
            print(recode.path)
            recodeList.append(recode)
           

            var fileManager = NSFileManager.defaultManager()
            var documentsPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true).first
            //var filePath = documentsPath!.
            let path = NSURL(fileURLWithPath: documentsPath!).URLByAppendingPathComponent(recode.name).path
            
            var fileExists = fileManager.fileExistsAtPath(path!)
            print(fileExists)
            //ファイルサイズ
            do {
                let attr: NSDictionary = try NSFileManager.defaultManager().attributesOfItemAtPath(path!)
                print(attr.fileSize())
            } catch let error as NSError {
                print(error)
            }
        }
        
        return recodeList
    }
}

class Rap: NSObject {
    var name:String = ""
    var path:NSURL! = nil
    var date:NSDate! = nil
    var beat:String = ""
}
