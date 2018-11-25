//
//  Plate.swift
//  MyBarbell
//
//  Created by Jason Goodney on 10/5/18.
//  Copyright © 2018 Jason Goodney. All rights reserved.
//

import Foundation

class Plate {
    let weight: Double
    var count: Int
    
    init(weight: Double, count: Int = 0) {
        self.weight = weight
        self.count = count
    }
}
