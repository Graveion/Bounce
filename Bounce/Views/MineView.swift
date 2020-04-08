//
//  ScoreboardView.swift
//  Bounce
//
//  Created by Tim Green on 04/04/2020.
//  Copyright © 2020 Tim Green. All rights reserved.
//

import Foundation
import UIKit

class MineView : GameObjectView
{
    override init(frame: CGRect, xVelocity : CGFloat, yVelocity : CGFloat, gameBounds: CGRect) {
        super.init(frame : frame, xVelocity : xVelocity, yVelocity : yVelocity, gameBounds: gameBounds)
        self.backgroundColor = UIColor.black
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
