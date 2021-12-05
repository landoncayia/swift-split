//

import UIKit
import VisionKit
import Vision

class ReceiptDetailsController : UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    var receipt: Receipt!
    var name: String!
    var date: Date!
    var persons = [Person]()
    
    // Table related
    let sectionsCount = 4
    let detailsNameCellIdentifier = "detailsNameCell"
    let detailsDateCellIdentifier = "detailsDateCell"
    let detailsPersonHeadingCellIdentifier = "detailsPersonHeadingCell"
    let detailsUserCellIdentifier = "detailsUserCell"
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 || section == 1 || section == 2 {
            // First, second, and third sections
            // Contain one cell
            return 1
        } else if section == 3 {
            return persons.count
        } else {
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // The cells in this table are created programatically
        if indexPath.section == 0 {
            // Section 0 contains detailsNameCell
            let cell = self.tableView.dequeueReusableCell(withIdentifier: "detailsNameCell", for: indexPath) as! DetailsNameCell
            return cell
        } else if indexPath.section == 1 {
            // Section 1 contains detailsDateCell
            let cell = self.tableView.dequeueReusableCell(withIdentifier: "detailsDateCell", for: indexPath)  as! DetailsDateCell
            return cell
        } else if indexPath.section == 2 {
            // Section 2 contains detailsPersonsHeadingCell
            let cell = self.tableView.dequeueReusableCell(withIdentifier: "detailsPersonsHeadingCell", for: indexPath)  as! DetailsPersonHeadingCell
            return cell
        } else {
            // Section 3 contains detailsPersonCell
            let cell = self.tableView.dequeueReusableCell(withIdentifier: "detailsPersonCell", for: indexPath) as! DetailsPersonCell
            cell.userName.text = persons[indexPath.row].name
            cell.userName.tag = indexPath.row
            cell.deleteBtn.tag = indexPath.row
            cell.userName.delegate = self
            return cell
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return self.sectionsCount
    }

    
    @IBAction func nameCellEditingDidEnd(_ sender: UITextField) {
        name = sender.text ?? ""
    }
    
    @IBAction func dateCellEditingDidEnd(_ sender: UIDatePicker) {
        date = sender.date
    }
    
    
    @IBAction func personCellEditingEnd(_ sender: UITextField) {
        persons[sender.tag].name = sender.text ?? ""
    }
    
    @IBAction func personCellDelete(_ sender: UIButton) {
        // Forces editing of cells to stop thus saving the text
        view.endEditing(true)
        self.deletePerson(sender.tag)
    }

    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    
    @IBAction func backgroundTapped(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }

    
    func deletePerson(_ index: Int) {
        let indexPath = IndexPath(item: index, section: 3)
        // Remove the item from the store
        self.persons.remove(at: index)
        // Also remove that row from the table view with an animation
        self.tableView.deleteRows(at: [indexPath], with: .none)
        self.tableView.reloadData()
    }
    
    @IBAction func addUser(_ sender: UIButton) {
        
        let newPerson = Person("")
        persons.append(newPerson)
        
        if let index = persons.lastIndex(of: newPerson) {
            let indexPath = IndexPath(row: index, section: 3)
            self.tableView.insertRows(at: [indexPath], with: .none)
            // Move to the new cell, focus on the name field
            self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: false)
            let newRow = self.tableView.cellForRow(at: indexPath) as! DetailsPersonCell
            newRow.userName.becomeFirstResponder()
        }
    }
    
    @IBAction func receiptDetailsNew(_ sender: UIBarButtonItem) {
        view.endEditing(true)
        
        // Set the receipt to nil
        
        receipt = nil
        name = nil
        date = nil
        persons.removeAll()
        
        // Reset all fields so that new stuff can be entered
        
        self.loadView()
    }
    
    @IBAction func receiptDetailsNext(_ sender: UIBarButtonItem) {
        // Ends editing for every cell thus saving the text
        view.endEditing(true)
        
        // Validation
        if name == "" {
            // Make sure name is not empty
            let empty = UIAlertController(title: "Required Data Missing", message: "Receipt must have a name.", preferredStyle: .alert)
            let cancel = UIAlertAction(title: "Dismiss", style: .cancel, handler: nil)
            empty.addAction(cancel)
            present(empty, animated: true, completion: nil)
        } else if !checkPersons() {
            // Remove empty people and make sure at least one
            let empty = UIAlertController(title: "Required Data Missing", message: "Receipt must have 1+ person.", preferredStyle: .alert)
            let cancel = UIAlertAction(title: "Dismiss", style: .cancel, handler: nil)
            empty.addAction(cancel)
            present(empty, animated: true, completion: nil)
        } else {
            // Validation passed
            // Now save the receipt
            
            // What message should appear
            var userMessage = "How would you like to add items to the receipt?"
            var thirdOption = "Manually"
            
            if receipt != nil {
                receipt.name = self.name
                receipt.date = self.date!
                receipt.persons = self.persons
                
                if receipt.items.count > 0 {
                    // Different messages for existing receipt with item already in it
                    userMessage = "Would you like to overwrite the items in this receipt?"
                    thirdOption = "Keep Existing Items"
                }
            } else {
                // Create new receipt
                receipt = Receipt(name: self.name, date: self.date!, persons: self.persons)
                // Save the receipt
                globalReceipts.receipts.append(receipt)
            }
            
            // Generate a popover to choose the entry mode
            let entryModePopover = UIAlertController(title: userMessage, message: nil, preferredStyle: .actionSheet)
            
            // Setup actions for the popover
            let camAction = UIAlertAction(title: "Camera", style: .default) { _ in
                let documentCameraViewController = VNDocumentCameraViewController()
                documentCameraViewController.delegate = self
                self.present(documentCameraViewController, animated: true)
            }
            let galAction = UIAlertAction(title: "Gallery", style: .default) { _ in
                self.galleryViewController()
            }
            let manAction = UIAlertAction(title: thirdOption, style: .default) { _ in
                self.performSegue(withIdentifier: "goToReceiptItems", sender: sender)
            }
            let canAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            
            // Checks to see if Camera and Gallery are available
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                entryModePopover.addAction(camAction)
            }
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                entryModePopover.addAction(galAction)
            }
            entryModePopover.addAction(manAction)
            entryModePopover.addAction(canAction)
            
            // Setup the location for popover
            if let popoverController = entryModePopover.popoverPresentationController {
                popoverController.barButtonItem = sender
            }
            present(entryModePopover, animated: true, completion: nil)
        }
    }
    
    static let receiptContentsVC = "receiptContentsVC"
    var receiptViewController: ReceiptViewController?
    var textRecognitionRequest = VNRecognizeTextRequest(completionHandler: nil)
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Check if we are editing or creating a new receipt
        if receipt != nil {
            // OLD receipt so...
            // Load it
            //self.receipt = globalReceipts.receipts[currReceipt]
            
            let detailsNameCell = self.tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as! DetailsNameCell
            
            let detailsDateCell = self.tableView.cellForRow(at: IndexPath(row: 0, section: 1)) as! DetailsDateCell
            
            // Load the values into this controller
            self.name = self.receipt.name
            self.date = self.receipt.date
            self.persons = self.receipt.persons
            
            // Load the values into fields
            detailsNameCell.nameField.text = self.receipt.name
            detailsDateCell.datePicker.date = self.receipt.date
            self.tableView.reloadData()
        } else {
            self.date = Date()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textRecognitionRequest = VNRecognizeTextRequest(completionHandler: { (request, error) in
            guard let receiptViewController = self.receiptViewController else {
                // receiptViewController is not set
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
                    self.tableView.reloadData()
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
            // Failed to get cgimage from input image
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
    
    func galleryViewController() {
        
        let vcID = ReceiptDetailsController.receiptContentsVC

        receiptViewController = storyboard?.instantiateViewController(withIdentifier: vcID) as? ReceiptViewController
        
        let imagePicker = self.imagePicker(for: .photoLibrary)
        self.present(imagePicker, animated: true, completion: nil)
    }
}


extension ReceiptDetailsController: VNDocumentCameraViewControllerDelegate {
    func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFinishWith scan: VNDocumentCameraScan) {
        
        let vcID = ReceiptDetailsController.receiptContentsVC

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
