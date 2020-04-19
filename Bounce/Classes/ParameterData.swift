//
//  ParameterData.swift
//  Bounce
//
//  Created by Tim Green on 05/04/2020.
//  Copyright © 2020 Tim Green. All rights reserved.
//

import Foundation
import UIKit

class ParameterData: Decodable {
    var forType : Dictionary<String, ObjectParams> = [:]
    
    init()
    {
        
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: GameObject.self)
        
        for type in GameObject.allCases {
            
            switch type {
            case .box:
                forType[type.rawValue] = try values.decode(GravityObjectParams.self, forKey: type)
            case .gate:
                forType[type.rawValue] = try values.decode(ObjectParams.self, forKey: type)
            case .rotatingGate:
                forType[type.rawValue] = try values.decode(RotatingGateParams.self, forKey: type)
            case .mine:
                forType[type.rawValue] = try values.decode(GravityObjectParams.self, forKey: type)
            case .mobileMine:
                forType[type.rawValue] = try values.decode(GravityObjectParams.self, forKey: type)
            case .verticalMine:
                forType[type.rawValue] = try values.decode(GravityObjectParams.self, forKey: type)
            case .horizontalMine:
                forType[type.rawValue] = try values.decode(GravityObjectParams.self, forKey: type)
            case .gravityWell:
                forType[type.rawValue] = try values.decode(GravityObjectParams.self, forKey: type)
            }
        }
    }
}
