//
//  config.swift
//  miusicPlay- swift
//
//  Created by user on 16/11/1.
//  Copyright © 2016年 loda. All rights reserved.
//

import Foundation
import UIKit
let KSCREENWIDTH = UIScreen.main.bounds.size.width
let KSCREENHEIGHT = UIScreen.main.bounds.size.height





//@1.宏打印
func HFLog<T>(message: T, fileName: String = #file, methodName: String =  #function, lineNumber: Int = #line)
{
    #if DEBUG
        let str : String = (fileName as NSString).pathComponents.last!
        print("\(str)\(methodName)[\(lineNumber)]:\(message)")
    #else
       
    #endif
    
    
}

//@2.设置验证Hex码
func SwitchColor(hexString:String) ->UIColor{
    
    return colorWithHexColorString(hexColorString: hexString)
}

func colorWithHexColorString(hexColorString:String) ->UIColor {
    if hexColorString.characters.count < 6 {
        return UIColor.black
    }
    
    var tempString = hexColorString.lowercased() as NSString
    if tempString .hasPrefix("0x") {
        tempString = tempString.substring(from: 2) as NSString
    }else if tempString .hasPrefix("#"){
        tempString = tempString .substring(from: 1) as NSString
    }
    
    if tempString.length != 6 {
        return UIColor.black
    }
    
    var range = NSRange()
    range.length = 2
    range.location = 0
    
    let rString = tempString.substring(with: range)
    range.location = 2
    let gString = tempString.substring(with: range)
    range.location = 4
    let bString = tempString.substring(with: range)
    
    var r:CUnsignedInt = 0, g:CUnsignedInt = 0, b:CUnsignedInt = 0;
    
    Scanner(string: rString).scanHexInt32(&r)
    
    Scanner(string: gString).scanHexInt32(&g)
    
    Scanner(string: bString).scanHexInt32(&b)
    
    return UIColor(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: CGFloat(1))
    
}
