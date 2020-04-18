//
//  MovingObjectView.swift
//  Bounce
//
//  Created by Tim Green on 17/04/2020.
//  Copyright © 2020 Tim Green. All rights reserved.
//

import Foundation
import UIKit

class MovingObjectView : GameObjectView, RemoveFromOwnerDelegate
{
    var xVelocity : CGFloat = 0.0
    var yVelocity : CGFloat = 0.0
    var buffs = [Buff]()
    
    init(params : MovingObjectParams) {
        
        self.xVelocity = params.xVelocity
        self.yVelocity = params.yVelocity
        
        super.init(params : params)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func updateConstraints() {
        super.updateConstraints()
    }
    
    func remove(_ obj: AnyObject) {
        buffs.removeAll(where: { $0 === obj })
    }
    
    override func update()
    {
        if ((x + self.frame.width) > Global.gameBounds.maxX - xVelocity || x < Global.gameBounds.minX)
        {
            xVelocity *= -1
        }
        if ((y + self.frame.width) > Global.gameBounds.maxY - yVelocity || y < Global.gameBounds.minY)
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
}
