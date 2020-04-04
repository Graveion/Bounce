//
//  ScoreboardView.swift
//  Bounce
//
//  Created by Tim Green on 04/04/2020.
//  Copyright © 2020 Tim Green. All rights reserved.
//

import Foundation
import UIKit

class ScoreboardView : UIView
{
    var score = 0
    
    override init(frame: CGRect) {
    super.init(frame : frame)
        self.backgroundColor = UIColor.black

    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func addScore(value: Int)
    {
        score += value
    }
}
