//

import UIKit
import VisionKit
import Vision

class CreateViewController : UIViewController, UITableViewDataSource, UITableViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    var receipt: Receipt!
    var persons = [Person]()
    
    @IBOutlet var receiptName: UITextField!
    @IBOutlet var datePicker: UIDatePicker!
    @IBOutlet var userTableView: UITableView! {
        didSet {
            userTableView.delegate = self
            userTableView.dataSource = self
            userTableView.rowHeight = UITableView.automaticDimension
        }
    }
    
    // --- USERS TABLE ---
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.persons.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Assign cell to model
        let cell = userTableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath) as! UserCell
        let person = persons[indexPath.row]
        cell.userName.text = person.name
        
//        cell.userName.addTarget(self, action: #selector(self.personNameChange(sender: cell.userName, row: indexPath.row), for: .valueChanged)
        
        cell.userName.addTarget(self, action: #selector(personNameChange(_:_:)), for: .valueChanged)
        
        return cell
    }
    
    func deletePerson(_ indexPath: IndexPath) {
        // let person = self.persons[indexPath.row]
        // Remove the item from the store
        self.persons.remove(at: indexPath.row)
        // Also remove that row from the table view with an animation
        self.userTableView.deleteRows(at: [indexPath], with: .automatic)
    }
    
    @IBAction func addUser(_ sender: UIButton) {
        
        let newPerson = Person("")
        persons.append(newPerson)
        
        if let index = persons.lastIndex(of: newPerson) {
            let indexPath = IndexPath(row: index, section: 0)
            userTableView.insertRows(at: [indexPath], with: .automatic)
        }
    }
    
    @objc func personNameChange(_ sender: UITextField, _ row: Int) {
        let text = sender.text ?? ""
        self.persons[row].name = text
    }
    
    @IBAction func backgroundTapped(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    // --- NEXT BUTTON ---
    
    @IBAction func receiptDetailsNext(_ sender: UIBarButtonItem) {
        
        // Read text fields and date into a receipt object
        let name = receiptName.text ?? ""
        let date = datePicker.date
        
    
        if name == "" {
            let empty = UIAlertController(title: "Required Data Missing", message: "Receipt must have a name", preferredStyle: .alert)
            let cancel = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
            
            empty.addAction(cancel)
            present(empty, animated: true, completion: nil)
        } else if !checkPersons() {
            let empty = UIAlertController(title: "Required Data Missing", message: "Must be at least one person", preferredStyle: .alert)
            let cancel = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
            
            empty.addAction(cancel)
            present(empty, animated: true, completion: nil)
        } else {
            if currReceipt != -1 {
                // TODO need to update name, persons, and date
                // then segue past the camera to details
                self.performSegue(withIdentifier: "Manual", sender: sender)
            }
            
            
            if currReceipt == -1 { // We want to make a new receipt entirely
                receipt = Receipt(name: name, date: date)
                receipt.persons = self.persons
                
                // Generate a popover to choose the entry mode
                let entryModePopover = UIAlertController(title: "How would you like to add items to the receipt?", message: nil, preferredStyle: .actionSheet)
                // Setup actions for the popover
                
                let camAction = UIAlertAction(title: "Camera", style: .default) { _ in
                    let documentCameraViewController = VNDocumentCameraViewController()
                    documentCameraViewController.delegate = self
                    self.present(documentCameraViewController, animated: true)
                }
                
                let galAction = UIAlertAction(title: "Gallery", style: .default) { _ in
                    self.galleryViewController()
                }
                
                let manAction = UIAlertAction(title: "Manual", style: .default) { _ in
                    self.performSegue(withIdentifier: "Manual", sender: sender)
                }
                
                let canAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                // Add actions to the popover
                entryModePopover.addAction(camAction)
                entryModePopover.addAction(galAction)
                entryModePopover.addAction(manAction)
                entryModePopover.addAction(canAction)
                // Setup the location for popover

                if let popoverController = entryModePopover.popoverPresentationController {
                    popoverController.barButtonItem = sender as? UIBarButtonItem
                }

        //        entryModePopover.popoverPresentationController?.sourceView = sender.customView
        //        entryModePopover.popoverPresentationController?.sourceRect = sender.customView?.bounds
                // Actually do the popover
                present(entryModePopover, animated: true, completion: nil)
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.endEditing(false)
    }
    
    
    static let receiptContentsVC = "receiptContentsVC"
    var receiptViewController: ReceiptViewController?
    var textRecognitionRequest = VNRecognizeTextRequest()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("CreateVC WillAppear currReceipt: \(currReceipt)")
        if currReceipt != -1 {
            self.receipt = globalReceipts.receipts[currReceipt]
            receiptName.text = self.receipt.name
            datePicker.date = self.receipt.date
        } else {
            receiptName.text = ""
            datePicker.date = Date()
        }
    }
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        print("CreateVC viewDidLoad currReceipt: \(currReceipt)")
        if currReceipt != -1 {
            self.receipt = globalReceipts.receipts[currReceipt]
            receiptName.text = self.receipt.name
            datePicker.date = self.receipt.date
        }
        
        receiptName.delegate = self
        
        textRecognitionRequest = VNRecognizeTextRequest(completionHandler: { (request, error) in
            guard let receiptViewController = self.receiptViewController else {
                print("receiptViewController is not set")
                return
            }
            
            receiptViewController.receipt = self.receipt

            if let results = request.results, !results.isEmpty {
                if let requestResults = request.results as? [VNRecognizedTextObservation] {
                    DispatchQueue.main.async {
                        self.receipt.items = receiptViewController.processRecognizedText(recognizedText: requestResults)
                    }
                }
            }
        })
        // This doesn't require OCR on a live camera feed, select accurate for more accurate results.
        textRecognitionRequest.recognitionLevel = .accurate
        textRecognitionRequest.usesLanguageCorrection = true
        
        //print("CREATE VIEW LOADED")
        //print("Contents: ")
        //print(receiptStore!)
        
        
        
        //receiptStore.receipts.append(newReceipt)
        
        //print("new receipt appended")
        
    }

    func checkPersons() -> Bool {
        if self.persons.isEmpty {
            return false
        }
        
        for person in self.persons {
            if person.name == "" {
                // Person name is empty, delete person
                if let index = self.persons.firstIndex(of: person) {
                    self.persons.remove(at: index)
//                    self.userTableView.reloadData()
                }
            }
        }
        
        if self.persons.isEmpty {
            return false
        } else {
            return true
        }
    }
    
    
    // Whenever the create tab is pressed on the tab view the choose source menu will appear
//    override func viewDidAppear(_ animated: Bool) {
//        choosePhotoSource()
//    }
    
//    @IBAction func CameraBtnAction(_ sender: UIButton) {
//        self.entryMode = .camera
//        let documentCameraViewController = VNDocumentCameraViewController()
//        documentCameraViewController.delegate = self
//        present(documentCameraViewController, animated: true)
//    }
//
//    // TODO: Write me!
//    @IBAction func galleryButton(_ sender: UIButton) {
//        self.entryMode = .gallery
//    }
//
//    // TODO: Write me!
//    @IBAction func manualButton(_ sender: UIButton) {
//        self.entryMode = .manual
//    }
    
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // if the triggered segue is the "showItem" segue
        switch segue.identifier {
        case "Manual"?:
            let receiptViewController = segue.destination as! ReceiptViewController
            receiptViewController.receipt = receipt
        default:
            preconditionFailure("Unexpected segue identifier.")
        }
    }
    
    
    func imagePicker(for sourceType: UIImagePickerController.SourceType)
    -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = sourceType
        return picker
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        // get picked image from info dictionary
        let image = info[.originalImage] as! UIImage
        // take image picker off the screen -- must call this dismiss method
        dismiss(animated: true) {
            self.processImage(image: image)
            if let resultsVC = self.receiptViewController {
                self.navigationController?.pushViewController(resultsVC, animated: true)
            }
        }
    }
}

