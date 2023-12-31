//
//  AddEditDiscView.swift
//  DiscDrawer
//
//  Created by Aguirre, Brian P. on 9/6/23.
//

// MARK: - Imported libraries

import SwiftUI
import UIKit

// MARK: - Main struct

// TODO: Add fields for flight path image and stability (computed?)

// This struct provides a view that allows for editing of a current disc or creation of a new one
struct AddEditDiscView: View {

    // MARK: - Properties

    // Environment

    // Managed object context
    @Environment(\.managedObjectContext) var moc
    @Environment(\.dismiss) var dismiss

    // FocusState

    @FocusState private var focusedField: FocusedFlightNumber?

    // Bindings

    // Optional bindings used to dismiss multiple sheets at once
    var showingAddView: Binding<Bool>?
    @Binding var discDetailToShow: Disc?

    // State

    @State private var name = ""
    @State private var type = "Putter"
    @State private var manufacturer = ""
    @State private var plastic = ""
    @State private var weight = ""
    @State private var speed = 0.0
    @State private var glide = 0.0
    @State private var turn = 0.0
    @State private var fade = 0.0
    @State private var condition = "Great"
    @State private var inBag = false
    @State private var image: Image?

    @State private var inputImage: UIImage?

    @State private var showingDeleteAlert = false
    @State private var showingImagePicker = false

    @State private var discWasDeleted = false

    // Basic

    var disc: Disc?

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

    // Enum to define which flight number field has focus
    enum FocusedFlightNumber {
        case speed, glide, turn, fade
    }

    // MARK: - Initializers

    // Init with optional disc
    init(disc: Disc? = nil, showingAddView: Binding<Bool>? = nil, discDetailToShow: Binding<Disc?> = .constant(nil)) {

        self.showingAddView = showingAddView ?? nil
        _discDetailToShow = discDetailToShow

        // Check if we were provided a disc
        guard let disc else { return }

        self.disc = disc

        // Initialize state values
        _name = State(initialValue: disc.wrappedName)
        _type = State(initialValue: disc.wrappedType)
        _manufacturer = State(initialValue: disc.wrappedManufacturer)
        _plastic = State(initialValue: disc.wrappedPlastic)
        _weight = State(initialValue: disc.weight != 0 ? String(Int(disc.weight)) : "")
        _speed = State(initialValue: Double(disc.speed))
        _glide = State(initialValue: Double(disc.glide))
        _turn = State(initialValue: Double(disc.turn))
        _fade = State(initialValue: Double(disc.fade))
        _condition = State(initialValue: disc.wrappedCondition)
        _inBag = State(initialValue: disc.inBag)

        if let imageData = disc.imageData,
           let discImage = UIImage(data: imageData) {
            _inputImage = State(initialValue: discImage)
            _image = State(initialValue: Image(uiImage: inputImage!))
        }
    }

