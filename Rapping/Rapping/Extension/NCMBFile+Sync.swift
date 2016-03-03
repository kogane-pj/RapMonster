//
//  NCMBFile+Sync.swift
//  Rapping
//
//  Created by 千葉 俊輝 on 2016/03/04.
//  Copyright © 2016年 Dorirus. All rights reserved.
//

import NCMB

public extension NCMBFile {
    public func getFileData() -> NSData {
        let request = NCMBURLConnection(path: "files/\(self.name)", method: "GET", data: nil)
        
        do {
            if let responseData = try request.syncConnection() as? NSData {
                return responseData
            }
        }
        catch {
        }
        
        return NSData()
    }
}
