//
//  Barbell.swift
//  MyBarbell
//
//  Created by Jason Goodney on 10/3/18.
//  Copyright © 2018 Jason Goodney. All rights reserved.
//

import Foundation

enum BarbellType: String, CaseIterable {
    case barbell = "Barbell"
    case bellabar = "Bella Bar"
    case technique = "Technique"
    
    func barInfo() -> Barbell {
        switch self {
        case .barbell:
            return Barbell(type: BarbellType.barbell.rawValue, pounds: 45, kilograms: 20)
        case .bellabar:
            return Barbell(type: BarbellType.bellabar.rawValue, pounds: 35, kilograms: 15)
        case .technique:
            return Barbell(type: BarbellType.technique.rawValue, pounds: 15, kilograms: 6.8)
        }
    }
}

struct Barbell {
    let type: String
    let weightPounds: Double
    let weightKilograms: Double
    
    var weight: Double {
        if BarbellController.shared.unit == .pounds {
            return weightPounds
        } else {
            return weightKilograms
        }
    }
    
    init(type: String, pounds: Double, kilograms: Double) {
        self.type = type
        self.weightPounds = pounds
        self.weightKilograms = kilograms
    }
}
