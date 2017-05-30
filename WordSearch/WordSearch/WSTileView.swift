//
//  WSTileView.swift
//  WordSearch
//
//  Created by BenRussell on 5/25/17.
//  Copyright © 2017 BenRussell. All rights reserved.
//

import UIKit

class WSTileView: UILabel {
    
    var sortNumber:Int?
    
    
    init(_ frame: CGRect, withString string:String) {
        super.init(frame: frame)
        
        self.text = string
        self.textAlignment = .center
        self.adjustsFontSizeToFitWidth = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
