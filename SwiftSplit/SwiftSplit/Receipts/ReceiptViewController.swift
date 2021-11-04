//
//  ReceiptViewController.swift
//  SwiftSplit
//
//  Created by Austin Block on 11/4/21.
//

import UIKit

class ReceiptViewController: UITableViewController {

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
}

// MARK: UITableViewDataSource
extension ReceiptViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contents.items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let field = contents.items[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReceiptCell", for: indexPath) as! ReceiptCell
        
        cell.itemName.text = field.name
        cell.itemPrice.text = field.value
        
        print("\(field.name)\t\(field.value)")
        return cell
    }
}
    
