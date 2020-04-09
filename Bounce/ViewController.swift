//
//  ViewController.swift
//  LogoBounce
//
//  Created by Tim Green on 27/03/2020.
//  Copyright © 2020 Tim Green. All rights reserved.
//

import UIKit

class ViewController: UIViewController, SpawnNewBoxDelegate, GameOverDelegate {
    
    var gameBounds = CGRect()
    
    var boxes = [BoxView]()
    var gates = [GateView]()
    var mines = [MineView]()
    
    var controlArea = ControlAreaView()
    var scoreboard = ScoreboardView()
    var timer = Timer()
    var mineSpawnTimer = Timer()   
    var viewFactory = ViewFactory(screenWidth: 0,screenHeight: 0, gameBounds: CGRect.zero)
    
  override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //calculate size of control area and use it to cut down the game bounds (currently set to 1/8 screen height)
        let controlAreaRect = CGRect(x: 0,
                                 y: (self.view.frame.height - self.view.frame.height/12),
                                 width: self.view.frame.width,
                                 height: self.view.frame.height/12)
        
        controlArea = ControlAreaView(frame: controlAreaRect)
        self.view.addSubview(controlArea)
        
        
        //calculate size of scoreboard and use it to cut down the game bounds (currently set to 1/12 screen height)
        scoreboard = ScoreboardView(frame: .zero)
        self.view.addSubview(scoreboard)

        
        //calculate size of scoreboard and use it to cut down the game bounds (currently set to 1/12 screen height)
 
        //calculate currents bounds we want to limit the boxes to
        //later when we add some more ui elements we limit the bounds
        //the the "playing area"
        generateBounds()
        
        viewFactory = ViewFactory(screenWidth: self.view.frame.width, screenHeight: self.view.frame.height, gameBounds: gameBounds)
        
        //just testing
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.tapped(_:)))
        self.view.addGestureRecognizer(tapGesture)
    
        initialiseGame()
    }
    
    @objc func tapped(_ sender: UITapGestureRecognizer) {

        let point = sender.location(in: self.view)

        //check location half
        if (point.x < self.view.frame.maxX / 2)
        {
            //flip y
            boxes.forEach{ box in box.xVelocity *= -1 }
        }
        else
        {
            boxes.forEach{ box in box.yVelocity *= -1 }
        }
    }
    
    func initialiseGame()
    {
        boxes.removeAll()
        gates.removeAll()
        mines.removeAll()
        
        self.view.addSubview(controlArea)
        self.view.addSubview(scoreboard)
        
        spawnBox()
        spawnGate()
        
        timer = Timer.scheduledTimer(withTimeInterval: 0.0133, repeats: true) { _ in
            self.gameLoop()
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
        spawnBox()
    }
    
    func generateBounds()
    {
        gameBounds = CGRect(x: 0,
                        y: self.view.frame.height/12,
                        width: self.view.frame.width,
                        height: (self.view.frame.height - controlArea.frame.height - self.view.frame.height/12))
    }
    
    
    //spawn logic to be moved into spawnManager eventually
    func spawnMine()
    {
        if (mines.count < 4)
        {
            var mine : MineView
            
            let selector = Int.random(in: 0...3)
            
            switch selector {
            case 0:
                 mine = viewFactory.spawnObject(type: GameObject.mine) as! MineView
            case 1:
                 mine = viewFactory.spawnObject(type: GameObject.mobileMine) as! MineView
            case 2:
                 mine = viewFactory.spawnObject(type: GameObject.verticalMine) as! MineView
            case 3:
                 mine = viewFactory.spawnObject(type: GameObject.horizontalMine) as! MineView
            default:
                 mine = viewFactory.spawnObject(type: GameObject.mine) as! MineView
            }
            
            mines.append(mine)
            self.view.addSubview(mine)
        }
    }
//
//    func createScoreboardView() -> UIView {
//        let scoreboardView = ScoreboardView(frame: .init(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height/12))
//              self.view.addSubview(scoreboardView)
//              return scoreboardView
//    }
    
    func spawnGate()
    {
        var gate : GateView
        
        let selector = Int.random(in: 0...1)
        
        switch selector {
        case 0:
             gate = viewFactory.spawnObject(type: GameObject.gate) as! GateView
        case 1:
            gate = viewFactory.spawnObject(type: GameObject.rotatingGate) as! GateView
        default:
            gate = viewFactory.spawnObject(type: GameObject.gate) as! GateView
        }
        
        gates.append(gate)
        self.view.addSubview(gate)
    }
    
    func spawnBox()
    {
        if (boxes.count < 4)
        {
            let box = viewFactory.spawnObject(type: GameObject.box) as! BoxView
            box.spawnDelegate = self
            box.gameOverDelegate = self
            boxes.append(box)
            self.view.addSubview(box)
        }
    }
    
    func gameLoop()
    {
        boxes.forEach{ box in
            
            gates.reversed().forEach {gate in
                if (gate.collisionBox().contains(box.center))
                {
                    //speed box up temporarily?
                    //40% inital boost
                    //scaled down over 3 seconds
                    box.addBuff(buff: Buff(value: 0.4, duration: .long, type: .speed, owner: box))
                    
                    //despawn gate
                    gates.remove(at: gates.firstIndex(of: gate)!)
                    
                    gate.removeFromSuperview()
                    
                    //add some score
                    scoreboard.addScore(value: 100)
                    
                    //spawn a new gate
                    spawnGate()
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
        
        mines.forEach {mine in
            mine.update()
        }
        
        //dont like removing boxes here but for some reason it doesn't work calling self.remove in the box?
        boxes.filter({ $0.bounces == 0 }).forEach{box in box.removeFromSuperview()}
        
        //remove from array
        boxes.removeAll(where: { $0.bounces == 0 })
    }
    
    
}

