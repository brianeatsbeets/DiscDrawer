//
//  AddEditDiscView.swift
//  DiscDrawer
//
//  Created by Aguirre, Brian P. on 9/6/23.
//

// MARK: - Imported libraries

import SwiftUI

// MARK: - Main struct

// TODO: Add fields for flight path image and stability (computed?)
// TODO: Change 'Cancel' button to negular back button when loading from disc template

// This struct provides a view that allows for editing of a current disc or creation of a new one
struct AddEditDiscView: View {
    
    // MARK: - Properties
    
    // Environment
    
    // Managed object context
    @Environment(\.managedObjectContext) var moc
    @Environment(\.dismiss) var dismiss
    
    // Bindings
    
    // Optional property used to dismiss multiple sheets at once
    var showingAddView: Binding<Bool>?
    
    // State
    
    @State private var name = ""
    @State private var type = "Putter"
    @State private var manufacturer = ""
    @State private var plastic = ""
    @State private var weight = 0
    @State private var speed = 0.0
    @State private var glide = 0.0
    @State private var turn = 0.0
    @State private var fade = 0.0
    @State private var condition = "Great"
    @State private var inBag = false
    
    @State private var showingDeleteAlert = false
    
    // Basic
    
    var disc: Disc? = nil
    var discTemplate: DiscTemplate? = nil
    
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
    
    // Init with optional disc
    init(disc: Disc? = nil, showingAddView: Binding<Bool>? = nil) {
        
        self.showingAddView = showingAddView ?? nil
        
        // Check if we were provided a disc
        guard let disc else { return }
        
        // Initialize state values
        _name = State(initialValue: disc.name ?? "")
        _type = State(initialValue: disc.wrappedType)
        _manufacturer = State(initialValue: disc.manufacturer ?? "")
        _plastic = State(initialValue: disc.plastic ?? "")
        _weight = State(initialValue: Int(disc.weight))
        _speed = State(initialValue: Double(disc.speed))
        _glide = State(initialValue: Double(disc.glide))
        _turn = State(initialValue: Double(disc.turn))
        _fade = State(initialValue: Double(disc.fade))
        _condition = State(initialValue: disc.wrappedCondition)
        _inBag = State(initialValue: disc.inBag)
        
        self.disc = disc
    }
    
    // Init with disc template
    init(discTemplate: DiscTemplate, showingAddView: Binding<Bool>? = nil) {
        
        self.showingAddView = showingAddView ?? nil
        
        // Initialize state values
        _name = State(initialValue: discTemplate.name ?? "")
        _type = State(initialValue: discTemplate.wrappedType)
        _manufacturer = State(initialValue: discTemplate.manufacturer ?? "")
        _speed = State(initialValue: Double(discTemplate.speed ?? "") ?? 0)
        _glide = State(initialValue: Double(discTemplate.glide ?? "") ?? 0)
        _turn = State(initialValue: Double(discTemplate.turn ?? "") ?? 0)
        _fade = State(initialValue: Double(discTemplate.fade ?? "") ?? 0)
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
                    dismissFromContext()
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
        dismissFromContext()
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
        newDisc.speed = Double(speed)
        newDisc.glide = Double(glide)
        newDisc.turn = Double(turn)
        newDisc.fade = Double(fade)
        newDisc.condition = condition
        newDisc.inBag = inBag
        
        // Save disc to managed object context
        try? moc.save() // TODO: Catch errors
    }
    
    // Dismiss the view and optionally dismiss additional parent views using a binding
    func dismissFromContext() {
        if showingAddView != nil {
            showingAddView!.wrappedValue = false
        } else {
            dismiss()
        }
    }
}

//struct AddEditDiscView_Previews: PreviewProvider {
//    static var previews: some View {
//        AddEditDiscView(disc: nil)
//    }
//}
