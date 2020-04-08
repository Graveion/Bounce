//
//  LogoView.swift
//  LogoBounce
//
//  Created by Tim Green on 27/03/2020.
//  Copyright © 2020 Tim Green. All rights reserved.
//

import Foundation
import UIKit

//need to split this up between objkects that move and those that don't really!
//as some objects will be calcing a speed mod for no reason

class GameObjectView : UIView, RemoveFromOwnerDelegate
{
    var x : CGFloat = 0.0
    var y : CGFloat = 0.0
    var xVelocity : CGFloat = 0.0
    var yVelocity : CGFloat = 0.0
    var gameBounds = CGRect()
    var hp = 1
    var buffs = [Buff]()
    
    init(frame: CGRect, xVelocity : CGFloat, yVelocity : CGFloat, gameBounds : CGRect) {
        x = frame.origin.x
        y = frame.origin.y
        
        self.gameBounds = gameBounds
        self.xVelocity = xVelocity
        self.yVelocity = yVelocity
        
        super.init(frame : frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func updateConstraints() {
        super.updateConstraints()
    }
    
    func removeBuff(buff: Buff) {
        buffs.removeAll(where: { $0 === buff })
    }
    
    func update()
    {
        if ((x + self.frame.width) > gameBounds.maxX - xVelocity || x < gameBounds.minX)
        {
            xVelocity *= -1
        }
        if ((y + self.frame.width) > gameBounds.maxY - yVelocity || y < gameBounds.minY)
        {
            yVelocity *= -1
        }
        
        addVelocity()
    }
    
    func addVelocity()
    {
        
        //grab all speed buffs
        //we'll have them be multiplicative rather than additive
        var speedBonus = buffs.filter({ $0.type == BuffType.speed})
                              .reduce(1.0, { x, y in
                                    x * (1.0+y.value)
                              })
        
        x += xVelocity * CGFloat(speedBonus)
        y += yVelocity * CGFloat(speedBonus)
        
        self.frame.origin.x += xVelocity * CGFloat(speedBonus)
        self.frame.origin.y += yVelocity * CGFloat(speedBonus)
    }
    
    func remove()
    {
        //todo:
        //would like to handle this here but for some reason
        //remove from supervioew here leaves the box on the edge as a red box
        //        if (bounces == 0)
        //        {
        //            DispatchQueue.main.async() {
        //                       self.removeFromSuperview()
        //                   }
        //
        //            self.setNeedsDisplay()
        //
        //            return
        //        }
    }
}
