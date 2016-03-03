//
//  UIImage+Color.swift
//  Rapping
//
//  Created by 千葉 俊輝 on 2016/03/04.
//  Copyright © 2016年 Dorirus. All rights reserved.
//

import UIKit

extension UIImage {
    class func colorImage(color: UIColor, size: CGSize) -> UIImage {
        UIGraphicsBeginImageContext(size)
        
        let rect = CGRect(origin: CGPointZero, size: size)
        let context = UIGraphicsGetCurrentContext()
        CGContextSetFillColorWithColor(context, color.CGColor)
        CGContextFillRect(context, rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return image
    }
}