    // Init with disc template
    init(discTemplate: DiscTemplate, showingAddView: Binding<Bool>? = nil) {

        self.showingAddView = showingAddView ?? nil
        _discDetailToShow = .constant(nil)

        disc = nil

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
            Section("Basic Information") {
                LabeledContent("Name") {
                    TextField("Name", text: $name)
                        .multilineTextAlignment(.trailing)
                }
                LabeledContent("Manufacturer") {
                    TextField("Manufacturer", text: $manufacturer)
                        .multilineTextAlignment(.trailing)
                }
                LabeledContent("Plastic") {
                    TextField("Plastic", text: $plastic)
                        .multilineTextAlignment(.trailing)
                }

                Picker("Type", selection: $type) {
                    ForEach(types, id: \.self) {
                        Text($0)
                    }
                }
                .pickerStyle(.segmented)

                LabeledContent("Weight (g)") {
                    TextField("Weight (g)", text: $weight)
                        .multilineTextAlignment(.trailing)
                        .keyboardType(.decimalPad)
                }
            }

            // Image
            Section("Image") {
                VStack {
                    if let image {
                        ZStack {
                            image
                                .resizable()
                                .scaledToFit()
                                .clipShape(Circle())

                            Circle()
                                .stroke(.white, lineWidth: 3)
                        }
                        .frame(width: 175)
                        .padding(.bottom, 20)
                    }

                    Button("Take Picture") {
                        showingImagePicker = true
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 10)
            }

            // Flight numbers
            Section {
                HStack {
                    VStack {
                        TextField("Speed", value: $speed, format: .number)
                            .focused($focusedField, equals: .speed)
                        Text("Speed")
                    }
                    VStack {
                        TextField("Glide", value: $glide, format: .number)
                            .focused($focusedField, equals: .glide)
                        Text("Glide")
                    }
                    VStack {
                        TextField("Turn", value: $turn, format: .number)
                            .focused($focusedField, equals: .turn)
                        Text("Turn")
                    }
                    VStack {
                        TextField("Fade", value: $fade, format: .number)
                            .focused($focusedField, equals: .fade)

                        Text("Fade")
                    }
                }
                .multilineTextAlignment(.center)
                .keyboardType(.decimalPad)
                .toolbar {
                    ToolbarItemGroup(placement: .keyboard) {
                        Spacer()

                        // Flip the polarity on the field that has focus
                        Button("+/-") {
                            updateFlightNumberPolarity()
                        }
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
                        .confirmationDialog("Are you sure?", isPresented: $showingDeleteAlert) {
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
        .toolbar {
            Button {
                saveDisc()
                dismissFromContext()
            } label: {
                Text("Save")
                    .bold()
            }
            .disabled(!dataIsValid)
        }
        .fullScreenCover(isPresented: $showingImagePicker) {

            // Present a full screen camera view
            CameraView(image: $inputImage)
                .edgesIgnoringSafeArea(.all)

                // When a picture is taken, load the image here
                .onChange(of: inputImage, initial: false) {
                    guard let inputImage = inputImage else { return }
                    image = Image(uiImage: inputImage)
                }
        }
    }

    // MARK: - Functions

    // Flip the polarity on the field that has focus
    func updateFlightNumberPolarity() {
        switch focusedField {
        case .speed:
            speed = -speed
        case .glide:
            glide = -glide
        case .turn:
            turn = -turn
        case .fade:
            fade = -fade
        case .none:
            break
        }
    }

    // Delete the current disc
    func deleteDisc() {
        discWasDeleted = true
        moc.delete(disc!)
        try? moc.save() // TODO: Catch errors
        dismissFromContext()
    }

    // Save the disc information
    func saveDisc() {

        // If we're editing an existing disc, update it
        if let disc {

            disc.name = name
            disc.type = type
            disc.manufacturer = manufacturer
            disc.plastic = plastic
            disc.weight = Int16(weight) ?? 0
            disc.speed = Double(speed)
            disc.glide = Double(glide)
            disc.turn = Double(turn)
            disc.fade = Double(fade)
            disc.condition = condition
            disc.inBag = inBag
            disc.imageData = downsampledImageData(inputImage)
            
        } else {

            // Create new Disc and assign values
            let newDisc = Disc(context: moc)
            newDisc.name = name
            newDisc.type = type
            newDisc.manufacturer = manufacturer
            newDisc.plastic = plastic
            newDisc.weight = Int16(weight) ?? 0
            newDisc.speed = Double(speed)
            newDisc.glide = Double(glide)
            newDisc.turn = Double(turn)
            newDisc.fade = Double(fade)
            newDisc.condition = condition
            newDisc.inBag = inBag
            newDisc.imageData = downsampledImageData(inputImage)
        }

        // Save disc to managed object context
        try? moc.save() // TODO: Catch errors
    }
    
    // Return an image that has been downsampled to reduce file size
    func downsampledImageData(_ image: UIImage?) -> Data? {
        
        // Make sure we have an image
        guard let image else { return nil }
        
        // Specify the new image size in points
        let size = CGSize(width: 150, height: 150)
        
        // Create the image renderer
        let renderer = UIGraphicsImageRenderer(size: size)
        
        // Redraw the image
        let resizedImage = renderer.image { _ in
            image.draw(in: CGRect(origin: .zero, size: size))
        }
        
        return resizedImage.jpegData(compressionQuality: 0.8)
    }

    // Dismiss the view and optionally dismiss additional parent views using a binding
    func dismissFromContext() {

        // Saving a new disc - return to disc list
        if showingAddView != nil {
            showingAddView!.wrappedValue = false

            // Deleting an existing disc - return to disc list
        } else if discDetailToShow != nil && discWasDeleted {
            discDetailToShow = nil

            // Saving an existing disc - return to disc detail view
        } else {
            dismiss()
        }
    }
}
