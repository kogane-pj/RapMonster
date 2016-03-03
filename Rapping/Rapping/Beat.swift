//
//  Beat.swift
//  Rapping
//
//  Created by 小出健人 on 2016/02/06.
//  Copyright © 2016年 Dorirus. All rights reserved.
//

import UIKit

class BeatManager: NSObject {
    
    static let sharedInstance = BeatManager()
    var allBeat:Array<Beat> = []
   
    override init() {
        super.init()
        self.allBeat = self.getAll()
    }
    
    func getAll() -> Array<Beat> {
        return BeatStore.getBeatDate().map {
            Beat(name: $0["title"]!, artist:$0["artist"]!, imageName: $0["imageName"]!)
        }
    }
}

class Beat: NSObject {
    
    var name:String
    var artist:String
    var path:NSURL
    var image:UIImage
    
    init(name:String, artist:String, imageName:String) {
        self.name   = name
        self.artist = artist
        self.path   = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource(name, ofType: "mp3")!)
        self.image  = UIImage(named: imageName) ?? UIImage(named: "recode")!
        
        super.init()
    }
    
    private static func getPathWithName(name:String) -> NSURL {
        return NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource(name, ofType: "mp3")!)
    }
}

struct BeatStore {
    
    static let TITLE        = "title"
    static let ARTIST       = "artist"
    static let IMAGE_NAME   = "imageName"
    
    static func getBeatDate() -> Array<[String : String]> {
        return [
            [TITLE : "DownBeats",       ARTIST : "タイムレスビーツ",       IMAGE_NAME : "recode"],
            [TITLE : "StreetNuts",      ARTIST : "タイムレスビーツ",       IMAGE_NAME : "recode"],
            [TITLE : "Future",          ARTIST : "タイムレスビーツ",       IMAGE_NAME : "recode"],
            [TITLE : "Evening",         ARTIST : "タイムレスビーツ",       IMAGE_NAME : "recode"],
            [TITLE : "ThreeKeys",       ARTIST : "Kimy from Black Art", IMAGE_NAME : "recode"],
            [TITLE : "LookAtYourself",  ARTIST : "Kimy from Black Art", IMAGE_NAME : "recode"],
            [TITLE : "HereWeCome",      ARTIST : "Kimy from Black Art", IMAGE_NAME : "recode"],
            [TITLE : "Reflection",      ARTIST : "Kimy from Black Art", IMAGE_NAME : "recode"],
            [TITLE : "StillWaving",     ARTIST : "Kimy from Black Art", IMAGE_NAME : "recode"],
        ]
    }
   
}