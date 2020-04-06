//
//  RotatingGateParams.swift
//  Bounce
//
//  Created by Tim Green on 05/04/2020.
//  Copyright © 2020 Tim Green. All rights reserved.
//

import Foundation
import UIKit

class RotatingGateParams: ObjectParams {
    var loopDuration : Double
    
    private enum CodingKeys : String, CodingKey {
        case loopDuration
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        loopDuration = try values.decode(Double.self, forKey: .loopDuration)
        
        try super.init(from: decoder)
    }
}
