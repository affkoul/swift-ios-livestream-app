//
//  UIFont.swift
//  Slowmo
//
//  Created by dimi anat on 20/6/1.
//  Copyright © 2020年 com.geniusandcourage. All rights reserved.
//

import UIKit

extension UIFont {
    
    static func defaultFont(size: CGFloat) -> UIFont {
        return UIFont(name: UIFont.defaultFontName(), size: size)!
    }
    
    static func defaultFontName() -> String {
        return "Raleway-Regular"
    }
    
}
