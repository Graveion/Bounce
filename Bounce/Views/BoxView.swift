//
//  LogoView.swift
//  LogoBounce
//
//  Created by Tim Green on 27/03/2020.
//  Copyright © 2020 Tim Green. All rights reserved.
//

import Foundation
import UIKit

protocol SpawnNewBoxDelegate: class {
    func spawnNewBox(_ sender: BoxView)
}

protocol GameOverDelegate: class {
    func gameOver()
}

class BoxView : GameObjectView
{
    var colourIndex = 0
    var colours = [UIColor]()
    var bounces = 5
    weak var spawnDelegate: SpawnNewBoxDelegate?
    weak var gameOverDelegate: GameOverDelegate?
    var armour = 0
    
    override init(frame: CGRect, xVelocity : CGFloat, yVelocity : CGFloat, gameBounds: CGRect) {
        super.init(frame : frame, xVelocity : xVelocity, yVelocity : yVelocity, gameBounds: gameBounds)
        
        colours.append(UIColor.red)
        colours.append(UIColor.yellow)
        colours.append(UIColor.green)
        colours.append(UIColor.blue)
        colours.append(UIColor.orange)
        colours.append(UIColor.purple)
        
        
        self.layer.backgroundColor = colours[Int.random(in: 0..<colours.count)].cgColor
        self.layer.borderColor = UIColor.black.cgColor
        self.layer.borderWidth = 1
        
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func updateConstraints() {
        super.updateConstraints()
    }
    
    func damage()
    {
        //take armour first over hp
        if (armour > 0)
        {
            armour -= 1
        }
        else
        {
            hp -= 1
        }
        
        if (hp == 0)
        {
            gameOverDelegate?.gameOver()
        }
    }
    
    func addBuff(buff : Buff)
    {
        buffs.append(buff)
    }
    
    func addArmour(stacks : Int)
    {
        armour += stacks
    }
    
    func animateHP()
    {
        UIView.animate(withDuration: 0.5,
                       delay: 0.0,
                       usingSpringWithDamping: 0.3,
                       initialSpringVelocity: 3,
                       options: UIView.AnimationOptions.curveEaseInOut,
                       animations: ({
                        self.transform = CGAffineTransform(scaleX : 1.1, y: 1.1)
                       }))
        
        let newColour = nextColour().cgColor
        
        let colourAnim = CABasicAnimation(keyPath: "backgroundColor")
        colourAnim.fromValue = self.layer.backgroundColor
        colourAnim.toValue = newColour
        colourAnim.duration = 1.0
        
        self.layer.add(colourAnim, forKey: "backgroundColor")
        self.layer.backgroundColor = newColour
    }
    
    func nextColour() -> UIColor
    {
        colourIndex += 1
        
        if (colourIndex == colours.count - 1)
        {
            colourIndex = 0
        }
        
        return colours[colourIndex]
    }
    
    func previousColour() -> UIColor
    {
        colourIndex -= 1
        
        //shouldn't get this if we are just stepping down tiers
        //as a game over would need to occur
        if (colourIndex < 0)
        {
            colourIndex = 0
        }
        
        return colours[colourIndex]
    }
}
