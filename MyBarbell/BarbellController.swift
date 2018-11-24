//
//  BarbellController.swift
//  MyBarbell
//
//  Created by Jason Goodney on 10/3/18.
//  Copyright © 2018 Jason Goodney. All rights reserved.
//

import Foundation

class BarbellController {
    
    // MARK: - Properties
    static let shared = BarbellController(); private init() {}
    
    let bars: [Barbell] = [Barbell(type: "Barbell", pounds: 45, kilograms: 20),
                           Barbell(type: "Bella Bar", pounds: 35, kilograms: 15),
                           Barbell(type: "Technique", pounds: 15, kilograms: 6.8)]
    
    var selectedBarType: BarbellType = .barbell
    var totalPlateCount = 0
    
    private let platesInPounds: [[Plate]] = [
        [Plate(weight: 45), Plate(weight: 35), Plate(weight: 25), Plate(weight: 15), Plate(weight: 10) ],
        [Plate(weight: 5), Plate(weight: 2.5), Plate(weight: 1), Plate(weight: 0.5)],
        [Plate(weight: 100), Plate(weight: 55)]
    ]
    
    private let platesInKilograms: [[Plate]] = [
        [Plate(weight: 20), Plate(weight: 15), Plate(weight: 10), Plate(weight: 5)],
        [Plate(weight: 2.5), Plate(weight: 2), Plate(weight: 1), Plate(weight: 0.5)],
        [Plate(weight: 50), Plate(weight: 25)]
    ]
    
    var dataSource: [[Plate]] = [[]]
    
    var unit: Unit = .pounds {
        didSet {
            switch unit {
            case .pounds:
                dataSource = platesInPounds
            case .kilograms:
                dataSource = platesInKilograms
            }
        }
    }

    // MARK: - Functions
    func weightAsString(_ weight: Double) -> String {
        if Calculations.isWholeNumber(weight) {
            return "\(Int(weight))"
        }
        
        return "\(weight)"
    }
    
    func calculateCurrentWeight(forBar bar: Barbell, andPlatesOnBar plates: [[Plate]], by type: CalculationType) -> Double {
        let platesArray = plates.flatMap { $0 }
        
        var resultWeight: Double = BarbellController.shared.unit == .pounds ?
            bar.weightPounds : bar.weightKilograms
        for plate in platesArray {
            if plate.count > 0 {
                resultWeight += (Double(plate.count) * plate.weight)
            }
        }
        
        return resultWeight
    }
    
    func empty(_ bar: Barbell, withPlates plates: [[Plate]]) -> Double {
        for group in plates {
            for plate in group {
                plate.count = 0
            }
        }
        
        return BarbellController.shared.calculateCurrentWeight(forBar: bar, andPlatesOnBar: plates, by: .subtraction)
    }
    
    func empty() -> Double {
        let bar = BarbellController.shared.selectedBarType.barInfo()
        let plates = dataSource
        for group in plates {
            for plate in group {
                plate.count = 0
            }
        }
        
        return BarbellController.shared.calculateCurrentWeight(forBar: bar, andPlatesOnBar: plates, by: .subtraction)
    }
}
