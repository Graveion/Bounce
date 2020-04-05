//
//  SpawnManager.swift
//  Bounce
//
//  Created by Tim Green on 05/04/2020.
//  Copyright © 2020 Tim Green. All rights reserved.
//

import Foundation
import UIKit

class SpawnManager
{
    var gameBounds : CGRect
    var params = ParameterData()
    
    init(gameBounds : CGRect)
    {
        self.gameBounds = gameBounds
        //it aint pretty but...
        //switch on object name in json object
        //case.box = return BoxParams etc...
        
        if let path = Bundle.main.path(forResource: "gameData", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path))
                
                self.params = try JSONDecoder().decode(ParameterData.self, from: data)
              } catch {
                   print(error)
              }
        }
    }
    
    //this will work for now but we need a more complicated solution thats ensures
    //that for example a mine cant spawn on the player or a gate spawns on a mine
    func randomSafeLocationInBounds(width : CGFloat, height : CGFloat) -> CGRect
    {
        return CGRect(
        x: CGFloat.random(in: gameBounds.minX...gameBounds.maxX - width),
        y: CGFloat.random(in: gameBounds.minY...gameBounds.maxY - height),
        width: width,
        height: height)
    }
}
