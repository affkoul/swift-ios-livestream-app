//
//  UIView.swift
//  Todotrix
//
//  Created by dimi anat on 20/6/1.
//  Copyright © 2020年 com.geniusandcourage. All rights reserved.
//

import UIKit

extension UIView {
    
    var scale: CGFloat {
        set(value) {
            transform = CGAffineTransform(scaleX: value, y: value)
        }
        get {
            return 0
        }
    }
}
