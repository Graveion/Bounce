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
    func spawnObject(type : GameObject, params : ObjectParams) -> GameObjectView?
    {
        switch (params, type) {
        case (let params as MovingObjectParams, .box):
            return BoxView(params: params)
        case (let params as ObjectParams, .gate):
            return GateView(params: params)
        case (let params as RotatingGateParams, .rotatingGate):
            return RotatingGateView(params : params)
        case (let params as MovingObjectParams, .mine):
            return MineView(params : params)
        case (let params as MovingObjectParams, .mobileMine):
            return MineView(params : params)
        case (let params as MovingObjectParams, .verticalMine):
            return MineView(params : params)
        case (let params as MovingObjectParams, .horizontalMine):
            return MineView(params : params)
            
        default: return nil
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

