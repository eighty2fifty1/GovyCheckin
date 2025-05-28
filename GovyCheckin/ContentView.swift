//
//  ContentView.swift
//  GovyCheckin
//
//  Created by James Ford on 5/27/25.
//

import SwiftUI

struct ContentView: View {
    @State private var showingOptions = true

    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
        
            .sheet(isPresented: $showingOptions){
                OptionsView()
                    .presentationDetents([.fraction(0.15), .large])
                    .presentationDragIndicator(.visible)
                    .interactiveDismissDisabled(true)

            }
    }
}

#Preview {
    ContentView()
}
