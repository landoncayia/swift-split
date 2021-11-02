//
//  CameraViewController.swift
//  SwiftSplit
//
//  Created by user204492 on 10/15/21.
//

import UIKit

class CameraViewController : UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet var photo: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    // Whenever the create tab is pressed on the tab view the choose source menu will appear
    override func viewDidAppear(_ animated: Bool) {
        choosePhotoSource()
    }
    
    // Creates a UIImagePickerController object which is used for the selection
    func imagePicker(for sourceType: UIImagePickerController.SourceType)
    -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = sourceType
        return picker
    }
    
    // Gets the image and places it on the screen
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        // get picked image from info dictionary
        let image = info[.originalImage] as! UIImage
        // put that image on the screen in the image view
        photo.image = image
        // take image picker off the screen -- must call this dismiss method
        dismiss(animated: true, completion: nil)
    }
    
    // TODO: Add Segues to other views
    // Chooses a photo source
    func choosePhotoSource() {
        let alertController = UIAlertController(title: nil,
                                                message: nil,
                                                preferredStyle: .actionSheet)
        alertController.modalPresentationStyle = .popover
        //alertController.popoverPresentationController?.barButtonItem = sender
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let cameraAction = UIAlertAction(title: "Camera", style: .default) { _ in
                print("Present camera")
                let imagePicker = self.imagePicker(for: .camera)
                self.present(imagePicker, animated: true, completion: nil)
            }
            alertController.addAction(cameraAction)
        }
        
        let photoLibraryAction = UIAlertAction(title: "Photo Library", style: .default) { _ in
            print("Present photo library")
            let imagePicker = self.imagePicker(for: .photoLibrary)
            self.present(imagePicker, animated: true, completion: nil)
        }
        alertController.addAction(photoLibraryAction)
        
        let manualAction = UIAlertAction(title: "Manual Entry", style: .default) { _ in
            print("Present manual entry")
            
            // TODO: redo using segues
            // Transitions to the view for manual entry
            let story = UIStoryboard(name: "Camera", bundle: nil)
            let controller = story.instantiateViewController(withIdentifier:"ManualEntryController")
            let navigation = UINavigationController(rootViewController: controller)
            self.view.addSubview(navigation.view)
            self.addChild(navigation)
            navigation.didMove(toParent: self)
        }
        alertController.addAction(manualAction)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }
}
