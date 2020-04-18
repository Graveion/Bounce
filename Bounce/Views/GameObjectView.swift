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

//this only works assuming the path has been made from a rect
//given the general insanity of this might want to use
//the ui kit dynamics...
func collision(a : UIBezierPath, b: UIBezierPath) -> Bool
{
    let aPoints = a.cgPath.getPathElementsPoints()
    let bPoints = b.cgPath.getPathElementsPoints()
    
    return (aPoints[0].x < bPoints[1].x && aPoints[1].x > bPoints[0].x &&
    aPoints[1].y > bPoints[2].y && aPoints[2].y < bPoints[1].y )
    
    //this makes the assumption that a path from a CGRect goes
    //topleft topright bottomright bottomleft
    //return overlappingPoints(a1: aPoints[0], a2: aPoints[2], b1: bPoints[0], b2: bPoints[2])
}

//takes topleft/bottom right of 2 rects
//comapres to see if they must overlap
func overlappingPoints(a1 : CGPoint, a2: CGPoint, b1: CGPoint, b2 : CGPoint) -> Bool
{
    // If one rectangle is on left side of other
    if (a1.x > b2.x || a2.x > b1.x) {
        return false
    }
    
    // If one rectangle is above other
    if (a1.y < b2.y || a2.y < b1.y) {
        return false
    }

    return true
}

extension CGPath {
    func forEachPoint( body: @escaping @convention(block) (CGPathElement) -> Void) {
        typealias Body = @convention(block) (CGPathElement) -> Void
        let callback: @convention(c) (UnsafeMutableRawPointer, UnsafePointer<CGPathElement>) -> Void = { (info, element) in
            let body = unsafeBitCast(info, to: Body.self)
            body(element.pointee)
        }
        let unsafeBody = unsafeBitCast(body, to: UnsafeMutableRawPointer.self)
        self.apply(info: unsafeBody, function: unsafeBitCast(callback, to: CGPathApplierFunction.self))
    }
    func getPathElementsPoints() -> [CGPoint] {
        var arrayPoints : [CGPoint]! = [CGPoint]()
        self.forEachPoint { element in
            switch (element.type) {
            case CGPathElementType.moveToPoint:
                arrayPoints.append(element.points[0])
            case .addLineToPoint:
                arrayPoints.append(element.points[0])
            default: break
            }
        }
        return arrayPoints
    }
    func getPathElementsPointsAndTypes() -> ([CGPoint],[CGPathElementType]) {
        var arrayPoints : [CGPoint]! = [CGPoint]()
        var arrayTypes : [CGPathElementType]! = [CGPathElementType]()
        self.forEachPoint { element in
            switch (element.type) {
            case CGPathElementType.moveToPoint:
                arrayPoints.append(element.points[0])
                arrayTypes.append(element.type)
            case .addLineToPoint:
                arrayPoints.append(element.points[0])
                arrayTypes.append(element.type)
            default: break
            }
        }
        return (arrayPoints,arrayTypes)
    }
}
