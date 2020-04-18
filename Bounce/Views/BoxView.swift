//
//  LogoView.swift
//  LogoBounce
//
//  Created by Tim Green on 27/03/2020.
//  Copyright © 2020 Tim Green. All rights reserved.
//

import Foundation
import UIKit

protocol GameDelegate: class {
    func spawnNewBox()
    func gameOver()
    func score(_ score: Int)
}

class BoxView : MovingObjectView, Collidable
{
    var colourIndex = 0
    var colours = [UIColor]()
    var bounces = 5
    weak var game: GameDelegate?
    var armour = 0
    var hp = 1
    
    override init(params: MovingObjectParams) {
        super.init(params: params)
        
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
            game?.gameOver()
        }
    }
    
    func collisionBox() -> CGRect
    {
        return frame
    }
    
    func collision(with: GameObjectView) {
        if (with is GateView)
        {
            addBuff(buff: Buff(value: 0.4, duration: .long, type: .speed, owner: self))
            game?.score(100)
        }
        else if(with is MineView)
        {
            damage()
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
