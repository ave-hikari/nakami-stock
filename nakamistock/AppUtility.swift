//
//  AppUtility.swift
//  nakamistock
//
//  Created by Hikari Yanagihara on 2016/02/22.
//  Copyright © 2016年 Hikari Yanagihara. All rights reserved.
//

import Foundation
import UIKit

class AppUtility {
    
    //16進数のカラーコードをUIColorで指定し返却する
    //https://gist.github.com/arshad/de147c42d7b3063ef7bc
    static func colorWithHexString (_ hex:String) -> UIColor {
        
        let cString = hex.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).uppercased()
        
        if ((cString as String).characters.count != 6) {
            return UIColor.gray
        }
        
        let rString = (cString as NSString).substring(with: NSRange(location: 0, length: 2))
        let gString = (cString as NSString).substring(with: NSRange(location: 2, length: 2))
        let bString = (cString as NSString).substring(with: NSRange(location: 4, length: 2))
        
        var r:CUnsignedInt = 0, g:CUnsignedInt = 0, b:CUnsignedInt = 0;
        Scanner(string: rString).scanHexInt32(&r)
        Scanner(string: gString).scanHexInt32(&g)
        Scanner(string: bString).scanHexInt32(&b)
        
        return UIColor(
            red: CGFloat(Float(r) / 255.0),
            green: CGFloat(Float(g) / 255.0),
            blue: CGFloat(Float(b) / 255.0),
            alpha: CGFloat(Float(1.0))
        )
    }
}
