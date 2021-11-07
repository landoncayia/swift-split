// 

import UIKit
import VisionKit
import Vision

class CreateViewController : UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    static let receiptContentsVC = "receiptContentsVC"
    
    enum EntryMode: Int {
        case camera
        case gallery
        case manual
    }

    var entryMode: EntryMode = .camera
    var resultsViewController: (UIViewController & RecognizedTextDataSource)?
    var textRecognitionRequest = VNRecognizeTextRequest()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textRecognitionRequest = VNRecognizeTextRequest(completionHandler: { (request, error) in
            guard let resultsViewController = self.resultsViewController else {
                print("resultsViewController is not set")
                return
            }
            if let results = request.results, !results.isEmpty {
                if let requestResults = request.results as? [VNRecognizedTextObservation] {
                    DispatchQueue.main.async {
                        resultsViewController.processRecognizedText(recognizedText: requestResults)
                    }
                }
            }
        })
        // This doesn't require OCR on a live camera feed, select accurate for more accurate results.
        textRecognitionRequest.recognitionLevel = .accurate
        textRecognitionRequest.usesLanguageCorrection = true
    }
    
    // Whenever the create tab is pressed on the tab view the choose source menu will appear
//    override func viewDidAppear(_ animated: Bool) {
//        choosePhotoSource()
//    }
    
    @IBAction func CameraBtnAction(_ sender: UIButton) {
        self.entryMode = .camera
        let documentCameraViewController = VNDocumentCameraViewController()
        documentCameraViewController.delegate = self
        present(documentCameraViewController, animated: true)
    }

    // TODO: Write me!
    @IBAction func galleryButton(_ sender: UIButton) {
        self.entryMode = .gallery
    }
    
    // TODO: Write me!
    @IBAction func manualButton(_ sender: UIButton) {
        self.entryMode = .manual
    }
    
    func processImage(image: UIImage) {
        guard let cgImage = image.cgImage else {
            print("Failed to get cgimage from input image")
            return
        }
        
        let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        do {
            try handler.perform([textRecognitionRequest])
        } catch {
            print(error)
        }
    
    }
}
    
//    // Creates a UIImagePickerController object which is used for the selection
//    func imagePicker(for sourceType: UIImagePickerController.SourceType)
//    -> UIImagePickerController {
//        let picker = UIImagePickerController()
//        picker.delegate = self
//        picker.sourceType = sourceType
//        return picker
//    }
//
//    // Gets the image and places it on the screen
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
//        // get picked image from info dictionary
//        let image = info[.originalImage] as! UIImage
//        // put that image on the screen in the image view
//        photo.image = image
//        // take image picker off the screen -- must call this dismiss method
//        dismiss(animated: true, completion: nil)
//    }
    
//    // TODO: Add Segues to other views
//    // Chooses a photo source
//    func choosePhotoSource() {
//        let alertController = UIAlertController(title: nil,
//                                                message: nil,
//                                                preferredStyle: .actionSheet)
//        alertController.modalPresentationStyle = .popover
//        // alertController.popoverPresentationController?.barButtonItem = sender
//
//        alertController.popoverPresentationController!.sourceView = self.view;
//
//        if UIImagePickerController.isSourceTypeAvailable(.camera) {
//            let cameraAction = UIAlertAction(title: "Camera", style: .default) { _ in
//                print("Present camera")
//
//
//
//
//
//                // let imagePicker = self.imagePicker(for: .camera)
//                //self.present(imagePicker, animated: true, completion: nil)
//            }
//            alertController.addAction(cameraAction)
//        }
        
//        let photoLibraryAction = UIAlertAction(title: "Photo Library", style: .default) { _ in
//            print("Present photo library")
//            let imagePicker = self.imagePicker(for: .photoLibrary)
//            self.present(imagePicker, animated: true, completion: nil)
//        }
//        alertController.addAction(photoLibraryAction)
//
//        let manualAction = UIAlertAction(title: "Manual Entry", style: .default) { _ in
//            print("Present manual entry")
//
//            // TODO: redo using segues
//            // Transitions to the view for manual entry
//            let story = UIStoryboard(name: "Camera", bundle: nil)
//            let controller = story.instantiateViewController(withIdentifier:"ManualEntryController")
//            let navigation = UINavigationController(rootViewController: controller)
//            self.view.addSubview(navigation.view)
//            self.addChild(navigation)
//            navigation.didMove(toParent: self)
//        }
//        alertController.addAction(manualAction)
        
//        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
//        alertController.addAction(cancelAction)
//        present(alertController, animated: true, completion: nil)
//    }
//}

extension CreateViewController: VNDocumentCameraViewControllerDelegate {
    func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFinishWith scan: VNDocumentCameraScan) {
        
        let vcID = CreateViewController.receiptContentsVC

        resultsViewController = storyboard?.instantiateViewController(withIdentifier: vcID) as? (UIViewController & RecognizedTextDataSource)
        
        //self.activityIndicator.startAnimating()
        controller.dismiss(animated: true) {
            DispatchQueue.global(qos: .userInitiated).async {
                for pageNumber in 0 ..< scan.pageCount {
                    let image = scan.imageOfPage(at: pageNumber)
                    self.processImage(image: image)
                }
                DispatchQueue.main.async {
                    if let resultsVC = self.resultsViewController {
                        self.navigationController?.pushViewController(resultsVC, animated: true)
                    }
                    //self.activityIndicator.stopAnimating()
                }
            }
        }
    }
}
