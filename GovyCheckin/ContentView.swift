//
//  ContentView.swift
//  GovyCheckin
//
//  Created by James Ford on 5/27/25.
//

import SwiftUI

struct ContentView: View {
    @State var showingOptions = true
    @State var showingWebView = false
    @State var driver: String = ""
    @State var plate: String = ""
    @State var shouldReload = false
    
    var body: some View {
        VStack{
            WebView(tagNumber: plate, driverName: driver, shouldReload: $shouldReload)
            
            Text("You selected \(driver) and \(plate)")
            
            
            .sheet(isPresented: $showingOptions){
                OptionsView(onSelectPlate: {value in
                    plate = value}, onSelectDriver: {value in driver = value}, onReload: {value in shouldReload = value})
                .presentationDetents([.fraction(0.25), .large])
                .presentationDragIndicator(.visible)
                .interactiveDismissDisabled(true)
                
            }
        }
    }
}

#Preview {
    ContentView(driver: "d", plate: "a")
}
