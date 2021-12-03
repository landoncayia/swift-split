//

import UIKit
import VisionKit
import Vision

class CreateViewController : UIViewController, UITableViewDataSource, UITableViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    var receipt: Receipt!

    var persons = [Person]()

    @IBOutlet var receiptName: UITextField!
    @IBOutlet var datePicker: UIDatePicker!
    
    // MARK: userTableView
    @IBOutlet var userTableView: UITableView! {
        didSet {
            userTableView.delegate = self
            userTableView.dataSource = self
            userTableView.rowHeight = UITableView.automaticDimension
        }
    }
    
    // --- USERS TABLE ---
    
    // MARK: numberOfRowsInSection
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return persons.count
    }
    
    // MARK: cellForRowAt
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = userTableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath) as! UserCell
        cell.userName.text = persons[indexPath.row].name
        print("Index Path: \(indexPath.row)")
        cell.userName.tag = indexPath.row
        cell.deleteBtn.tag = indexPath.row
        cell.userName.delegate = self
        
        
        return cell
    }
    
    @IBAction func personCellEditingEnd(_ sender: UITextField) {
        print("person cell editing end")
        print("\(sender.tag) -> , \(sender.text ?? "")")
        print(persons)
        persons[sender.tag].name = sender.text ?? ""
        print(persons)
    }
    
    @IBAction func personCellDelete(_ sender: UIButton) {
        // Forces editing of cells to stop thus saving the text
        view.endEditing(true)
        
        print("delete tag -> ", sender.tag)
        print(persons)
        self.deletePerson(sender.tag)
        print(persons)
    }
    
    //    // MARK: textFieldDidEndEditing
//    func textFieldDidEndEditing(userName: UITextField) {
//        print("END EDITING")
//        persons[userName.tag].name = userName.text ?? ""
//    }
//
    @IBAction func backgroundTapped(_ sender: UITapGestureRecognizer) {
        print("bg tapped")
        view.endEditing(true)
    }

    
    func deletePerson(_ index: Int) {
        let indexPath = IndexPath(item: index, section: 0)
        // Remove the item from the store
        self.persons.remove(at: index)
        // Also remove that row from the table view with an animation
        self.userTableView.deleteRows(at: [indexPath], with: .none)
        userTableView.reloadData()
    }
    
    @IBAction func addUser(_ sender: UIButton) {
        
        let newPerson = Person("")
        persons.append(newPerson)
        
        if let index = persons.lastIndex(of: newPerson) {
            let indexPath = IndexPath(row: index, section: 0)
            userTableView.insertRows(at: [indexPath], with: .none)
            // Move to the new cell, focus on the name field
            userTableView.scrollToRow(at: indexPath, at: .bottom, animated: false)
            let newRow = userTableView.cellForRow(at: indexPath) as! UserCell
            newRow.userName.becomeFirstResponder()
        }
    }
    
    //@objc func personNameChange(_ sender: UITextField, _ row: Int) {
    //    let text = sender.text ?? ""
    //    self.persons[row].name = text
    //}
    
    // MARK: --- NEW BUTTON ---
    
    @IBAction func receiptDetailsNew(_ sender: UIBarButtonItem) {
        view.endEditing(true)
        
        // Set the receipt to nil
        
        receipt = nil
        persons.removeAll()
        
        // Reset all fields so that new stuff can be entered
        
        self.loadView()
    }
    
    
    // MARK: --- NEXT BUTTON ---
    
    @IBAction func receiptDetailsNext(_ sender: UIBarButtonItem) {
        // Ends editing for every cell thus saving the text
        view.endEditing(true)
        
        // Read text fields and date into a receipt object
        let name = receiptName.text ?? "Untitled Receipt"
        let date = datePicker.date
        
        // Validation
        if name == "" {
            // Make sure name is not empty
            let empty = UIAlertController(title: "Required Data Missing", message: "Receipt must have a name.", preferredStyle: .alert)
            let cancel = UIAlertAction(title: "Dismiss", style: .cancel, handler: nil)
            empty.addAction(cancel)
            present(empty, animated: true, completion: nil)
        } else if !checkPersons() {
            // Remove empty people and make sure at least one
            print("Persons:", persons)
            let empty = UIAlertController(title: "Required Data Missing", message: "Receipt must have 1+ person.", preferredStyle: .alert)
            let cancel = UIAlertAction(title: "Dismiss", style: .cancel, handler: nil)
            empty.addAction(cancel)
            present(empty, animated: true, completion: nil)
        } else {
            // Validation passed
            // Now save the receipt
            
            if receipt == nil {
                // NEW receipt so...
                print("NEW receipt")
                
                // Create the receipt
                receipt = Receipt(name: name, date: date, persons: self.persons)
                
                // Save the receipt
                globalReceipts.receipts.append(receipt)
                
                // Update currReceipt index
                // currReceipt = globalReceipts.receipts.count - 1
                
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
                    self.performSegue(withIdentifier: "goToReceiptItems", sender: sender)
                }
                let canAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                // Add actions to the popover
                entryModePopover.addAction(camAction)
                entryModePopover.addAction(galAction)
                entryModePopover.addAction(manAction)
                entryModePopover.addAction(canAction)
                
                // Setup the location for popover
                if let popoverController = entryModePopover.popoverPresentationController {
                    popoverController.barButtonItem = sender
                }
                present(entryModePopover, animated: true, completion: nil)
            } else {
                // OLD receipt so...
                print("OLD receipt, skipping entry modes")
                
                // Update all the stuff in this receipt
                receipt.name = name
                receipt.date = date
                receipt.persons = self.persons
                
                self.performSegue(withIdentifier: "goToReceiptItems", sender: sender)
            }
        }
    }
    
    static let receiptContentsVC = "receiptContentsVC"
    var receiptViewController: ReceiptViewController?
    var textRecognitionRequest = VNRecognizeTextRequest(completionHandler: nil)
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        print("CreateVC WillAppear receipt: \(receipt.name)")
        // Check if we are editing or creating a new receipt
        if receipt != nil {
            // OLD receipt so...
            // Load it
            //self.receipt = globalReceipts.receipts[currReceipt]
            // Load its values onto this page
            receiptName.text = self.receipt.name
            datePicker.date = self.receipt.date
            self.persons = self.receipt.persons
            userTableView.reloadData()
        }
    }
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
//        print("CreateVC viewDidLoad receipt: \(receipt.name)")
//        if currReceipt != -1 {
//            self.receipt = globalReceipts.receipts[currReceipt]
//            self.receiptName.text = self.receipt.name
//            self.datePicker.date = self.receipt.date
//            self.persons = self.receipt.persons
//        }
//
//        print("persons:", self.persons)
        
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
                        // FINDME
