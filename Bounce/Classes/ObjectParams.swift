//
//  ObjectParams.swift
//  Bounce
//
//  Created by Tim Green on 05/04/2020.
//  Copyright © 2020 Tim Green. All rights reserved.
//

import Foundation
import UIKit

class ObjectParams: Decodable {
    let width: CGFloat
    let height: CGFloat
    
    
    private enum CodingKeys : String, CodingKey {
        case width
        case height
        
    }
    
     required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        width = try values.decode(CGFloat.self, forKey: .width)
        height = try values.decode(CGFloat.self, forKey: .height)
    }
    
//    func encode(to encoder: Encoder) throws {
//        var container = encoder.container(keyedBy: CodingKeys.self)
//        try container.encode(width, forKey: .width)
//        try container.encode(height, forKey: .height)
//    }
}
