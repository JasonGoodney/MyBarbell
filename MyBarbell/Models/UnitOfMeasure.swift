//
//  UnitOfMeasure.swift
//  MyBarbell
//
//  Created by Jason Goodney on 5/22/20.
//  Copyright © 2020 Jason Goodney. All rights reserved.
//

import Foundation

enum UnitOfMeasure: Int, CaseIterable, Codable {
    case pound
    case kilogram
    
    var symbol: String {
        switch self {
        case .pound:
            return "LB"
        case .kilogram:
            return "KG"
        }
    }
}

extension UnitOfMeasure: CustomStringConvertible {
    var description: String {
        switch self {
        case .pound:
            return "Pounds (\(self.symbol))"
        case .kilogram:
            return "Kilograms (\(self.symbol))"
        }
    }
}
