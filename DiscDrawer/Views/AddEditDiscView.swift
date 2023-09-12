//
//  AddEditDiscView.swift
//  DiscDrawer
//
//  Created by Aguirre, Brian P. on 9/6/23.
//

// MARK: - Imported libraries

import SwiftUI

// MARK: - Main struct

// This struct provides a view that allows for editing of a current disc or creation of a new one
struct AddEditDiscView: View {
    
    // MARK: - Properties
    
    // Environment
    
    // Managed object context
    @Environment(\.managedObjectContext) var moc
    @Environment(\.dismiss) var dismiss
    
    // State
    
    @State private var name = ""
    @State private var type = "Putter"
    @State private var manufacturer = ""
    @State private var plastic = ""
    @State private var weight = 0
    @State private var speed = 0
    @State private var glide = 0
    @State private var turn = 0
    @State private var fade = 0
    @State private var condition = "Great"
    @State private var inBag = false
    
    @State private var showingDeleteAlert = false
    
    // Basic
    
    var disc: Disc? = nil
    
    let types = ["Putter", "Midrange", "Fairway", "Driver"]
    let conditions = ["Great", "Good", "Fair", "Bad"]
    
    // Property to contain data validation
    var dataIsValid: Bool {
        name != ""
    }
    
    // Contextual navigation title
    var navigationTitle: String {
        if disc != nil {
            return name
        } else {
            return "Add Disc"
        }
    }
    
    // MARK: - Initializers
    
    init(disc: Disc? = nil) {
        
        // Check if we were provided a disc
        guard let disc else { return }
        
        // Initialize state values
        _name = State(initialValue: disc.name ?? "")
        _type = State(initialValue: disc.type ?? "Putter")
        _manufacturer = State(initialValue: disc.manufacturer ?? "")
        _plastic = State(initialValue: disc.plastic ?? "")
        _weight = State(initialValue: Int(disc.weight))
        _speed = State(initialValue: Int(disc.speed))
        _glide = State(initialValue: Int(disc.glide))
        _turn = State(initialValue: Int(disc.turn))
        _fade = State(initialValue: Int(disc.fade))
        _condition = State(initialValue: disc.condition ?? "Great")
        _inBag = State(initialValue: disc.inBag)
        
        self.disc = disc
    }
    
    // MARK: - Body view
    
    var body: some View {
        
        // Main form
        Form {
            
            // Basic info
            Section {
                TextField("Name", text: $name)
                TextField("Manufacturer", text: $manufacturer)
                TextField("Plastic", text: $plastic)
                
                Picker("Type", selection: $type) {
                    ForEach(types, id: \.self) {
                        Text($0)
                    }
                }
                .pickerStyle(.segmented)
                
                HStack {
                    Text("Weight (g)")
                    TextField("Weight (g)", value: $weight, format: .number)
                        .multilineTextAlignment(.trailing)
                }
            }
            
            // Flight numbers
            Section {
                HStack {
                    VStack {
                        TextField("Speed", value: $speed, format: .number)
                            .multilineTextAlignment(.center)
                        Text("Speed")
                    }
                    VStack {
                        TextField("Glide", value: $glide, format: .number)
                            .multilineTextAlignment(.center)
                        Text("Glide")
                    }
                    VStack {
                        TextField("Turn", value: $turn, format: .number)
                            .multilineTextAlignment(.center)
                        Text("Turn")
                    }
                    VStack {
                        TextField("Fade", value: $fade, format: .number)
                            .multilineTextAlignment(.center)
                        Text("Fade")
                    }
                }
            } header: {
                Text("Flight numbers")
            }
            
            // Condition
            Section {
                Picker("Condition", selection: $condition) {
                    ForEach(conditions, id: \.self) {
                        Text($0)
                    }
                }
                .pickerStyle(.segmented)
            } header: {
                Text("Condition")
            }
            
            // In bag
            Section {
                HStack {
                    Toggle("In bag", isOn: $inBag)
                }
            }
            
            // Delete disc button (if we're editing an existing disc)
            if disc != nil {
                Section {
                    HStack {
                        Spacer()
                        
                        // Display a confirmation alert
                        Button("Delete Disc", role: .destructive) {
                            showingDeleteAlert = true
                        }
                        .alert("Are you sure?", isPresented: $showingDeleteAlert) {
                            Button("Delete", role: .destructive, action: deleteDisc)
                            Button("Cancel", role: .cancel) { }
                        } message: {
                            Text("All data for this disc will be permanently deleted.")
                        }
                        
                        Spacer()
                    }
                }
            }
        }
        .navigationTitle(navigationTitle)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button("Cancel") {
                    dismiss()
                }
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    saveDisc()
                    dismiss()
                } label: {
                    Text("Save")
                        .bold()
                }
                .disabled(!dataIsValid)
            }
        }
    }
    
    // MARK: - Functions
    
    // Delete the current disc
    func deleteDisc() {
        moc.delete(disc!)
        try? moc.save() // TODO: Catch errors
        dismiss()
    }
    
    // Save the disc information
    func saveDisc() {
        
        // If we're editing an existing disc, delete it and replace it below
        if disc != nil {
            moc.delete(disc!)
        }
        
        // Create new Disc and assign values
        let newDisc = Disc(context: moc)
        newDisc.name = name
        newDisc.type = type
        newDisc.manufacturer = manufacturer
        newDisc.plastic = plastic
        newDisc.weight = Int16(weight)
        newDisc.speed = Int16(speed)
        newDisc.glide = Int16(glide)
        newDisc.turn = Int16(turn)
        newDisc.fade = Int16(fade)
        newDisc.condition = condition
        newDisc.inBag = inBag
        
        // Save disc to managed object context
        try? moc.save() // TODO: Catch errors
    }
}

//struct AddEditDiscView_Previews: PreviewProvider {
//    static var previews: some View {
//        AddEditDiscView(disc: nil)
//    }
//}
