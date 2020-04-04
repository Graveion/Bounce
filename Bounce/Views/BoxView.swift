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

class BoxView : UIView
{
    var colourIndex = 0
    var colours = [UIColor]()
    var x : CGFloat = 0.0
    var y : CGFloat = 0.0
    var xVelocity : CGFloat = 5.0
    var yVelocity : CGFloat = 5.0
    var bounces = 5
    weak var spawnDelegate: SpawnNewBoxDelegate?
    var gameBounds = CGRect()
    
    override init(frame: CGRect) {
        super.init(frame : frame)

        colours.append(UIColor.red)
        colours.append(UIColor.yellow)
        colours.append(UIColor.green)
        colours.append(UIColor.blue)
        colours.append(UIColor.orange)
        colours.append(UIColor.purple)
        
        x = frame.origin.x
        y = frame.origin.y
        
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
    
    func update()
    {
        addVelocity()
        
        if (x > gameBounds.maxX || x < gameBounds.minX)
        {
            //spawnDelegate?.spawnNewBox(self)
            xVelocity *= -1
            animate()
        }
        if (y > gameBounds.maxY || y < gameBounds.minY)
        {
            //spawnDelegate?.spawnNewBox(self)
            yVelocity *= -1
            animate()
            
        }
    }
    
    func addVelocity()
    {
        x += xVelocity
        y += yVelocity
        
        self.frame.origin.x += xVelocity
        self.frame.origin.y += yVelocity
    }
    
    func animate()
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
        
        UIView.animate(withDuration: 0.5,
                    delay: 0.0,
                    usingSpringWithDamping: 0.3,
                    initialSpringVelocity: 3,
                    options: UIView.AnimationOptions.curveEaseInOut,
                    animations: ({
                        self.transform = CGAffineTransform(scaleX : 1.1, y: 1.1)
                }), completion: { _ in
                    UIView.animate(withDuration: 0.5,
                                   animations: ({self.transform = .identity}),
                                   completion: nil)
                })
        
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
}
