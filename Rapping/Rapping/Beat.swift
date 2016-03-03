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
        
        var allPath:[Beat] = []
        
        for name in self.getBeatName() {
            let beat = Beat()
            beat.name = name;
            beat.path = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource(name, ofType: "mp3")!)

            allPath.append(beat)
            
        }
        
        return allPath
    }
   
    // これ他のとこの方がいい説
    func getBeatName() -> Array<String> {
        return ["DownBeats",
                "StreetNuts",
                "Future",
                "Evening",
                "ThreeKeys",
                "LookAtYourself",
                "HereWeCome",
                "Reflection",
                "StillWaving"]
    }
}

class Beat: NSObject {
    var name:String = ""
    var path:NSURL! = nil
}