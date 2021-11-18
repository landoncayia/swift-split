//
//  ReceiptViewController.swift
//  SwiftSplit
//
//  Created by Austin Block on 11/4/21.
//

import UIKit

class ReceiptViewController: UITableViewController {
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
        cell.itemPrice.text = "\(field.price)"
        
        //cell.taxSwitch.tag = indexPath.row
        //cell.taxSwitch.addTarget(self, action: #selector(self.changeIsTaxed(_:)), for: .valueChanged)
        
        
//        cell.itemPrice.text = field.value
        //print("\(field.name)\t\(field.price)")
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
