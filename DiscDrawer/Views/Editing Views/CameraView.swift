//
//  CameraView.swift
//  DiscDrawer
//
//  Created by Aguirre, Brian P. on 9/23/23.
//

// MARK: - Imported libraries

import SwiftUI

// MARK: - Main struct

// This struct provides a view that allows the user to take a picture
struct CameraView: UIViewControllerRepresentable {

    // MARK: - Properties

    // Hold the user selection
    @Binding var image: UIImage?

    // MARK: - Functions

    // Create the view controller
    func makeUIViewController(context: Context) -> UIImagePickerController {

        // Create a picker view controller with the configuration
        let cameraView = UIImagePickerController()

        // Configure the picker
        cameraView.sourceType = .camera
        cameraView.allowsEditing = true

        // Set the view controller's delegate to the coordinator
        cameraView.delegate = context.coordinator

        return cameraView
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) { }

    // Create the coordinator, configure it, and return it
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    // MARK: - Nested classes

    // This class provides a coordinator to handle delegate conformance
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

        // MARK: - Properties

        // Parent struct
        var parent: CameraView

        // MARK: - Initializers

        // Initialize with parent struct
        init(_ parent: CameraView) {
            self.parent = parent
        }

        // MARK: - Functions

        // Delegate function to read image picker data
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {

            // Dismiss the picker
            picker.dismiss(animated: true)

            // Fetch the image (if one was taken)
            guard let image = info[.editedImage] as? UIImage else {
                print("No image found")
                return
            }

            self.parent.image = image
        }
    }
}
