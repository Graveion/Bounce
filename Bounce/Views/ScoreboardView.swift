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

    @IBOutlet weak var view: UIView!
    
    var score = 0 {
        didSet{
            scoreFigure.text = String(score)
        }
    }

    @IBOutlet private var scoreLabel: UILabel! {
        didSet {
            scoreLabel.textColor = .white
        }
    }

    @IBOutlet private var scoreFigure: UILabel! {
        didSet {
            scoreFigure.textColor = .systemGray
            scoreFigure.text = String(score)
        }
    }
    
    override init(frame: CGRect) {
    super.init(frame : frame)
        if let nib = Bundle.main.loadNibNamed("ScoreCell", owner: self),
             let nibView = nib.first as? UIView {
            nibView.frame = bounds
            nibView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            addSubview(nibView)
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func addScore(value: Int) {
        score += value
    }
}
