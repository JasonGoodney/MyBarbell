//
//  PlateType.swift
//  MyBarbell
//
//  Created by Jason Goodney on 6/2/20.
//  Copyright © 2020 Jason Goodney. All rights reserved.
//

import Foundation

enum PlateType: Int, CaseIterable {
    case standard = 0
    case change
    case fractional
    case heavy
}

extension PlateType: CustomStringConvertible {
    var description: String {
        switch self {
        case .standard:
            return "Standard Plates"
        case .change:
            return "Change Plates"
        case .fractional:
            return "Fractional Plates"
        case .heavy:
            return "Heavy Plates"
        }
    }
}

