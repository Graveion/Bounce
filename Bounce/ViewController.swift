//
//  ViewController.swift
//  LogoBounce
//
//  Created by Tim Green on 27/03/2020.
//  Copyright © 2020 Tim Green. All rights reserved.
//

import UIKit

class ViewController: UIViewController, SpawnNewBoxDelegate, GameOverDelegate {
    
    var logoView = BoxView(frame: CGRect.zero)
    var bounds = CGRect()
    
    var boxWidth : CGFloat = 16.0
    var boxHeight : CGFloat = 16.0
    
    var boxes = [BoxView]()
    var gates = [GateView]()
    var mines = [MineView]()
    
    var controlArea = ControlAreaView()
    var scoreboard = ScoreboardView()
    
    var timer = Timer()
    var mineSpawnTimer = Timer()


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //calculate size of control area and use it to cut down the game bounds (currently set to 1/8 screen height)
        let controlAreaRect = CGRect(x: 0,
                                 y: (self.view.frame.height - self.view.frame.height/8),
                                 width: self.view.frame.width,
                                 height: self.view.frame.height/8)
        
        controlArea = ControlAreaView(frame: controlAreaRect)
        
        
        //calculate size of scoreboard and use it to cut down the game bounds (currently set to 1/12 screen height)
        let scoreboardRect = CGRect(x: 0,
        y: 0,
        width: self.view.frame.width,
        height: self.view.frame.height/12)
        
        scoreboard = ScoreboardView(frame: scoreboardRect)
        
        
        initialiseGame()
    }
    
    func initialiseGame()
    {
        boxes.removeAll()
        gates.removeAll()
        mines.removeAll()
        
        self.view.addSubview(controlArea)
        self.view.addSubview(scoreboard)
        
        //calculate currents bounds we want to limit the boxes to
        //later when we add some more ui elements we limit the bounds
        //the the "playing area"
        generateBounds()
        
        addBox(x: self.view.frame.width / 2.0, y: self.view.frame.height / 2.0, xvel: 1.5,yvel: 1.5)
        addGate()
        
        timer = Timer.scheduledTimer(withTimeInterval: 0.0133, repeats: true) { _ in
            self.viewAnimation()
        }
        
        mineSpawnTimer = Timer.scheduledTimer(withTimeInterval: 10, repeats: true) { _ in
            self.spawnMine()
        }
    }
    
    
    func gameOver()
    {
        
        //just remove everything
        self.view.subviews.forEach({ $0.removeFromSuperview() })
        
        //stop timers
        timer.invalidate()
        timer = Timer()
        
        mineSpawnTimer.invalidate()
        mineSpawnTimer = Timer()
        
        //pop up an alert
        let alert = UIAlertController(title: "Game Over!", message: "Tap to restart the game", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "????"), style: .default, handler: { _ in
            self.initialiseGame()
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func spawnNewBox(_ sender: BoxView) {
        addBox(x: sender.x, y: sender.y, xvel:  sender.xVelocity * -1, yvel: sender.yVelocity * -1)
    }
    
    func generateBounds()
    {
        bounds = CGRect(x: 0,
                        y: scoreboard.frame.height,
                        width: self.view.frame.width,
                        height: (self.view.frame.height - controlArea.frame.height - scoreboard.frame.height))
    }
    
    func spawnMine()
    {
        //change collision to bounds intersection
        
        if (mines.count < 4)
        {
            let newMine = MineView(frame: CGRect(
                    x: CGFloat.random(in: 0...bounds.maxX - boxWidth),
                    y: CGFloat.random(in: 0...bounds.maxY - boxHeight),
                    width: boxWidth,
                    height: boxHeight))
            
            newMine.gameBounds = bounds
            mines.append(newMine)
            self.view.addSubview(newMine)
        }
    }
    
    func addGate()
    {
        //just hardcodng a location for now but will actually spawn at a random
        //location in bounds where it can fit at any rotation - See Gates
        var gate = GateView(frame: CGRect(x: 15,y: 200,width: 80,height: 45))
        
        gates.append(gate)
        self.view.addSubview(gate)
    }
    
    func addBox(x: CGFloat, y: CGFloat, xvel : CGFloat, yvel : CGFloat)
    {
        if (boxes.count < 4)
        {
            let newBox = BoxView(frame: CGRect(
                        x: x,
                        y: y,
                        width: boxWidth,
                        height: boxHeight))
            newBox.xVelocity = xvel
            newBox.yVelocity = yvel
            newBox.gameBounds = bounds
            newBox.spawnDelegate = self
            newBox.gameOverDelegate = self
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
                    //speed box up temporarily
                    
                    //despawn gate
                    
                    //add some score
                    scoreboard.addScore(value: 100)
                }
            }
            
            mines.forEach {mine in
                if (box.frame.intersects(mine.frame))
                {
                    box.damage()
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

