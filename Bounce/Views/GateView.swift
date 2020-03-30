//
//  GateView.swift
//  LogoBounce
//
//  Created by Tim Green on 29/03/2020.
//  Copyright © 2020 Tim Green. All rights reserved.
//

import Foundation
import UIKit

class GateView : UIView
{
    var x : CGFloat = 0.0
    var y : CGFloat = 0.0

    override init(frame: CGRect) {
        super.init(frame : frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func updateConstraints() {
        super.updateConstraints()
    }
    
    override func draw(_ rect: CGRect) {
        
    }
    
    func animate()
    {
        UIView.animate(withDuration: 0.5,
                    delay: 0.0,
                    usingSpringWithDamping: 0.3,
                    initialSpringVelocity: 3,
                    options: UIView.AnimationOptions.curveEaseInOut,
                    animations: ({
                        self.transform = CGAffineTransform(scaleX : 1.4, y: 1.4)
                }), completion: { _ in
                    UIView.animate(withDuration: 0.5,
                                   animations: ({self.transform = .identity}),
                                   completion: nil)
                })
        
    }
    
    
}


