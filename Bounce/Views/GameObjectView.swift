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
    var owner : RemoveFromOwnerDelegate?

    init(params : ObjectParams) {
        var frame = randomSafeLocationInBounds(params.width,params.height)
        
        x = frame.origin.x
        y = frame.origin.y
        
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

func randomSafeLocationInBounds(_ width : CGFloat,_ height : CGFloat) -> CGRect
{
    //to take into account rotation
    let w = width + (height/2)
    let h = height + (width/2)
    
    return CGRect(
        x: CGFloat.random(in: Global.gameBounds.minX + w...Global.gameBounds.maxX - w),
        y: CGFloat.random(in: Global.gameBounds.minY + h...Global.gameBounds.maxY - h),
        width: width,
        height: height)
}
