//
//  ContentView.swift
//  MyBarbell
//
//  Created by Jason Goodney on 7/27/23.
//

import SwiftUI
import Combine

struct ContentView: View {
    @ObservedObject var store = BarbellStore()
    
    var body: some View {
        NavigationView {
            VStack(spacing: 10) {

                TotalWeightView(store: store)
                
                if store.unitOfMeasure == .pound {
                    PlateList(plateSet: store.poundPlateSet, onEditingChanged: { _ in
                        self.store.calculateTotalWeight()
                    })

                } else if store.unitOfMeasure == .kilogram {
                    PlateList(plateSet: store.kilogramPlateSet, onEditingChanged: { _ in
                        self.store.calculateTotalWeight()
                    })
                }

            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                
                ToolbarItem(placement: .principal) {
                    Text("My Barbell")
                        .font(.headline)
                }
                
                ToolbarItem(placement: .navigationBarLeading) {
                    Menu {
                        Section {
                            Picker(selection: $store.unitOfMeasure.animation()) {
                                Text("Pounds (LB)").tag(UnitOfMeasure.pound)
                                Text("Kilograms (KG)").tag(UnitOfMeasure.kilogram)
                            } label: {
                                Text("Unit")
                            }
                        }
                        
                        Section {
                            Picker(selection: $store.barbellType.animation()) {
                                Text(BarbellType.barbell.description).tag(BarbellType.barbell)
                                Text(BarbellType.bellaBar.description).tag(BarbellType.bellaBar)
                                Text(BarbellType.junior.description).tag(BarbellType.junior)
                                Text(BarbellType.technique.description).tag(BarbellType.technique)
                            } label: {
                                Text("Barbell")
                            }
                        }
                        
                        Section {
                            Button(role: .destructive) {
                                store.clearPlates()
                            } label: {
                                Label("Clear Plates", systemImage: "trash")
                            }
                            .disabled(store.barbellIsEmpty)

                        }
                    } label: {
                        Image(systemName: "ellipsis.circle")
                    }
                }
            }
            .onAppear {
                self.store.calculateTotalWeight()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static let supportedLocales: [Locale] = [
      "en-US", // English (United States)
      "ar-QA", // Arabic (Qatar)
      "he-IL", // Hebrew (Israel)
      "ur-IN"  // Urdu (India)
    ].map(Locale.init(identifier:))
    
    static let deviceNames: [String] = [
        "iPhone SE",
        "iPhone 11 Pro Max",
        "iPad Pro (11-inch)",
        "iPad Pro"
    ]
    
    static var previews: some View {
        ContentView()
//        ForEach(ContentSizeCategory.allCases, id: \.self) { sizeCategory in
//            ContentView()
//                .environment(\.sizeCategory, sizeCategory)
//                .previewDisplayName("\(sizeCategory)")
//        }
        
//        ForEach(supportedLocales, id: \.identifier) { locale in
//            ContentView()
//                .environment(\.locale, locale)
//                .previewDisplayName(Locale.current.localizedString(forIdentifier: locale.identifier))
//        }
        
//        ForEach(deviceNames, id: \.self) { deviceName in
//          ContentView()
//            .previewDevice(PreviewDevice(rawValue: deviceName))
//            .previewDisplayName(deviceName)
//        }

        
    }
}

