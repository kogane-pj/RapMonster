//
//  ActivityController.swift
//  Rapping
//
//  Created by 千葉 俊輝 on 2016/03/05.
//  Copyright © 2016年 Dorirus. All rights reserved.
//

import UIKit

class ActivityController: NSObject {
    
    private func getActivityVC(vc: UIViewController?, fileURL: String?) -> UIActivityViewController {
        
        // 共有する項目
        var poem = "hogehoge \n"
        if let _url = fileURL {
            poem += _url + "\n"
        }
        let shareText = poem + "#RapMonseter\n"
        // file url? store url?
        let shareWebsite = NSURL(string: "https://yahoo.co.jp")!
        let activityItems = [shareText, shareWebsite]
        
        // 初期化処理
        let activityVC = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
        activityVC.popoverPresentationController?.sourceView = vc?.view
        
        // 使用しないアクティビティタイプ
        let excludedActivityTypes = [
            UIActivityTypeSaveToCameraRoll,
            UIActivityTypePrint
        ]
        
        activityVC.excludedActivityTypes = excludedActivityTypes
        let completionHandler:UIActivityViewControllerCompletionWithItemsHandler = { (str, isFinish, arr, error) in
            if isFinish {
                // DidFinishPost
            }
            else {
            }
        }
        activityVC.completionWithItemsHandler = completionHandler
        return activityVC
    }
    
    func showActivityView(viewController: UIViewController) {
        weak var vc = viewController
        vc?.presentViewController(getActivityVC(vc, fileURL: nil), animated: true, completion: nil)
    }
    
    func showActivityView(viewController: UIViewController, fileURL: String) {
        weak var vc = viewController
        vc?.presentViewController(getActivityVC(vc, fileURL: fileURL), animated: true, completion: nil)
    }
}

