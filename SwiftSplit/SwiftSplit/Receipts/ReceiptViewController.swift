//
//  ReceiptViewController.swift
//  SwiftSplit
//
//  Created by Austin Block on 11/4/21.
//

import UIKit

class ReceiptViewController: UITableViewController, UITextFieldDelegate {
    var receipt: Receipt!
    static let tableCellIdentifier = "receiptContentCell"
    
//    var assignUsersViewController: AssignUsersViewController?
//    static let assignUsersVC = "assignUsersVC"
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
        
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    

    @IBAction func itemCellDelete(_ sender: UIButton) {
        view.endEditing(true)
        self.deleteItem(sender.tag)
    }
    
    @IBAction func backgroundTapped(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    func deleteItem(_ index: Int) {
        let indexPath = IndexPath(item: index, section: 0)
        self.receipt.items.remove(at: index)
        self.tableView.deleteRows(at: [indexPath], with: .none)
        tableView.reloadData()
    }
    
    @IBAction func AddItemButton(_ sender: UIBarButtonItem) {
        let newItem = ReceiptItem(name: "", price: 0.0, taxed: false)
        receipt.addItem(newItem)
        
        if let index = receipt.items.lastIndex(of: newItem) {
            let indexPath = IndexPath(row: index, section: 0)
            tableView.insertRows(at: [indexPath], with: .none)
            // Move to the new cell, focus on the name field
            tableView.scrollToRow(at: indexPath, at: .bottom, animated: false)
            let newRow = tableView.cellForRow(at: indexPath) as! CreateReceiptCell
            newRow.itemName.becomeFirstResponder()
        }
    }
    
    @IBAction func nextButton(_ sender: UIBarButtonItem) {
        // Ends editing for every cell thus saving the text
        view.endEditing(true)
        
        if !checkItems() {
            let alert = UIAlertController(title: "Required Data Missing", message: "Receipt must have 1+ item.", preferredStyle: .alert)
            let cancel = UIAlertAction(title: "Dismiss", style: .cancel, handler: nil)
            
            alert.addAction(cancel)
            present(alert, animated: true, completion: nil)
        } else {
            self.performSegue(withIdentifier: "goToAssignItems", sender: sender)
        }
    }
    
    // SEGUE TO ASSIGN USERS
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "goToAssignItems"?:
            let assignUsersViewController = segue.destination as! AssignUsersViewController
            assignUsersViewController.receipt = receipt
        default:
            preconditionFailure("Unexpected segue identifier.")
        }
    }
    
    func checkItems() -> Bool {
        if self.receipt.items.isEmpty {
            return false
        }
        
        for item in self.receipt.items {
            if item.name == "" {
                // item name is empty, delete item
                if let index = self.receipt.items.firstIndex(of: item) {
                    self.receipt.items.remove(at: index)
                    self.tableView.reloadData()
                }
            }
            // TODO: maybe make a requirement for price to be non zero
        }
        
        if self.receipt.items.isEmpty {
            return false
        } else {
            return true
        }
    }
    
}
// MARK: UITableViewDataSource
extension ReceiptViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return receipt.items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let field = receipt.items[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CreateReceiptCell", for: indexPath) as! CreateReceiptCell
        
        cell.itemName.text = field.name
        cell.itemName.delegate = self
        cell.itemPrice.text = String(field.price).currencyInputFormatting()
        cell.itemPrice.delegate = self
        cell.taxSwitch.isOn = field.taxed
        cell.deleteBtn.tag = indexPath.row
        
        cell.taxSwitch.tag = indexPath.row
        cell.taxSwitch.addTarget(self, action: #selector(self.changeIsTaxed(_:)), for: .valueChanged)
        
        cell.itemName.tag = indexPath.row
        cell.itemName.addTarget(self, action: #selector(self.itemNameDidEdit(_:)), for: .editingDidEnd)
        
        cell.itemPrice.tag = indexPath.row
        cell.itemPrice.addTarget(self, action: #selector(self.itemPriceDidEdit(_:)), for: .editingDidEnd)

        cell.itemPrice.locale = Locale(identifier: "en_US")
        
        return cell
    }
        
    @IBAction func changeIsTaxed(_ sender: UISwitch){
        let currentState = sender.isOn
        let cellID = sender.tag
        let item = receipt.items[cellID]
        if currentState {
            item.taxed = true
        } else {
            item.taxed = false
        }
    }

    @IBAction func itemNameDidEdit(_ sender: UITextField) {
        //print("itemNameDidEdit: tag ->", sender.tag)
        let item = self.receipt.items[sender.tag]
        item.name = sender.text! ?? ""
    }
    
    @IBAction func itemPriceDidEdit(_ sender: UITextField) {
        // Get the text from input
        let rawString = sender.text ?? "0.00"
        
        // Set input to a cleaned version of the input
        sender.text = rawString.currencyInputFormatting()
        
        // Actually update the item in receipt
        let item = self.receipt.items[sender.tag]
        item.price = rawString.currencyInputFiltering()
    }
    
}

extension String {

    // formatting text for currency
    func currencyInputFormatting() -> String {
        
        var number: NSNumber!
        let formatter = NumberFormatter()
        formatter.numberStyle = .currencyAccounting
        formatter.currencySymbol = "$"
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 2

        // Clean the string to only contain numbers
        let uncleaned = self
        let cleaned = uncleaned.filter("0123456789.".contains)

        // Convert to a double
        let double = (cleaned as NSString).doubleValue
        number = NSNumber(value: double)
        
        let returnVal = formatter.string(from: number)!
        
        //print("formatting:", self, " -> ", returnVal)
        
        return returnVal
    }
    
    func currencyInputFiltering() -> Double {

        // Clean the string to only contain numbers
        let uncleaned = self
        let cleaned = uncleaned.filter("0123456789.".contains)

        // Convert to a double
        let double = (cleaned as NSString).doubleValue

        // if first number is 0 or all numbers were deleted
        guard double != 0 as Double else {
            return 0
        }
        
        return double
    }
}
