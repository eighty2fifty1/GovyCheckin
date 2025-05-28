//
//  ContentView.swift
//  GovyCheckin
//
//  Created by James Ford on 5/26/25.
//

import SwiftUI

import SwiftUI

struct OptionsView: View {
    @State private var plates: [String] = ["G00225X"]
    @State private var selectedPlate: String = ""
    @State private var newPlate: String = ""
    
    @State private var drivers: [String] = ["AWFC Ford, James"]
    @State private var selectedDriver: String = ""
    @State private var newDriver: String = ""
    
    let licenseKey = "SavedLicensePlates"
    let driverKey = "SavedDrivers"
    
    var body: some View {
        VStack(spacing: 20) {
            // Dropdown menu
            Spacer()
            Spacer()
            Picker("Select a license plate", selection: $selectedPlate) {
                ForEach(plates, id: \.self) { option in
                    Text(option)
                }
            }
            .pickerStyle(MenuPickerStyle())
            
            
            
            Picker("Select a driver", selection: $selectedDriver) {
                ForEach(drivers, id: \.self) { option in
                    Text(option)
                }
            }
            .pickerStyle(MenuPickerStyle())
            
            ScrollView(){
                VStack(){
                    List {
                        ForEach(plates, id: \.self) { option in
                            HStack {
                                Text(option)
                                Spacer()
                                Button(role: .destructive) {
                                    deletePlate(option)
                                } label: {
                                    Image(systemName: "trash")
                                }
                            }
                        }
                    }
                    // Add new option
                    HStack {
                        TextField("Add new option", text: $newPlate)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        
                        Button("Add") {
                            let trimmed = newPlate.trimmingCharacters(in: .whitespacesAndNewlines)
                            guard !trimmed.isEmpty, !plates.contains(trimmed) else { return }
                            plates.append(trimmed)
                            selectedPlate = trimmed
                            newPlate = ""
                            savePlates()
                        }
                        .disabled(newPlate.trimmingCharacters(in: .whitespaces).isEmpty)
                        
                    }
                    
                    List {
                        ForEach(drivers, id: \.self) { option in
                            HStack {
                                Text(option)
                                Spacer()
                                Button(role: .destructive) {
                                    deleteDriver(option)
                                } label: {
                                    Image(systemName: "trash")
                                }
                            }
                        }
                    }
                    // Add new option
                    HStack {
                        TextField("Add new option", text: $newDriver)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        
                        Button("Add") {
                            let trimmed = newDriver.trimmingCharacters(in: .whitespacesAndNewlines)
                            guard !trimmed.isEmpty, !plates.contains(trimmed) else { return }
                            drivers.append(trimmed)
                            selectedDriver = trimmed
                            newDriver = ""
                            saveDrivers()
                        }
                        .disabled(newDriver.trimmingCharacters(in: .whitespaces).isEmpty)
                        
                    }
                    
                    
                }
            }
        }
        .padding()
         .onAppear {
           loadDrivers()
             loadPlates()
        }
        
    }


    

    // MARK: - UserDefaults Persistence

    private func savePlates() {
        UserDefaults.standard.set(plates, forKey: licenseKey)
    }

    private func loadPlates() {
        if let saved = UserDefaults.standard.stringArray(forKey: licenseKey), !saved.isEmpty {
            plates = saved
            selectedPlate = saved.first!
        } else {
            plates = ["G00225X"]
            selectedPlate = plates[0]
            savePlates()
        }
    }
    
    private func deletePlate(_ option: String) {
        plates.removeAll { $0 == option }
        if selectedPlate == option {
            selectedPlate = plates.first ?? ""
        }
        savePlates()
    }
    
    private func moveSelectedPlateToTop() {
        guard let index = plates.firstIndex(of: selectedPlate) else { return }
        let selected = plates.remove(at: index)
        plates.insert(selected, at: 0)
        savePlates()
    }
    
    private func saveDrivers() {
        UserDefaults.standard.set(drivers, forKey: driverKey)
    }

    private func loadDrivers() {
        if let saved = UserDefaults.standard.stringArray(forKey: driverKey), !saved.isEmpty {
            drivers = saved
            selectedDriver = saved.first!
        } else {
            drivers = ["AWFC Ford, James"]
            selectedDriver = drivers[0]
            saveDrivers()
        }
    }
    
    private func deleteDriver(_ option: String) {
        drivers.removeAll { $0 == option }
        if selectedDriver == option {
            selectedDriver = drivers.first ?? ""
        }
        saveDrivers()
    }
    
    private func moveSelectedDriverToTop() {
        guard let index = drivers.firstIndex(of: selectedDriver) else { return }
        let selected = drivers.remove(at: index)
        drivers.insert(selected, at: 0)
        saveDrivers()
    }
}


#Preview {
    OptionsView()
}
