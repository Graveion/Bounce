//
//  LightningView.swift
//  LogoBounce
//
//  Created by Tim Green on 29/03/2020.
//  Copyright © 2020 Tim Green. All rights reserved.
//

import Foundation
import UIKit

typealias Path = (path: UIBezierPath, colour : UIColor)

class LightningView : UIView
{
    var x : CGFloat = 0.0
    var y : CGFloat = 0.0
    var start = CGPoint()
    var end = CGPoint()
    var paths = [Path]()
    var lines = 6
    var halfFrameHeight : CGFloat = 0.0

    override init(frame: CGRect) {
        super.init(frame : frame)
        
        self.backgroundColor = UIColor.clear
        
        //generate something like 4-8 lines on load with mid point displacement
        //"animate" by rapidly scaling alpha up down up then out per line (if possible - hard need shape layers and clipping path)
        //on completion remove line and generate another
        halfFrameHeight = frame.height/2
        
        start = CGPoint(x: 0,y: halfFrameHeight)
        end = CGPoint(x: frame.width, y: halfFrameHeight)
        
        for _ in 0..<lines
        {
            addLine()
        }
        
        _ = Timer.scheduledTimer(withTimeInterval: 0.06, repeats: true) { _ in
            self.animate()
        }
        
        self.rotate()
    }
    
    func addLine()
    {
        var points : [CGPoint] = [CGPoint]()
        
        let displaceStart = CGPoint(x: start.x, y: start.y + CGFloat.random(in: -3...3))
        let displaceEnd = CGPoint(x: end.x, y: end.y + CGFloat.random(in: -5...5))
        
        points.append(displaceStart)
        points.append(displaceEnd)
        pathPoints(start: displaceStart, end : displaceEnd, points: &points, displacement: halfFrameHeight)
        paths.append(Path(displacedPath(points : points), genColour()))
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        
    }
    
    override func updateConstraints() {
        super.updateConstraints()
    }
    
    override func draw(_ rect: CGRect) {
        paths.forEach { line in
            line.colour.setStroke()
            line.path.stroke()
        }
    }
    
    func displacedPath(points : [CGPoint]) -> UIBezierPath
    {
        let path = UIBezierPath()
        path.lineWidth = CGFloat.random(in: 0.5..<2.8)
        path.move(to: points[0])
        points.forEach{point in path.addLine(to: point)}
        
        return path
    }
    
    func genColour() -> UIColor
    {
        //generate something with a blue/white hue
        //start alpha at 0
        UIColor.init(red: 0.5, green: 0.5, blue: CGFloat.random(in: 0.6...1.0), alpha: CGFloat.random(in: 0.14...1.0))
    }
    
    func pathPoints(start: CGPoint, end: CGPoint, points : inout [CGPoint], displacement : CGFloat)
    {
        if (displacement > 1.7)
        {
            //make point
            var midpoint = getMidPoint(a: start,b: end)
            
            midpoint.x += (CGFloat.random(in: 0...1)-0.5)*displacement
            midpoint.y += (CGFloat.random(in: 0...1)-0.5)*displacement
            
            //insert
            points.insert(midpoint, at: points.firstIndex(of: start)! + 1)
            
            //recursive
            pathPoints(start: start, end: midpoint, points: &points, displacement: displacement * 0.53)
            pathPoints(start: midpoint, end: end, points : &points, displacement: displacement * 0.53)
        }
    }
    
    func getMidPoint(a: CGPoint, b: CGPoint) -> CGPoint
    {
        return CGPoint(x: (a.x + b.x)/2,y: (a.y + b.y)/2)
    }
    
    func animate()
    {
        
        
        
        
        //need to use CAShapeLayer CABasicAnimation and clippin paths/masks
        //to able to animate the colour of an individual line
        paths.removeFirst()
        addLine()
        self.setNeedsDisplay()
    }
}

extension UIView {
    private static let rotationAnimationKey = "rotationanimationKey"

    func rotate(duration: Double = 1) {
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
}




