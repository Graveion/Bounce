//
//  Square.swift
//  Bounce
//
//  Created by Tim Green on 18/04/2020.
//  Copyright © 2020 Tim Green. All rights reserved.
//

import Foundation

class Square {
    var location : Vector2d
    var left : Double
    var right : Double
    var top : Double
    var bottom : Double
    var subdiv : Double

    init(_ x : Double,_ y : Double,_ length : Double) {
        location = Vector2d(x,y)
        left = x
        top = y
        right = x + length
        bottom = y + length
        subdiv = length/2
    }

    func contains(_ oX : Double,_ oY : Double) -> Bool
    {
        return oX > left && oX < right && oY > top && oY < bottom
    }

    func squareNW() -> Square {
        return Square(left, top, subdiv)
    }

    func squareNE() -> Square {
        return Square(left+subdiv, top, subdiv)
    }

    func squareSW() -> Square {
        return Square(left, top+subdiv, subdiv)
    }

    func squareSE() -> Square {

        return Square(left+subdiv, top+subdiv, subdiv)
    }

}
