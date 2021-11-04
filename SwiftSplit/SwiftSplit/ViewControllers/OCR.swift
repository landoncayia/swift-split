//
//  CameraViewController.swift
//  SwiftSplit
//
//  Created by user204492 on 10/15/21.
//

import UIKit
import Vision
import UniformTypeIdentifiers
import VisionKit

class OCR {
//    // Loading circle, which is not yet in our storyboard
//    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
//
//    var resultsViewController: (UIViewController & RecognizedTextDataSource)?
//    var textRecognitionRequest = VNRecognizeTextRequest()
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        textRecognitionRequest = VNRecognizeTextRequest(completionHandler: { (request, error) in
//            guard let resultsViewController = self.resultsViewController else {
//                print("resultsViewController is not set")
//                return
//            }
//            if let results = request.results, !results.isEmpty {
//                if let requestResults = request.results as? [VNRecognizedTextObservation] {
//                    DispatchQueue.main.async {
//                        resultsViewController.processRecognizedText(recognizedText: requestResults)
//                    }
//                }
//            }
//        })
//        // This doesn't require OCR on a live camera feed, select accurate for more accurate results.
//        textRecognitionRequest.recognitionLevel = .accurate
//        textRecognitionRequest.usesLanguageCorrection = true
//    }
//
//        // MARK: scan function
//    // Used to scan receipts with the device camera ( I think? :/ )
//    @IBAction func scan(_ sender: UIControl) {
//        let documentCameraViewController = VNDocumentCameraViewController()
//        documentCameraViewController.delegate = self
//        present(documentCameraViewController, animated: true)
//    }
//
//        // MARK: processImage function
//    // Takes a UIImage as input and converts it to a cgimage (compatible with VNRecognizeTextRequest)
//    func processImage(image: UIImage) {
//        guard let cgImage = image.cgImage else {
//            print("Failed to get cgImage from input image")
//            return
//        }
//
//        let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
//        do {
//            try handler.perform([textRecognitionRequest])
//        } catch {
//            print(error)
//        }
//    }
}

    // MARK: extension CameraViewController
//extension CreateViewController: VNDocumentCameraViewControllerDelegate {
//    func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFinishWith scan: VNDocumentCameraScan) {
//        resultsViewController = storyboard?.instantiateViewController(withIdentifier: "receiptContentsVC") as? (UIViewController & RecognizedTextDataSource)
//        self.activityIndicator.startAnimating()
//        controller.dismiss(animated: true) {
//            DispatchQueue.global(qos: .userInitiated).async {
//                for pageNumber in 0 ..< scan.pageCount {
//                    let image = scan.imageOfPage(at: pageNumber)
//                    self.processImage(image: image)
//                }
//                DispatchQueue.main.async {
//                    if let resultsVC = self.resultsViewController {
//                        self.navigationController?.pushViewController(resultsVC, animated: true)
//                    }
//                    self.activityIndicator.stopAnimating()
//                }
//            }
//        }
//    }
//}
