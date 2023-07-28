//
//  BarbellStore.swift
//  MyBarbell
//
//  Created by Jason Goodney on 5/31/20.
//  Copyright © 2020 Jason Goodney. All rights reserved.
//

import Foundation

class BarbellStore: ObservableObject {
    
    var isEmpty: Bool {
        totalWeight == barbellWeight()
    }
    
    @Published var totalWeight: Double = 0
    @Published var barbellType: BarbellType = UserDefaults.standard.object(forKey: "BarbellTypeKey") as? BarbellType ?? .barbell {
         didSet {
             calculateTotalWeight()
            let encoder = JSONEncoder()

            if let data = try? encoder.encode(barbellType) {
                UserDefaults.standard.set(data, forKey: "BarbellTypeKey")
            }
         }
     }
    
    @Published var unitOfMeasure: UnitOfMeasure = UserDefaults.standard.object(forKey: "UnitOfMeasureKey") as? UnitOfMeasure ?? .pound {
         didSet {
             calculateTotalWeight()
            let encoder = JSONEncoder()

            if let data = try? encoder.encode(unitOfMeasure) {
                UserDefaults.standard.set(data, forKey: "UnitOfMeasureKey")
            }
         }
     }
    
    init() {
        if let data = UserDefaults.standard.data(forKey: "UnitOfMeasureKey") {
            let decoder = JSONDecoder()
            
            if let unitOfMeasure = try? decoder.decode(UnitOfMeasure.self, from: data) {
                self.unitOfMeasure = unitOfMeasure
            }
        }
        
        if let data = UserDefaults.standard.data(forKey: "BarbellTypeKey") {
            let decoder = JSONDecoder()
            
            if let barbellType = try? decoder.decode(BarbellType.self, from: data) {
                self.barbellType = barbellType
            }
        }
    }
    
    func calculateTotalWeight() {
        var weightOfPlates = 0.0
        
        let plateSet = unitOfMeasure == .pound ? poundPlateSet : kilogramPlateSet
        
        for type in PlateType.allCases {
            let plates = plateSet[type]!
            weightOfPlates += plates.reduce(0, { $0 + $1.totalWeight })
        }
        
        totalWeight = weightOfPlates + self.barbellWeight()
        
    }
    
    func clearPlates() {
        let plateSet = unitOfMeasure == .pound ? poundPlateSet : kilogramPlateSet
        
        for type in PlateType.allCases {
            let plates = plateSet[type]!
            plates.forEach({ $0.countOnBarbell = 0 })
        }
        
        totalWeight = self.barbellWeight()
    }
    
    func toggleUnitOfMeasure() {
        switch unitOfMeasure {
        case .pound:
            unitOfMeasure = .kilogram
        case .kilogram:
            unitOfMeasure = .pound
        }
    }
    
    private func barbellWeight() -> Double {
        switch barbellType {
        case .barbell:
            switch unitOfMeasure {
            case .pound:
                return 45
            case .kilogram:
                return 20
            }
            
        case .bellaBar:
            switch unitOfMeasure {
            case .pound:
                return 35
            case .kilogram:
                return 15
            }
            
        case .junior:
            switch unitOfMeasure {
            case .pound:
                return 22
            case .kilogram:
                return 10
            }
            
        case .technique:
            switch unitOfMeasure {
            case .pound:
                return 15
            case .kilogram:
                return 5
            }
        }
    }
    
    var poundPlateSet: [PlateType: [Plate]] = [
        .standard: [
            Plate(weight: 55, color: .red),
            Plate(weight: 45, color: .blue),
            Plate(weight: 35, color: .yellow),
            Plate(weight: 25, color: .green),
            Plate(weight: 15),
            Plate(weight: 10)
        ],
        .change: [
            Plate(weight: 5, color: .blue),
            Plate(weight: 2.5, color: .green),
            Plate(weight: 1.25, color: .gray)
        ],
        .fractional: [
            Plate(weight: 1, color: .red),
            Plate(weight: 0.75, color: .blue),
            Plate(weight: 0.5, color: .yellow),
            Plate(weight: 0.25, color: .green),
        ],
        .heavy: [
            Plate(weight: 100),
            Plate(weight: 65)
        ]
    ]
    
    var kilogramPlateSet: [PlateType: [Plate]] = [
        .standard: [
            Plate(weight: 25, color: .red),
            Plate(weight: 20, color: .blue),
            Plate(weight: 15, color: .yellow),
            Plate(weight: 10, color: .green),
            Plate(weight: 5),
        ],
        .change: [
            Plate(weight: 2.5, color: .red),
            Plate(weight: 2, color: .blue),
            Plate(weight: 1.5, color: .yellow),
            Plate(weight: 1, color: .green),
            Plate(weight: 0.5, color: .gray)
        ],
        .fractional: [
            Plate(weight: 0.25, color: .red),
            Plate(weight: 0.125, color: .blue),
        ],
        .heavy: [
            Plate(weight: 50)
        ]
    ]
}
