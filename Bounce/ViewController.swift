//
//  ViewController.swift
//  LogoBounce
//
//  Created by Tim Green on 27/03/2020.
//  Copyright © 2020 Tim Green. All rights reserved.
//

import UIKit

class ViewController: UIViewController, SpawnNewBoxDelegate {
    
    var logoView = BoxView(frame: CGRect.zero)
    var bounds = CGRect()
    
    var logoWidth : CGFloat = 25.0
    var logoHeight : CGFloat = 25.0
    
    var boxes = [BoxView]()
    
    //should actually be GateView which will contain other animated components
    //but just using this as a test at the moment
    var gates = [LightningView]()


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //calculate currents bounds we want to limit the boxes to
        //later when we add some more ui elements we limit the bounds
        //the the "playing area"
        generateBounds()
        
        addBox(x: self.view.frame.width / 2.0, y: self.view.frame.height / 2.0, xvel: 1.5,yvel: 1.5)
        addGate()
        
        let timer = Timer.scheduledTimer(withTimeInterval: 0.0133, repeats: true) { _ in
            self.viewAnimation()
        }
    }
    
    func spawnNewBox(_ sender: BoxView) {
        addBox(x: sender.x, y: sender.y, xvel:  sender.xVelocity * -1, yvel: sender.yVelocity * -1)
    }
    
    func generateBounds()
    {
        bounds = CGRect(x: 0,y: 0, width: self.view.frame.width - logoWidth, height: self.view.frame.height - logoHeight)
    }
    
    func generateFrame(x: CGFloat, y: CGFloat) -> CGRect
    {
        return CGRect.init(x: x,
                           y: y,
                           width: logoWidth,
                           height: logoHeight)
    }
    
    func addGate()
    {
        //just hardcodng a location for now but will actually spawn at a random
        //location in bounds where it can fit at any rotation
        var gate = LightningView(frame: CGRect(x: 15,y: 200,width: 80,height: 45))
        
        gates.append(gate)
        self.view.addSubview(gate)
    }
    
    func addBox(x: CGFloat, y: CGFloat, xvel : CGFloat, yvel : CGFloat)
    {
        if (boxes.count < 4)
        {
            let newBox = BoxView(frame: generateFrame(x: x,y: y))
            newBox.xVelocity = xvel
            newBox.yVelocity = yvel
            newBox.gameBounds = bounds
            newBox.spawnDelegate = self
            boxes.append(newBox)
            self.view.addSubview(newBox)
        }
    }
    
    func viewAnimation()
    {
        //this can all be moved and each box handle animation individually
        //as long as they have access to the bounds
        //will also need a delegate to send back to ask for a new box
        
        boxes.forEach{ box in
            box.update()
        }
        
        
        boxes.filter({ $0.bounces == 0 }).forEach{box in box.removeFromSuperview()}
        boxes.removeAll(where: { $0.bounces == 0 })
    }
}

