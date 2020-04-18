//
//  ScoreboardView.swift
//  Bounce
//
//  Created by Tim Green on 04/04/2020.
//  Copyright © 2020 Tim Green. All rights reserved.
//

import Foundation
import UIKit

class MineView : MovingObjectView, Collidable
{
    
    func collisionBox() -> CGRect
    {
        return frame
    }
    
    func collision(with: GameObjectView) {
        if (with is BoxView)
        {
            owner?.remove(self)
            //then animate an explosion
        }
    }
    
    override init(params : MovingObjectParams) {
        super.init(params : params)
        self.backgroundColor = UIColor.black
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
