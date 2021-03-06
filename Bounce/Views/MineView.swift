//
//  ScoreboardView.swift
//  Bounce
//
//  Created by Tim Green on 04/04/2020.
//  Copyright © 2020 Tim Green. All rights reserved.
//

import Foundation
import UIKit

class MineView : MovingObjectView, Collidable, Gravity
{
    
    var mass : Double = 0
    var body = Body (0.0, Vector2d(0,0))
    
    func collisionBox() -> CGRect
    {
        return frame
    }
    
    func collision(with: GameObjectView) {
        if (with is BoxView)
        {
            //could animate an explosion on this view
            //then remove on animation complete callback
            owner?.remove(self)
        }
        
        if (with is GravityWellView)
        {
            //the well absorbs it
            shrinkAnim()
        }
    }
    
    func shrinkAnim()
    {
        //removes but doesn't animate
        //completion just activates instantly
        UIView.animate(withDuration: 6.0,
                       delay: 0.0,
                       options: .curveEaseInOut,
                       animations: {
            self.transform = CGAffineTransform(scaleX: 0.0, y: 0.0)},
            completion: { _ in
                self.owner?.remove(self)
        })
    }
    
    func addImpulse() {
        xVelocity += CGFloat(body.acceleration.x)
        yVelocity += CGFloat(body.acceleration.y)
    }
    
    override func update() {
        super.update()
        
        //need to update body each frame and reset acceleration
        body.mass = mass
        body.acceleration = Vector2d(0.0,0.0)
        body.location = Vector2d(Double(frame.origin.x), Double(frame.origin.y))
    }
    
    init(params : GravityObjectParams) {
        super.init(params : params)
       
        self.backgroundColor = UIColor.black
        self.mass = params.mass
        self.body = Body(mass, Vector2d(Double(frame.origin.x), Double(frame.origin.y)))
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
