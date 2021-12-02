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
        print("ReceiptViewController loaded")
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        print("ReceiptViewController will appear")
        
        for item in receipt.items {
            print(item.name)
        }
        tableView.reloadData()
        
//        let vcID = ReceiptViewController.assignUsersVC
//        assignUsersViewController = storyboard?.instantiateViewController(withIdentifier: vcID) as? AssignUsersViewController
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.endEditing(false)
    }
    
    // TODO: For now I set it so that it brings you back to createnav when you click save
    // Wasnt sure how I want to deal with changing currReceipt back to -1
    // I might have to make a function in TabViewController.
    
    @IBAction func itemCellDelete(_ sender: UIButton) {
        view.endEditing(true)
        
        print("delete tag -> ", sender.tag)
        print(receipt.items)
        self.deleteItem(sender.tag)
        print(receipt.items)
    }
    
    @IBAction func backgroundTapped(_ sender: UITapGestureRecognizer) {
        print("bg tapped")
        view.endEditing(true)
    }
    
    func deleteItem(_ index: Int) {
        let indexPath = IndexPath(item: index, section: 0)
        self.receipt.items.remove(at: index)
        self.tableView.deleteRows(at: [indexPath], with: .automatic)
        tableView.reloadData()
    }
    
    @IBAction func AddItemButton(_ sender: UIBarButtonItem) {
        let newItem = ReceiptItem(name: "", price: 0.0, taxed: false)
        receipt.addItem(newItem)
        
        if let index = receipt.items.lastIndex(of: newItem) {
            let indexPath = IndexPath(row: index, section: 0)
            tableView.insertRows(at: [indexPath], with: .automatic)
        }
    }
    
    @IBAction func nextButton(_ sender: UIBarButtonItem) {
        if currReceipt != -1 {
//            globalReceipts.receipts[currReceipt] = self.receipt
//            currReceipt = -1
//            print("Receipt saved")
//            print("Popping back to CreateNavViewController")
//            navigationController?.popToRootViewController(animated: true)
        } else {
//            globalReceipts.receipts.append(self.receipt)
//            print("Receipt appended")
//            print("Popping back to CreateNavViewController")
//            navigationController?.popToRootViewController(animated: true)
        }
//        
//        if let assignUsersViewController = self.assignUsersViewController {
//            assignUsersViewController.receipt = self.receipt
//            self.performSegue(withIdentifier: "goToAssignItems", sender: sender)
//        } else {
//            print("receiptViewController is not set")
//        }
        self.performSegue(withIdentifier: "goToAssignItems", sender: sender)
        
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
        cell.itemPrice.text = "\(field.price)"
        cell.itemPrice.delegate = self
        cell.taxSwitch.isOn = field.taxed
        cell.deleteBtn.tag = indexPath.row
        
        cell.taxSwitch.tag = indexPath.row
        cell.taxSwitch.addTarget(self, action: #selector(self.changeIsTaxed(_:)), for: .valueChanged)
        
        cell.itemName.tag = indexPath.row
        cell.itemName.addTarget(self, action: #selector(self.itemNameDidEdit(_:)), for: .editingDidEnd)
        
        cell.itemPrice.tag = indexPath.row
        cell.itemPrice.addTarget(self, action: #selector(self.itemPriceDidEdit(_:)), for: .editingDidEnd)
        
        // Used for price validation and format
//        cell.itemPrice.addTarget(self, action: #selector(self.currencyFieldChanged(_:)), for: .editingChanged)
        
        
        
        
        
        cell.itemPrice.locale = Locale(identifier: "en_US")
        
        return cell
    }
        
    @IBAction func changeIsTaxed(_ sender: UISwitch){
        let currentState = sender.isOn
        let cellID = sender.tag
        let item = receipt.items[cellID]
        if currentState {
            item.taxed = true
            print("\(item.name) taxed set to true")
        } else {
            item.taxed = false
            print("\(item.name) taxed set to false")
        }
    }

    @IBAction func itemNameDidEdit(_ sender: UITextField) {
        let item = self.receipt.items[sender.tag]
        item.name = sender.text!
    }
    
    @IBAction func itemPriceDidEdit(_ sender: UITextField) {
        let item = self.receipt.items[sender.tag]
//        item.price = Double(sender.text!) ?? 0.0 // Keyboard is set to decimal anyway but just in case
//        sender.text = String(item.price)
    }
    
//    @objc func currencyFieldChanged(_ sender: CurrencyField) {
//        // TODO: When deleting receipt items and/or exiting view, the prices all get divided by 10. It has something to do with ".decimal" or ".currency" in "CurrencyField"
//        let item = self.receipt.items[sender.tag]
//
//        item.price = (sender.decimal as NSDecimalNumber).doubleValue
//        print("currencyField:", sender.text!)
//        print("decimal:", sender.decimal)
//        print("doubleValue:", (sender.decimal as NSDecimalNumber).doubleValue, terminator: "\n\n")
//    }
    
}

extension String {

    // formatting text for currency textField
    func currencyInputFormatting() -> String {

        var number: NSNumber!
        let formatter = NumberFormatter()
        formatter.numberStyle = .currencyAccounting
        formatter.currencySymbol = "$"
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 2

        var amountWithPrefix = self

        // remove from String: "$", ".", ","
        let regex = try! NSRegularExpression(pattern: "[^0-9]", options: .caseInsensitive)
        amountWithPrefix = regex.stringByReplacingMatches(in: amountWithPrefix, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, self.count), withTemplate: "")

        let double = (amountWithPrefix as NSString).doubleValue
        number = NSNumber(value: (double / 100))

        // if first number is 0 or all numbers were deleted
        guard number != 0 as NSNumber else {
            return ""
        }

        return formatter.string(from: number)!
    }
}
