//
//  Plate.swift
//  MyBarbell
//
//  Created by Jason Goodney on 5/22/20.
//  Copyright © 2020 Jason Goodney. All rights reserved.
//

import Foundation
import SwiftUI

class Plate: ObservableObject, Identifiable {
    let id = UUID()
    let type: PlateType
    let weight: Double
    let color: Color
    @Published var countOnBarbell: Int = 0
    
    init(type: PlateType = .standard, weight: Double = 0, countOnBarbell: Int = 0, color: Color = .primary) {
        self.type = type
        self.weight = weight
        self.countOnBarbell = countOnBarbell
        self.color = color
    }
    
    var totalWeight: Double { weight * Double(countOnBarbell) }
    
    static let `default` = Plate(type: .standard, weight: 45, countOnBarbell: 0)
}

extension Plate: Hashable {
    static func == (lhs: Plate, rhs: Plate) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
