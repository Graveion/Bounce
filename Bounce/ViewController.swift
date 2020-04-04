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
    
    var boxWidth : CGFloat = 16.0
    var boxHeight : CGFloat = 16.0
    
    var boxes = [BoxView]()
    
    //should actually be GateView which will contain other animated components
    //but just using this as a test at the moment
    var gates = [GateView]()
    
    var controlArea = ControlAreaView()
    var scoreboard = ScoreboardView()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //calculate size of control area and use it to cut down the game bounds (currently set to 1/8 screen height)
        let controlAreaRect = CGRect(x: 0,
                                 y: (self.view.frame.height - self.view.frame.height/8),
                                 width: self.view.frame.width,
                                 height: self.view.frame.height/8)
        
        controlArea = ControlAreaView(frame: controlAreaRect)
        self.view.addSubview(controlArea)

        let scoreboardRect = CGRect(x: 0,
              y: 0,
              width: 426,
              height: 129)

        scoreboard = ScoreboardView(frame: scoreboardRect)
        self.view.addSubview(scoreboard)

        
        //calculate size of scoreboard and use it to cut down the game bounds (currently set to 1/12 screen height)



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
        bounds = CGRect(x: 0,y: scoreboard.frame.height, width: self.view.frame.width - boxWidth, height: (self.view.frame.height - controlArea.frame.height - scoreboard.frame.height - boxHeight))
    }
    
    func generateFrame(x: CGFloat, y: CGFloat) -> CGRect
    {
        return CGRect.init(x: x,
                           y: y,
                           width: boxWidth,
                           height: boxHeight)
    }
//
//    func createScoreboardView() -> UIView {
//        let scoreboardView = ScoreboardView(frame: .init(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height/12))
//              self.view.addSubview(scoreboardView)
//              return scoreboardView
//    }
    
    func addGate()
    {
        //just hardcodng a location for now but will actually spawn at a random
        //location in bounds where it can fit at any rotation - See Gates
        let gate = GateView(frame: CGRect(x: 15,y: 200,width: 80,height: 45))
        
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
        boxes.forEach{ box in
            
            gates.forEach {gate in
                if (box.frame.intersects(gate.frame))
                {
                    //speed box up
                    
                    //despawn gate
                    
                    //add some score
//                    scoreboard.addScore(value: 100)
                }
            }
            
            box.update()
        }
        
        //dont like removing boxes here but for some reason it doesn't work calling self.remove in the box?
        boxes.filter({ $0.bounces == 0 }).forEach{box in box.removeFromSuperview()}
        
        //remove from array
        boxes.removeAll(where: { $0.bounces == 0 })
    }
}

