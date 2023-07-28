//
//  PlateList.swift
//  MyBarbell
//
//  Created by Jason Goodney on 5/22/20.
//  Copyright © 2020 Jason Goodney. All rights reserved.
//

import SwiftUI

struct PlateList: View {
        
    var plateSet: [PlateType: [Plate]]
    
    var onEditingChanged: (Bool) -> Void
    
    init(plateSet: [PlateType: [Plate]], onEditingChanged: @escaping (Bool) -> Void = { _ in }) {
        self.plateSet = plateSet
        self.onEditingChanged = onEditingChanged
    }
    
    var body: some View {
        List {
            ForEach(PlateType.allCases) { type in
                
                Section(header:
                    Text(type.description)
                        .font(.headline)
                ) {
                    ForEach(plateSet[type]!) { plate in
                        PlateRow(
                            plate: plate,
                            onEditingChanged: self.onEditingChanged
                        )
                    }
                }
            }
        }
        .listSeparatorStyle(style: .none)
        .listStyle(GroupedListStyle())
    }
}

struct PlateList_Previews: PreviewProvider {
    
    static var previews: some View {
        PlateList(plateSet: BarbellStore().poundPlateSet)
    }
}

