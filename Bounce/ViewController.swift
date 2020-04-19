//
//  ViewController.swift
//  LogoBounce
//
//  Created by Tim Green on 27/03/2020.
//  Copyright © 2020 Tim Green. All rights reserved.
//

import UIKit

//dumping this here cos its used extensively
//and don't want to pass it around
struct Global {
    static var gameBounds : CGRect = CGRect.zero
}

class ViewController: UIViewController, GameDelegate, ObjectHandlerDelegate {
    var controlArea = ControlAreaView()
    var scoreboard = ScoreboardView()
    var timer = Timer()
    var mineSpawnTimer = Timer()   
    var spawnManager = SpawnManager()
    var players = [BoxView]()
    
    //we'll move this into its own manager probably
    //annoying having to default everything
    var quadTree = Quadtree(Square(0,0,0))
    
  override func viewDidLoad() {
        super.viewDidLoad()
        
        //calculate size of control area and use it to cut down the game bounds (currently set to 1/8 screen height)
        let controlAreaRect = CGRect(x: 0,
                                 y: (self.view.frame.height - self.view.frame.height/12),
                                 width: self.view.frame.width,
                                 height: self.view.frame.height/12)
        
        controlArea = ControlAreaView(frame: controlAreaRect)
        self.view.addSubview(controlArea)
    
        scoreboard.frame = CGRect(x: 0, y: 0,
                              width: self.view.frame.width,
                              height: self.view.frame.height/5)
        
        self.view.addSubview(scoreboard)
    
        spawnManager.spawnDelegate = self

        //bounds set into globally accessible struct
        generateBounds()
        
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
            players.forEach{ $0.xVelocity *= -1 }
        }
        else
        {
            players.forEach{ $0.yVelocity *= -1 }
        }
    }
    
    func initialiseGame()
    {
        spawnManager.gameObjects.removeAll()
                
        //should give the smallest covering square
        quadTree = generateQuadtree()
        
        let player = spawnManager.spawnPlayer(gameDelegate: self)
        players.append(player)
        self.view.addSubview(player)
        
        //remove this
        addObject(spawnManager.spawnObject(type: GameObject.gravityWell) as! GravityWellView)
    
        timer = Timer.scheduledTimer(withTimeInterval: 0.0133, repeats: true) { _ in
            self.gameLoop()
        }        
    }
    
    func generateQuadtree() -> Quadtree
    {
        let length = max(Global.gameBounds.width, Global.gameBounds.height)
        return Quadtree(Square(
            Double(Global.gameBounds.minX - (length - Global.gameBounds.width/2)),
            Double(Global.gameBounds.minY - (length - Global.gameBounds.height/2)),
            Double(length * 2))
        )
    }
    
    func removeObject(_ sender: GameObjectView) {
        sender.removeFromSuperview()
    }
    
    func newObject(_ sender: GameObjectView) {
        addObject(sender)
    }
    
    func addObject(_ gameObject : GameObjectView)
    {
        self.view.addSubview(gameObject)
    }
        
    //game functions
    func spawnNewBox() {
        addObject(spawnManager.spawnObject(type: GameObject.box) as! BoxView)
    }
    
    func gameOver()
    {
        //just remove everything
        self.view.subviews.forEach({ $0.removeFromSuperview() })
        
        //stop timers
        timer.invalidate()
        timer = Timer()
        
        //pop up an alert
        let alert = UIAlertController(title: "Game Over!", message: "Tap to restart the game", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .default, handler: { _ in
            self.initialiseGame()
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func score(_ score: Int) {
        scoreboard.addScore(value: score)
    }
    
    func generateBounds()
    {
        Global.gameBounds = CGRect(x: 0,
                        y: self.view.frame.height/5,
                        width: self.view.frame.width,
                        height: (self.view.frame.height - controlArea.frame.height - self.view.frame.height/5))
    }
    
    func gameLoop()
    {
        //have to regen tree every loop
        //so we can reinsert nodes
        quadTree = generateQuadtree()
        
        //get all objects we want to follow gravity rules
        //need to do this before position is updated
        let gravityObjects = spawnManager.gameObjects.compactMap({ $0 as? Gravity })
        
        //insert them into the tree
        gravityObjects.forEach{quadTree.insert($0.body)}
        
        //have to wait til all nodes inserted before we can calc
        gravityObjects.forEach{
            quadTree.findForce($0.body)
            $0.addImpulse()
        }
    
        //position
        spawnManager.gameObjects.forEach{obj in  obj.update() }
        
        //collision
        let collisionObjects = spawnManager.gameObjects.reversed().compactMap({ $0 as? Collidable })
        
        //need at least 2 objects for collision
        if (collisionObjects.count >= 2)
        {
            collisionObjects.forEach{ cObj in
                
                //only need to loop forward from own index
                let index = collisionObjects.firstIndex(where: { $0 === cObj }) ?? 0
                
                for i in index+1..<collisionObjects.count {
                    
                    if (cObj.collisionBox().intersects(collisionObjects[i].collisionBox()))
                        {
                            cObj.collision(with: collisionObjects[i] as! GameObjectView)
                            collisionObjects[i].collision(with: cObj as! GameObjectView)
                        }
                }
            }
        }
        
        
        
        //######TODO
        //make box/mine grav params
        //mess with mass/distance etc enough that we get sensible gravity
    }
    
    
}

