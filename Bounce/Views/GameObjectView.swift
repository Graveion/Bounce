//
//  LogoView.swift
//  LogoBounce
//
//  Created by Tim Green on 27/03/2020.
//  Copyright © 2020 Tim Green. All rights reserved.
//

import Foundation
import UIKit

class GameObjectView : UIView
{
    var x : CGFloat = 0.0
    var y : CGFloat = 0.0
    var xVelocity : CGFloat = 0.0
    var yVelocity : CGFloat = 0.0
    var gameBounds = CGRect()
    var hp = 1
    
    
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
        x += xVelocity
        y += yVelocity
        
        self.frame.origin.x += xVelocity
        self.frame.origin.y += yVelocity
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
