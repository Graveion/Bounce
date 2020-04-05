//
//  MovingObjectParams.swift
//  Bounce
//
//  Created by Tim Green on 05/04/2020.
//  Copyright © 2020 Tim Green. All rights reserved.
//

import Foundation
import UIKit

class MovingObjectParams: ObjectParams {
    
    var xVelocity: CGFloat
    var yVelocity: CGFloat
    
    private enum CodingKeys : String, CodingKey {
        case xVelocity
        case yVelocity
    }
    
     required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        xVelocity = try values.decode(CGFloat.self, forKey: .xVelocity)
        yVelocity = try values.decode(CGFloat.self, forKey: .yVelocity)
        
        try super.init(from: decoder)
    }
}
