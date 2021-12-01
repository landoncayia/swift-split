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
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.endEditing(false)
    }
    
    // TODO: For now I set it so that it brings you back to createnav when you click save
    // Wasnt sure how I want to deal with changing currReceipt back to -1
    // I might have to make a function in TabViewController.
    
    // TODO: Bradley needs to make it so that you can tap away when editing a price value and it will close the keyboard
    // TapGestureRec maybe needed
    
    
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
        self.performSegue(withIdentifier: "goToAssignItems", sender: sender)
    }
    
    @IBAction func itemNameChange(_ sender: UITextField) {
        let item = self.receipt.items[sender.tag]
        item.name = sender.text!
    }
    
    
    @IBAction func itemPriceChanged(_ sender: UITextField) {
        let item = self.receipt.items[sender.tag]
        item.price = Double(sender.text!) ?? 0.0 // Keyboard is set to decimal anyway but just in case
        sender.text = String(item.price)
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
        
        cell.taxSwitch.tag = indexPath.row
        cell.taxSwitch.addTarget(self, action: #selector(self.changeIsTaxed(_:)), for: .valueChanged)
        
        cell.itemName.tag = indexPath.row
        cell.itemName.addTarget(self, action: #selector(self.itemNameChange(_:)), for: .valueChanged)
        
        cell.itemPrice.tag = indexPath.row
        cell.itemPrice.addTarget(self, action: #selector(self.itemPriceChanged(_:)), for: .valueChanged)
        
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
}
