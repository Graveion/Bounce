//
//  Buff.swift
//  Bounce
//
//  Created by Tim Green on 07/04/2020.
//  Copyright © 2020 Tim Green. All rights reserved.
//

import Foundation
import UIKit

//a buff will take some value and a duration and then linearly scale down to
//nothing over that duration then call delegate for removal

protocol RemoveFromOwnerDelegate: class {
    func removeBuff(buff : Buff)
}

class Buff
{
    var type : BuffType
    var value : Double
    var duration : BuffDuration
    var timerTracker : Double = 0
    var interval = 0.1
    var timer = Timer()
    var reduction : Double
    weak var owner: RemoveFromOwnerDelegate?
    
    //all buffs are Double and cast where they need to be applied
    //current usage is only modifying speed (x/y velocity) which are CGFloats
    //the way this is done regardless of whether its a + or - value change
    //both will scale to 0
    
    init(value : Double, duration : BuffDuration, type : BuffType, owner : RemoveFromOwnerDelegate)
    {
        self.value = value
        self.type = type
        self.duration = duration
        self.owner = owner
    
        self.reduction = value / (duration.rawValue / interval)
        
        timer = Timer.scheduledTimer(withTimeInterval: interval, repeats: true) { _ in
            self.scaleBuff()
        }
    }
    
    func scaleBuff()
    {
        
        value -= reduction
        
        self.timerTracker += 0.1
        
        if (self.timerTracker >= duration.rawValue)
        {
            timer.invalidate()
            owner?.removeBuff(buff: self)
        }
    }
}

enum BuffDuration : Double
{
    case short = 1.0
    case medium = 2.0
    case long = 3.0
}

enum BuffType : String
{
    case speed = "speed"
}
