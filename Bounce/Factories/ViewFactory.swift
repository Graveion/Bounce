//
//  ViewFactory.swift
//  Bounce
//
//  Created by Tim Green on 05/04/2020.
//  Copyright © 2020 Tim Green. All rights reserved.
//

import Foundation
import UIKit

typealias Size = (width: CGFloat, height : CGFloat)


class ViewFactory
{
    var gameBounds : CGRect
    let spawnManager : SpawnManager
    
    init(screenWidth : CGFloat, screenHeight : CGFloat, gameBounds: CGRect)
    {
        //use width/Height against 11 Pro Max to calc a ratio to scale against
        //assuming aspect ratio is fairly consistent..
        self.gameBounds = gameBounds
        self.spawnManager = SpawnManager(gameBounds: gameBounds)
    }
    
    func spawnObject(type : GameObject) -> UIView
    {
        switch type {
        case .box:
             let params = spawnManager.params.forType[type.rawValue] as! MovingObjectParams
             return BoxView(frame: spawnManager.randomSafeLocationInBounds(width: params.width, height: params.height),
                            xVelocity: params.xVelocity,
                            yVelocity: params.yVelocity,
                            gameBounds: self.gameBounds)
        case .gate:
            let params = spawnManager.params.forType[type.rawValue]!
            return GateView(frame: spawnManager.randomSafeLocationInBounds(width: params.width, height: params.height),
                                   xVelocity: 0,
                                   yVelocity: 0,
                                   gameBounds: self.gameBounds)
        case .rotatingGate:
            let params = spawnManager.params.forType[type.rawValue] as! RotatingGateParams
            return RotatingGateView(frame: spawnManager.randomSafeLocationInBounds(width: params.width, height: params.height),
                                    xVelocity: 0,
                                    yVelocity: 0,
                                    gameBounds: self.gameBounds,
                                    loopDuration: params.loopDuration)
        case .mine:
        let params = spawnManager.params.forType[type.rawValue]!
        return MineView(frame: spawnManager.randomSafeLocationInBounds(width: params.width, height: params.height),
                       xVelocity: 0,
                       yVelocity: 0,
                       gameBounds: self.gameBounds)
        
        case .mobileMine:
        let params = spawnManager.params.forType[type.rawValue] as! MovingObjectParams
        return MineView(frame: spawnManager.randomSafeLocationInBounds(width: params.width, height: params.height),
                       xVelocity: params.xVelocity,
                       yVelocity: params.yVelocity,
                       gameBounds: self.gameBounds)
            
        case .verticalMine:
        let params = spawnManager.params.forType[type.rawValue] as! MovingObjectParams
        return MineView(frame: spawnManager.randomSafeLocationInBounds(width: params.width, height: params.height),
                       xVelocity: params.xVelocity,
                       yVelocity: params.yVelocity,
                       gameBounds: self.gameBounds)
            
        case .horizontalMine:
        let params = spawnManager.params.forType[type.rawValue] as! MovingObjectParams
        return MineView(frame: spawnManager.randomSafeLocationInBounds(width: params.width, height: params.height),
                       xVelocity: params.xVelocity,
                       yVelocity: params.yVelocity,
                       gameBounds: self.gameBounds)
        }
    }
}

enum GameObject: String, CaseIterable, CodingKey {
    case box = "box"
    case gate = "gate"
    case rotatingGate = "rotatingGate"
    case mine = "mine"
    case mobileMine = "mobileMine"
    case verticalMine = "verticalMine"
    case horizontalMine = "horizontalMine"
}

