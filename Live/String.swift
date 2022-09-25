//
//  String.swift
//  Todotrix
//
//  Created by dimi anat on 20/6/1.
//  Copyright © 2020年 com.geniusandcourage. All rights reserved.
//

import UIKit
//import TextAttributes

public extension NSAttributedString {
    
    func heightWithConstrainedWidth(_ width: CGFloat) -> CGFloat {
        let boundingSize = CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)
        let options = NSStringDrawingOptions.usesLineFragmentOrigin
        let size = boundingRect(with: boundingSize, options: options, context: nil)
        return ceil(size.height)
    }
}

public extension String {
    
//    func attributedComment() -> NSAttributedString {
//        let attrs = TextAttributes()
//            .font(UIFont.defaultFont(size: 13))
//            .foregroundColor(UIColor.white)
//            .alignment(.left)
//            .lineSpacing(1)
//            .dictionary
//        return NSAttributedString(string: self, attributes: attrs)
//    }
    func attributedComment() -> NSAttributedString {
        let font = UIFont.systemFont(ofSize: 13)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .left
        paragraphStyle.firstLineHeadIndent = 1.0
        paragraphStyle.paragraphSpacing = 0.25 * font.lineHeight;
        let shadow = NSShadow()
        shadow.shadowColor = UIColor.red
        shadow.shadowBlurRadius = 5
        
        let attrs: [NSAttributedString.Key: Any] = [
            .font: font,
            .foregroundColor: UIColor.white,
            .paragraphStyle: paragraphStyle,
            .shadow: shadow
        ]
        return NSAttributedString(string: self, attributes: attrs)
    }
    
    static func random(_ length: Int = 4) -> String {
        let base = "abcdefghijklmnopqrstuvwxyz"
        var randomString: String = ""
        for _ in 0..<length {
            let randomValue = arc4random_uniform(UInt32(base.count))
            randomString += "\(base[base.index(base.startIndex, offsetBy: Int(randomValue))])"
        }
        return randomString
    }
    
}
