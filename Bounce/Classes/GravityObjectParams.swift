//
//  GravityObjectParams.swift
//  Bounce
//
//  Created by Tim Green on 18/04/2020.
//  Copyright © 2020 Tim Green. All rights reserved.
//

import Foundation
import UIKit

class GravityObjectParams: MovingObjectParams {
    var mass: Double
    
    private enum CodingKeys : String, CodingKey {
        case mass
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        mass = try values.decode(Double.self, forKey: .mass)
        try super.init(from: decoder)
    }
}

