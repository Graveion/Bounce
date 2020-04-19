//
//  Quadtree.swift
//  Bounce
//
//  Created by Tim Green on 18/04/2020.
//  Copyright © 2020 Tim Green. All rights reserved.
//

import Foundation

class Quadtree {

    // body or aggregate body stored in this node
    var body = Body(0.0, Vector2d(0.0, 0.0))
    var NW // tree representing northwest quadrant
            : Quadtree? = nil
    var NE // tree representing northeast quadrant
            : Quadtree? = nil
    var SW // tree representing southwest quadrant
            : Quadtree? = nil
    var SE // tree representing southeast quadrant
            : Quadtree? = nil

    var aggregateMass = 0.0
    var aggregateLocation = Vector2d(0.0, 0.0)
    var square : Square

    init(_ square : Square) {
        self.square = square
    }

    //To insert a body b into the tree rooted at node x, use the following recursive procedure:
    //If node x is an internal node, update the center-of-mass and total mass of x. Recursively insert the body b in the appropriate quadrant.
    //If node x is an external node, say containing a body named c, then there are two bodies b and c in the same region.
    //Subdivide the region further by creating four children. Then, recursively insert both b and c into the appropriate quadrant(s).
    //Since b and c may still end up in the same quadrant, there may be several subdivisions during a single insertion.
    //Finally, update the center-of-mass and total mass of x.
    func insert(_ B: Body) {
        if (CheckInternal()) {
            checkQuadrant(B)

            if (CheckEmptyChildren()) { //children are empty we need to calculate CoM with aggregate data.
                NodeMassCentreAggregate()
            } else {
                NodeMassCentre()
            }
        } else if (body.state == State.Empty) {
            //external
            body = B
            body.state = State.Filled
        } else {
            //I am an external node with an item and need to create subdivisions to fit in a new item and my own.
            //Since we have created new trees I should never be counted as external and thus no new nodes can
            //be attributed to me
            checkQuadrant(B)

            insert(body)

            body = Body(0.0, Vector2d(0.0, 0.0))
            body.state = State.Empty
        }
    }

    func checkQuadrant(_ B: Body) {
        //find where we need to insert new node
        //or create a new child node
        if (square.squareNW().contains(B.location.x, B.location.y)) {
            if (NW == nil) {
                NW = Quadtree(square.squareNW())
            }
            NW!.insert(B)
        } else if (square.squareNE().contains(B.location.x, B.location.y)) {
            if (NE == nil) {
                NE = Quadtree(square.squareNE())
            }
            NE!.insert(B)
        } else if (square.squareSW().contains(B.location.x, B.location.y)) {
            if (SW == nil) {
                SW = Quadtree(square.squareSW())
            }
            SW!.insert(B)
        } else if (square.squareSE().contains(B.location.x, B.location.y)) {
            if (SE == nil) {
                SE = Quadtree(square.squareSE())
            }
            SE!.insert(B)
        }
    }

    func findForce(_ a: Body) {
        //Calculating the force acting on a body. To calculate the net force acting on body b, use the following recursive procedure,
        //starting with the root of the quad-tree:
        //If the current node is an external node then if it isn't b, calculate the force exerted by the current node on b,
        //Otherwise, calculate the ratio s / d.
        //Where s is the width of the region represented by the internal node, and d is the distance between the body and the node's center-of-mass.
        //If s / d < θ, treat this internal node as a single body
        //Otherwise, run the procedure recursively on each of the current node's children.

        if (!CheckInternal()) {

            if (a !== body) {
                //external node so calc the acceleration vector for A based on this nodes mass
                //possible to be an external node without an atomic as all 4 quadrants are created at once
                if (body.state == State.Filled) {
                    CalcDistance(a, body)
                }
            }
            return
        } else {
            //internal node check for s/d
            let d = pointDistance(a.location, aggregateLocation)

            if (((square.subdiv * 2) / d) < theta) {
                //s/d < theta so we aggregate this nodes data and calculate the acceleration vector..
                let nodeCentre = Body(aggregateMass, aggregateLocation)
                CalcDistance(a, nodeCentre)
            } else {
                //recursively call for children
                NW?.findForce(a)
                NE?.findForce(a)
                SW?.findForce(a)
                SE?.findForce(a)
            }

        }

    }

    func CentreOfMass(_ particles: [Body]) -> Body {
        //sum up masses
        let m = particles.map { $0.mass }.reduce(0,+)

        let x = particles.map { $0.location.x * $0.mass }.reduce(0,+) / m
        let y = particles.map { $0.location.y * $0.mass }.reduce(0,+) / m

        return Body(m, Vector2d(x, y))
    }


    func NodeMassCentre() {

        var activeNodes = [Body]()

        if (NW != nil) {activeNodes.append(NW!.body)}
        if (NE != nil) {activeNodes.append(NE!.body)}
        if (SW != nil) {activeNodes.append(SW!.body)}
        if (SE != nil) {activeNodes.append(SE!.body)}

        let centre = CentreOfMass(activeNodes)

        aggregateLocation = centre.location
        aggregateMass = centre.mass
    }

    func NodeMassCentreAggregate() {
        var activeNodes = [Body]()

        //needs to be the aggregate data of the nodes.
        if (NW?.aggregateMass != 0.0 && NW?.aggregateLocation != nil) {
            activeNodes.append(Body(NW!.aggregateMass, NW!.aggregateLocation))
        }

        if (NE?.aggregateMass != 0.0 && NE?.aggregateLocation != nil) {
            activeNodes.append(Body(NE!.aggregateMass, NE!.aggregateLocation))
        }
        if (SE?.aggregateMass != 0.0 && SE?.aggregateLocation != nil) {
            activeNodes.append(Body(SE!.aggregateMass, SE!.aggregateLocation))
        }
        if (SW?.aggregateMass != 0.0 && SW?.aggregateLocation != nil) {
            activeNodes.append(Body(SW!.aggregateMass, SW!.aggregateLocation))
        }

        let centre = CentreOfMass(activeNodes)
        aggregateLocation = centre.location
        aggregateMass = centre.mass
    }


    func CheckInternal() -> Bool {
        //if all my children are empty then I am external
        return !(NW == nil && NE == nil && SW == nil && SE == nil)
    }

    func CheckEmptyChildren() -> Bool {
        return (NW?.body == nil && SW?.body == nil && NE?.body == nil && SE?.body == nil)
    }

}
