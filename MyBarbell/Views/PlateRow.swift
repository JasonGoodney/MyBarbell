//
//  PlateRow.swift
//  MyBarbell
//
//  Created by Jason Goodney on 5/22/20.
//  Copyright © 2020 Jason Goodney. All rights reserved.
//

import SwiftUI

struct PlateRow: View {
    @ObservedObject var plate: Plate
    
    var onEditingChanged: (Bool) -> Void
    
    init(plate: Plate, onEditingChanged: @escaping (Bool) -> Void = { _ in }) {
        self.plate = plate
        self.onEditingChanged = onEditingChanged
    }
    
    var body: some View {
        Stepper(value: $plate.countOnBarbell, in: 0...100, onEditingChanged: { changed in
            self.onEditingChanged(changed)
        }) {
            HStack(alignment: .lastTextBaseline) {
                Text("\(plate.weight, specifier: "%g")")
                    .font(.title)
                    .bold()
                    .foregroundColor(plate.color)
                
                Spacer()
                
                Text("\(plate.countOnBarbell)")
                    .font(.largeTitle)
                    .bold()
            }
        }
        .swipeActions(edge: .trailing) {
            Button(role: .destructive) {
                plate.countOnBarbell = 0
                onEditingChanged(true)
            } label: {
                Label("Clear", systemImage: "trash")
            }
        }
    }
}

struct PlateRow_Previews: PreviewProvider {
    
    static var previews: some View {
        ForEach(ContentSizeCategory.allCases, id: \.self) { sizeCategory in
            PlateRow(plate: Plate.default)
                .environment(\.sizeCategory, sizeCategory)
                .previewDisplayName("\(sizeCategory)")
        }
        .previewLayout(.sizeThatFits)
    }
}
