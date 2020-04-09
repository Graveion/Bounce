//
//  GateView.swift
//  LogoBounce
//
//  Created by Tim Green on 29/03/2020.
//  Copyright © 2020 Tim Green. All rights reserved.
//

import Foundation
import UIKit

class GateView : GameObjectView
{
    var collisionFrame = CGRect()
    
    override init(frame: CGRect, xVelocity : CGFloat, yVelocity : CGFloat, gameBounds: CGRect) {
        super.init(frame : frame, xVelocity : xVelocity, yVelocity : yVelocity, gameBounds: gameBounds)
    
        //can do this with an imageview or something to make it nicer i guess
        //just doing it easy way for now
        let leftBox : CGRect = CGRect(x: 0.0,y: frame.height/2 - 4,width: 8,height: 8)
        let leftBoxView = UIView(frame: leftBox)
        leftBoxView.backgroundColor = UIColor.blue
        
        let rightBox : CGRect = CGRect(x: frame.width - 8,y: frame.height/2 - 4,width: 8,height: 8)
        let rightBoxView = UIView(frame: rightBox)
        rightBoxView.backgroundColor = UIColor.blue
        
        collisionFrame = CGRect(x: frame.origin.x,y: frame.origin.y + frame.height/2 - 4,width: frame.width - 8,height: 8)
        
        addSubview(leftBoxView)
        addSubview(rightBoxView)
                
        let lightningFrame : CGRect = CGRect(x: 8.0,y: 0.0,width: frame.width - 8,height: frame.height)
        addSubview(LightningView(frame: lightningFrame))
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func updateConstraints() {
        super.updateConstraints()
    }
    
    override func draw(_ rect: CGRect) {
        
    }
    
    func collisionBox() -> UIBezierPath
    {
        let path = UIBezierPath(rect :collisionFrame)
        path.apply(transform)
        return path
    }
    
    func animate()
    {
        
    }
}

extension UIView {
    private static let rotationAnimationKey = "rotationanimationKey"

    func rotateInfinite(duration: Double = 1) {
        if layer.animation(forKey: UIView.rotationAnimationKey) == nil {
            let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation")

            rotationAnimation.fromValue = 0.0
            rotationAnimation.toValue = Float.pi * 2.0
            rotationAnimation.duration = duration
            rotationAnimation.repeatCount = Float.infinity
            
            layer.add(rotationAnimation, forKey: UIView.rotationAnimationKey)
        }
    }

    func stopRotating() {
        if layer.animation(forKey: UIView.rotationAnimationKey) != nil {
            layer.removeAnimation(forKey: UIView.rotationAnimationKey)
        }
    }
    
    /**
     Rotate a view by specified degrees

     - parameter angle: angle in degrees
     */
    func rotateTo(angle: CGFloat) {
        let radians = angle / 180.0 * CGFloat.pi
        let rotation = self.transform.rotated(by: radians)
        self.transform = rotation
    }
}



