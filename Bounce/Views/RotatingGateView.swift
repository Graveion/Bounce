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
    var timerTracker : Double = 0
    
    init(params : RotatingGateParams) {
        super.init(params: params)
        //self.rotateInfinite(duration: params.loopDuration)
        
        //testing with a timer anim
        let timer = Timer.scheduledTimer(withTimeInterval: 0.02, repeats: true) { _ in
            self.rotateTo(angle: CGFloat(1.0))
            self.frameView.rotateTo(angle: CGFloat(1.0))
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
