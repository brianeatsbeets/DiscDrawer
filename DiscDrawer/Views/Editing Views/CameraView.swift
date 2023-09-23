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
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            
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

// This extension of UIImagePickerController fixes a bug that does not allow panning while editing a taken photo
// Credit to Sergio via https://stackoverflow.com/a/72559127/4991062
extension UIImagePickerController {
    open override var childForStatusBarHidden: UIViewController? {
        return nil
    }

    open override var prefersStatusBarHidden: Bool {
        return true
    }
    
    open override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        fixCannotMoveEditingBox()
    }
    
    private func fixCannotMoveEditingBox() {
        if let cropView = cropView, let scrollView = scrollView, scrollView.contentOffset.y == 0 {
            let top: CGFloat = cropView.frame.minY + self.view.frame.minY
            let bottom = scrollView.frame.height - cropView.frame.height - top
            scrollView.contentInset = UIEdgeInsets(top: top, left: 0, bottom: bottom, right: 0)
            
            var offset: CGFloat = 0
            if scrollView.contentSize.height > scrollView.contentSize.width {
                offset = 0.5 * (scrollView.contentSize.height - scrollView.contentSize.width)
            }
            scrollView.contentOffset = CGPoint(x: 0, y: -top + offset)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
            self?.fixCannotMoveEditingBox()
        }
    }
    
    private var cropView: UIView? {
        return findCropView(from: self.view)
    }
    
    private var scrollView: UIScrollView? {
        return findScrollView(from: self.view)
    }
    
    private func findCropView(from view: UIView) -> UIView? {
        let width = UIScreen.main.bounds.width
        let size = view.bounds.size
        if width == size.height, width == size.height {
            return view
        }
        for view in view.subviews {
            if let cropView = findCropView(from: view) {
                return cropView
            }
        }
        return nil
    }
    
    private func findScrollView(from view: UIView) -> UIScrollView? {
        if let scrollView = view as? UIScrollView {
            return scrollView
        }
        for view in view.subviews {
            if let scrollView = findScrollView(from: view) {
                return scrollView
            }
        }
        return nil
    }
}
