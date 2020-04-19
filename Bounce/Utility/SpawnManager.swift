//
//  SpawnManager.swift
//  Bounce
//
//  Created by Tim Green on 05/04/2020.
//  Copyright © 2020 Tim Green. All rights reserved.
//

import Foundation
import UIKit

protocol ObjectHandlerDelegate: class {
    func newObject(_ sender: GameObjectView)
    func removeObject(_ sender: GameObjectView)
}

class SpawnManager : RemoveFromOwnerDelegate
{
    func remove(_ obj: AnyObject) {
        gameObjects.removeAll(where: { $0 === obj })
        spawnDelegate?.removeObject(obj as! GameObjectView)
    }
    
    var params = ParameterData()
    var viewFactory = ViewFactory()
    weak var spawnDelegate: ObjectHandlerDelegate?
    var gameObjects = [GameObjectView]()
    
    init()
    {
        if let path = Bundle.main.path(forResource: "gameData", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path))
                
                self.params = try JSONDecoder().decode(ParameterData.self, from: data)
            } catch {
                print(error)
            }
        }
        
        //start a random object spawn timer and delegate back
        let spawnTimer = Timer.scheduledTimer(withTimeInterval: 4, repeats: true) { _ in
            var spawn : GameObjectView
            
            let selector = Int.random(in: 0...5)

            switch selector {
            case 0:
                spawn = self.spawnObject(type: GameObject.mine) as! MineView
            case 1:
                spawn = self.spawnObject(type: GameObject.mobileMine) as! MineView
            case 2:
                spawn = self.spawnObject(type: GameObject.verticalMine) as! MineView
            case 3:
                spawn = self.spawnObject(type: GameObject.horizontalMine) as! MineView
            case 4:
                spawn = self.spawnObject(type: GameObject.gate) as! GateView
            case 5:
                spawn = self.spawnObject(type: GameObject.rotatingGate) as! GateView
            default:
                spawn = self.spawnObject(type: GameObject.mine) as! MineView
            }

            self.spawnDelegate?.newObject(spawn)
        }
    }
    
    func spawnObject(type : GameObject) -> GameObjectView?
    {
        let newObj = viewFactory.spawnObject(type: type, params: params.forType[type.rawValue]!)
        newObj?.owner = self
        gameObjects.append(newObj!)
        return newObj
    }
    
    func spawnPlayer(gameDelegate : GameDelegate) -> BoxView
    {
        let player = spawnObject(type: GameObject.box) as! BoxView
        player.game = gameDelegate
        return player
    }
    
    func spawnGate()
    {
        spawnDelegate?.newObject(spawnObject(type: GameObject.gate) as! GateView)
    }
}



