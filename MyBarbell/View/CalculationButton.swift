//
//  CalculationButton.swift
//  MyBarbell
//
//  Created by Jason Goodney on 10/2/18.
//  Copyright © 2018 Jason Goodney. All rights reserved.
//

import UIKit

enum Operation: String {
    case plus  = "+"
    case minus = "−"
    case none  = ""
}


class CalculationButton: UIButton {

    // MARK: - Properites
    var operation: Operation = .none {
        didSet {
            setTitle(operation.rawValue, for: .normal)
        }
    }
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
 
        setTitleColor(.white, for: .normal)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = frame.height / 2
        clipsToBounds = true
    }

}

