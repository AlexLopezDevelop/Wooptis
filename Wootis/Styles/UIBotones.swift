//
//  UIBotones.swift
//  Wootis
//
//  Created by qwerty on 29/5/18.
//  Copyright © 2018 Wootis.inc. All rights reserved.
//

import UIKit

@IBDesignable
class UIBotones: UIButton {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

    
    @IBInspectable
    public var cornerRadius: CGFloat = 2.0 {
        didSet {
            self.layer.cornerRadius = self.cornerRadius
        }
    }
    
    
    override var backgroundColor: UIColor? {
        didSet {
           //self.layer.backgroundColor = UIColor.blue.cgColor
        }
    }
    
}
