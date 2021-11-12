//
//  ReceiptViewController.swift
//  SwiftSplit
//
//  Created by Austin Block on 11/4/21.
//

import UIKit

class ReceiptViewController: UITableViewController {
    var receiptStore: ReceiptStore!
    var receipt: Receipt!
    
    static let tableCellIdentifier = "receiptContentCell"

    // Use this height value to differentiate between big labels and small labels in a receipt.
    static let textHeightThreshold: CGFloat = 0.025
    
    typealias ReceiptContentField = (name: String, value: String)

    // The information to fetch from a scanned receipt.
    struct ReceiptContents {

        var name: String?
        var items = [ReceiptContentField]()
    }
    var contents = ReceiptContents()
    
    
    // Converts the ReceiptContentField into a receipt
    // This is so that ReceiptOCR doesn't have to do anything extra/ makes it easier
    // Also because observations aren't put together in groups
    func convertToReceipt(){
        receipt.name = contents.name!
        // date already set here
        for item in contents.items {
            if item.name == "Order" || item.name == "Date" {
                continue
            }
            
            let newItem = ReceiptItem(name: "", price: 0.0, taxed: true)
            let itemName = item.name
            let itemPrice = 0.0
            // let itemTaxed = item.taxed
            if let convertPrice = Double(item.value){
                newItem.price = convertPrice
            } else {
                print("Failed to convert item price from \(item.value) to Double")
                newItem.price = 0.0
            }
            

            newItem.name = itemName
            newItem.price = itemPrice
            newItem.taxed = true // TODO: change this when taxed OCR implemented
            
        }
    }
    
    @IBAction func appendReceipt(){
        self.receiptStore.addReceipt(self.receipt)
        performSegue(withIdentifier: "itemsToBrowse", sender: self)
    }
    
    
    
}

// MARK: UITableViewDataSource
extension ReceiptViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return receipt.items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let field = receipt.items[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "receiptCell", for: indexPath) as! CreateReceiptCell
        
        cell.itemName.text = field.name
        cell.itemPrice.text = "\(field.price)"
        
        cell.taxSwitch.tag = indexPath.row
        cell.taxSwitch.addTarget(self, action: #selector(self.changeIsTaxed(_:)), for: .valueChanged)
        
        
//        cell.itemPrice.text = field.value
        print("\(field.name)\t\(field.price)")
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
    
    
    
}
    
class CreateReceiptCell: ReceiptCell {
    @IBOutlet var taxSwitch: UISwitch!
}
