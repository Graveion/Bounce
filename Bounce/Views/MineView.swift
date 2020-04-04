//
//  ScoreboardView.swift
//  Bounce
//
//  Created by Tim Green on 04/04/2020.
//  Copyright © 2020 Tim Green. All rights reserved.
//

import Foundation
import UIKit

class MineView : UIView
{
    var mobileMine = false
    var gameBounds = CGRect()
    var xVelocity : CGFloat = 5.0
    var yVelocity : CGFloat = 5.0
    var x : CGFloat = 0.0
    var y : CGFloat = 0.0
    
    //BIG TO DO
    //inheritance for duplicate vals
    //factory to grab them
    
    override init(frame: CGRect) {
    super.init(frame : frame)
        self.backgroundColor = UIColor.black
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
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
}
