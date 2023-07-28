//
//  BarbellType.swift
//  MyBarbell
//
//  Created by Jason Goodney on 5/22/20.
//  Copyright © 2020 Jason Goodney. All rights reserved.
//

import Foundation

enum BarbellType: Int, CaseIterable, Hashable, Codable {
    case barbell
    case bellaBar
    case junior
    case technique
}

extension BarbellType: CustomStringConvertible {
    var description: String {
        switch self {
        case .barbell:
            return "Barbell"
        case .bellaBar:
            return "Bella Bar"
        case .junior:
            return "Junior"
        case .technique:
            return "Technique"
        }
    }
}
