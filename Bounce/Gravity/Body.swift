//
//  Body.swift
//  Bounce
//
//  Created by Tim Green on 18/04/2020.
//  Copyright © 2020 Tim Green. All rights reserved.
//

import Foundation

class Body {

    var acceleration = Vector2d(0.0, 0.0)
    var state = State.Empty
    var mass : Double
    var location : Vector2d

    init(_ mass: Double,_ location: Vector2d) {
        self.mass = mass
        self.location = location
    }
}

enum State {
    case Empty
    case Filled
}
