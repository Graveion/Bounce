//
//  ScoreboardView.swift
//  Bounce
//
//  Created by Tim Green on 04/04/2020.
//  Copyright © 2020 Tim Green. All rights reserved.
//

import Foundation
import UIKit

class ScoreboardView : UIView {
    var score = 0

    @IBOutlet private var scoreLabel: UILabel! {
        didSet {
            scoreLabel.textColor = .white
        }
    }

    @IBOutlet private var scoreFigure: UILabel! {
        didSet {
            scoreFigure.textColor = .systemGray
        }
    }
    
    override init(frame: CGRect) {
    super.init(frame : frame)
        commonInit()

        if let nib = Bundle.main.loadNibNamed("ScoreCell", owner: self),
             let nibView = nib.first as? UIView {
//               nibView.frame =
               addSubview(nibView)
        }

    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    private func commonInit() {
        backgroundColor = UIColor.systemPink
    }
    
    func addScore(value: Int) {
        score += value
    }
}

