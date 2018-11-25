//
//  Calculations.swift
//  MyBarbell
//
//  Created by Jason Goodney on 10/3/18.
//  Copyright © 2018 Jason Goodney. All rights reserved.
//

import Foundation

enum Unit: String, CaseIterable {
    case pounds = "lbs"
    case kilograms = "kg"
    
    static func valueFromDefaults() -> Unit {
        var value: String = ""
        let defaults = UserDefaults.standard
        if defaults.object(forKey: "SelectedUnit") == nil {
            defaults.set(BarbellController.shared.unit.rawValue, forKey: "SelectedUnit")
        } else {
            value = defaults.object(forKey: "SelectedUnit") as! String
        }
        switch value {
        case "kg":
            return .kilograms
        default:
            return .pounds
        }
    }
}

enum CalculationType {
    case addition
    case subtraction
}

class Calculations {
    
    private let kilogramsPerPound = 2.20462
    
    static func isWholeNumber(_ weight: Double) -> Bool {
        if floor(weight) == weight {
            return true
        }
        
        return false
    }
    
    func convert(_ weight: Double, to unit: Unit) -> Double {
        switch unit {
        case .pounds:
            return kilogramsToPounds(weight)
        case .kilograms:
            return poundsToKilograms(weight)
        }
    }
    
    private func poundsToKilograms(_ weight: Double) -> Double {
        let convertedWeight = weight / kilogramsPerPound
        return round(convertedWeight)
    }
    
    private func kilogramsToPounds(_ weight: Double) -> Double {
        let convertedWeight = weight * kilogramsPerPound
        return round(convertedWeight)
    }
}

extension Double {
    func round(toPlaces n: Int) -> Double {
        guard let result = Double(String(format: "%.\(n)f", self)) else {
            print("Could not convert")
            return 0
        }
        return result
    }
}