extension CreateViewController {
    func galleryViewController() {
        
        let vcID = CreateViewController.receiptContentsVC

        receiptViewController = storyboard?.instantiateViewController(withIdentifier: vcID) as? ReceiptViewController
        
        let imagePicker = self.imagePicker(for: .photoLibrary)
        self.present(imagePicker, animated: true, completion: nil)
    }
}

extension CreateViewController: VNDocumentCameraViewControllerDelegate {
    func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFinishWith scan: VNDocumentCameraScan) {
        
        let vcID = CreateViewController.receiptContentsVC

        receiptViewController = storyboard?.instantiateViewController(withIdentifier: vcID) as? ReceiptViewController
        
//        receiptViewController = storyboard?.instantiateViewController(withIdentifier: vcID) as? (UIViewController & RecognizedTextDataSource)
        
        //self.activityIndicator.startAnimating()
        controller.dismiss(animated: true) {
            DispatchQueue.global(qos: .userInitiated).async {
                for pageNumber in 0 ..< scan.pageCount {
                    let image = scan.imageOfPage(at: pageNumber)
                    self.processImage(image: image)
                }
                DispatchQueue.main.async {
                    if let resultsVC = self.receiptViewController {
                        self.navigationController?.pushViewController(resultsVC, animated: true)
                    }
                    //self.activityIndicator.stopAnimating()
                }
            }
        }
    }
}
