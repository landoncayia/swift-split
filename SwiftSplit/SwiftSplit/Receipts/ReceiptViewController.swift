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
    
    // TODO: Not working
    @IBAction func backgroundTapped(_ sender: UITapGestureRecognizer) {
        print("bg tapped")
        view.endEditing(true)
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
        
        cell.taxSwitch.tag = indexPath.row
        cell.taxSwitch.addTarget(self, action: #selector(self.changeIsTaxed(_:)), for: .valueChanged)
        
        cell.itemName.tag = indexPath.row
        cell.itemName.addTarget(self, action: #selector(self.itemNameDidEdit(_:)), for: .editingDidEnd)
        
        cell.itemPrice.tag = indexPath.row
        cell.itemPrice.addTarget(self, action: #selector(self.itemPriceDidEdit(_:)), for: .editingDidEnd)
        
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
        item.price = Double(sender.text!) ?? 0.0 // Keyboard is set to decimal anyway but just in case
        sender.text = String(item.price)
    }
    
}
