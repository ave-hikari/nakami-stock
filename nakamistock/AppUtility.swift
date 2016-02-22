//
//  AppUtility.swift
//  nakamistock
//
//  Created by Hikari Yanagihara on 2016/02/22.
//  Copyright © 2016年 Hikari Yanagihara. All rights reserved.
//

import Foundation
import UIKit

//汎用的なクラスメソッドはここに書く
class AppUtility {
    
    //16進数のカラーコードをUIColorで指定し返却する
    //https://gist.github.com/arshad/de147c42d7b3063ef7bc
    static func colorWithHexString (hex:String) -> UIColor {
        
        let cString:String = hex.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()).uppercaseString
        
        if ((cString as String).characters.count != 6) {
            return UIColor.grayColor()
        }
        
        let rString = (cString as NSString).substringWithRange(NSRange(location: 0, length: 2))
        let gString = (cString as NSString).substringWithRange(NSRange(location: 2, length: 2))
        let bString = (cString as NSString).substringWithRange(NSRange(location: 4, length: 2))
        
        var r:CUnsignedInt = 0, g:CUnsignedInt = 0, b:CUnsignedInt = 0;
        NSScanner(string: rString).scanHexInt(&r)
        NSScanner(string: gString).scanHexInt(&g)
        NSScanner(string: bString).scanHexInt(&b)
        
        return UIColor(
            red: CGFloat(Float(r) / 255.0),
            green: CGFloat(Float(g) / 255.0),
            blue: CGFloat(Float(b) / 255.0),
            alpha: CGFloat(Float(1.0))
        )
    }
}