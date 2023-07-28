//
//  BarbellPicker.swift
//  MyBarbell
//
//  Created by Jason Goodney on 6/2/20.
//  Copyright © 2020 Jason Goodney. All rights reserved.
//

import SwiftUI


struct BarbellPicker: View {
    @ObservedObject var store: BarbellStore
    
    var body: some View {
        Picker("Barbell Type", selection: $store.barbellType) {
            ForEach(BarbellType.allCases, id: \.self) {
                Text($0.description)
            }
        }
        .pickerStyle(SegmentedPickerStyle())
        .labelsHidden()
        .padding(.horizontal)
    }
}

struct BarbellPicker_Previews: PreviewProvider {
    static var previews: some View {
        BarbellPicker(store: BarbellStore())
    }
}
