//
//  MathUtil.swift
//  Bounce
//
//  Created by Tim Green on 18/04/2020.
//  Copyright © 2020 Tim Green. All rights reserved.
//

import Foundation

let G = 6.67408 * pow(10.0, -11.0)

let theta = 0.85

func pointDistance(_ A: Vector2d,_ B: Vector2d) -> Double {
    let xsquared: Double = (B.x - A.x) * (B.x - A.x)
    let ysquared: Double = (B.y - A.y) * (B.y - A.y)
    return sqrt(xsquared + ysquared)
}

func minus(_ a: Vector2d,_ b: Vector2d) -> Vector2d {
    return Vector2d(b.x - a.x, b.y - a.y)
}

func scale(_ a: Vector2d,_ Scale: Double) -> Vector2d {
    return Vector2d(a.x * Scale, a.y * Scale)
}

func add(_ a: Vector2d,_ b: Vector2d) -> Vector2d {
    return Vector2d(a.x + b.x, a.y + b.y)
}

func magnitude(_ a: Vector2d) -> Double {
    return sqrt(magnitudeSquared(a))
}

func magnitudeSquared(_ a: Vector2d) -> Double {
    return (a.x * a.x) + (a.y * a.y)
}

func CalcDistance(_ A: Body,_ B: Body) {
    var distance: Double = pointDistance(A.location, B.location)
    //we check for distance greater than 0 here because newton's formula tends to infinity at zero
    //so as to reduce the number of objects that fly off due to huge increased acceleration
    if (distance > 0.5) {
        //scale out co-ordinate distance - this can be tweaked to alter the feel
        distance /= 50000000
        let force: Double = G * ((A.mass * B.mass) / distance)
        let acceleration: Double = force / A.mass

        //vector between two objects
        var tempDistanceVector = minus(A.location, B.location)

        //scale the vector for the acceleration we feel in that direction
        let vectorMagnitude: Double = magnitude(tempDistanceVector)
        let vectorScale = Vector2d(tempDistanceVector.x / vectorMagnitude, tempDistanceVector.y / vectorMagnitude)
        tempDistanceVector = scale(vectorScale, acceleration)

        //and add it to the current vector we have
        A.acceleration = add(tempDistanceVector, A.acceleration)
    }
}
