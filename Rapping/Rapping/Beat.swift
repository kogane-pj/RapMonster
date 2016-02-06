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
        return ["RB_85BPM",
                "FS_89BPM",
                "HIPHOP_106BPM",
                "HIPHOP_140BPM",
                "FS_Three_Keys",
                "FS_Look_At_Yourself",
                "FS_Here_We_Come",
                "FS_Reflection",
                "FS_Still_Waving"]
    }
}

class Beat: NSObject {
    var name:String = ""
    var path:NSURL! = nil
}