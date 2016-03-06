//
//  Beat.swift
//  Rapping
//
//  Created by 小出健人 on 2016/02/06.
//  Copyright © 2016年 Dorirus. All rights reserved.
//

import UIKit

private let TITLE        = "title"
private let ARTIST       = "artist"

class BeatManager: NSObject {
    
    static let sharedInstance = BeatManager()
    var allBeat:Array<Beat> = []
   
    override init() {
        super.init()
        self.allBeat = self.getAll()
    }
    
    func getAll() -> Array<Beat> {
        return BeatStore.getBeatDate().map {
            Beat(name: $0[TITLE]!, artist:$0[ARTIST]!)
        }
    }
}

class Beat: NSObject {
    
    var name:String
    var artist:String
    var path:NSURL
    var image:UIImage
    
    init(name:String, artist:String) {
        self.name   = name
        self.artist = artist
        self.path   = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource(name, ofType: "mp3")!)
        self.image  = UIImage(named: name) ?? UIImage(named: "recode")!
        
        super.init()
    }
}

struct BeatStore {
    
    // titleとimageNameは合わせる
    static func getBeatDate() -> Array<[String : String]> {
        return [
            [TITLE : "DownBeats",       ARTIST : "タイムレスビーツ"],
            [TITLE : "StreetNuts",      ARTIST : "タイムレスビーツ"],
            [TITLE : "Future",          ARTIST : "タイムレスビーツ"],
            [TITLE : "Evening",         ARTIST : "タイムレスビーツ"],
            [TITLE : "ThreeKeys",       ARTIST : "Kimy from Black Art"],
            [TITLE : "LookAtYourself",  ARTIST : "Kimy from Black Art"],
            [TITLE : "HereWeCome",      ARTIST : "Kimy from Black Art"],
            [TITLE : "Reflection",      ARTIST : "Kimy from Black Art"],
            [TITLE : "StillWaving",     ARTIST : "Kimy from Black Art"],
            [TITLE : "TimeIsMine",      ARTIST : "Kimy from Black Art"]
        ]
    }
   
}