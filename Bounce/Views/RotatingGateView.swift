//
//  RotatingGateView.swift
//  Bounce
//
//  Created by Tim Green on 05/04/2020.
//  Copyright © 2020 Tim Green. All rights reserved.
//

import Foundation
import UIKit

class RotatingGateView : GateView
{
    init(frame: CGRect, xVelocity : CGFloat, yVelocity : CGFloat, gameBounds: CGRect, loopDuration : Double) {
        super.init(frame : frame, xVelocity : xVelocity, yVelocity : yVelocity, gameBounds: gameBounds)
        self.rotateInfinite(duration: loopDuration)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
