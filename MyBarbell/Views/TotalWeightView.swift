//
//  TotalWeightView.swift
//  MyBarbell
//
//  Created by Jason Goodney on 5/27/20.
//  Copyright © 2020 Jason Goodney. All rights reserved.
//

import SwiftUI

struct TotalWeightView: View {
    @ObservedObject var store: BarbellStore
    
    var body: some View {
        HStack(alignment: .lastTextBaseline) {
            Text("\(store.totalWeight, specifier: "%g")")
                .font(.system(size: 90))
                .fontWeight(.bold)
                .lineLimit(1)
                .minimumScaleFactor(0.5)
            
            Text("\(store.unitOfMeasure.symbol)")
                .font(.largeTitle)
        }
        .padding([.horizontal])
    }
}

struct TotalWeightView_Previews: PreviewProvider {
    static var previews: some View {
        TotalWeightView(store: BarbellStore())
    }
}
