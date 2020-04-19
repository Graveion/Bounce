//
//  GravityWellView.swift
//  Bounce
//
//  Created by Tim Green on 18/04/2020.
//  Copyright © 2020 Tim Green. All rights reserved.
//

import Foundation
import UIKit

protocol Gravity: class {
    var body : Body {get set}
    var mass : Double {get set}
    func addImpulse()
}

class GravityWellView : MovingObjectView, Collidable, Gravity
{
    var mass : Double = 0
    var body = Body (0.0, Vector2d(0,0))
    
    func collisionBox() -> CGRect
    {
        //only needs a small collision box
        //we don't want things orbiting closely to be destroyed
        return frame.insetBy(dx: frame.width/2 - 2, dy: frame.height/2 - 2)
    }
    
    func collision(with: GameObjectView) {
        if (with is MineView)
        {
            let gravity = with as! Gravity
            //the mine will be removed and we grow in size
            mass += gravity.mass
        }
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
        
        self.mass = params.mass
        self.backgroundColor = UIColor.purple
        self.body = Body(mass, Vector2d(Double(frame.origin.x), Double(frame.origin.y)))
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