//                        self.receipt.items = receiptViewController.processRecognizedText(recognizedText: requestResults)
                        receiptViewController.processRecognizedText(recognizedText: requestResults)
                    }
                }
            }
        })
        // Use the global settings to set the options
        switch globalSettings.currentSettings.recognitionLevel.rawValue {
        case ".accurate":
            textRecognitionRequest.recognitionLevel = .accurate
        case ".fast":
            textRecognitionRequest.recognitionLevel = .fast
        default:
            textRecognitionRequest.recognitionLevel = .accurate
        }
        
        textRecognitionRequest.usesLanguageCorrection = globalSettings.currentSettings.languageCorrection
        
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
                    self.userTableView.reloadData()
                }
            }
        }
        
        if self.persons.isEmpty {
            return false
        } else {
            return true
        }
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "goToReceiptItems":
            let receiptViewController = segue.destination as! ReceiptViewController
            receiptViewController.receipt = self.receipt
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
            DispatchQueue.global(qos: .userInitiated).async {
                DispatchQueue.main.async {
                    self.processImage(image: image)
                    self.performSegue(withIdentifier: "goToReceiptItems", sender: nil)
                }
            }
//            if let resultsVC = self.receiptViewController {
//                self.navigationController?.pushViewController(resultsVC, animated: true)
//            }
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
                    self.performSegue(withIdentifier: "goToReceiptItems", sender: nil)
                    //if let resultsVC = self.receiptViewController {
                        
                        //resultsVC.receipt = self.receipt
                        //self.navigationController?.pushViewController(resultsVC, animated: true)
                    //}
                    //self.activityIndicator.stopAnimating()
                }
            }
        }
    }
}
