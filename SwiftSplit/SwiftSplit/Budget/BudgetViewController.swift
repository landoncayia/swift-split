//
//  BudgetViewController.swift
//  SwiftSplit
//
//  Created by Austin Block on 10/21/21.
//

import UIKit
class BudgetViewController: UITableViewController {
    var receipts: ReceiptStore!
    
    override func tableView(_ tableView: UITableView,
            numberOfRowsInSection section: Int) -> Int {
        return receipts.receipts.count
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func deleteItem(_ indexPath: IndexPath) {
        
    }
    
    override func tableView(_ tableView: UITableView,
            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Assign cell to model
        let cell = tableView.dequeueReusableCell(withIdentifier: "BudgetCell", for: indexPath) as! BudgetCell
        // Configure the cell with the Item
        cell.nameLabel.text = "Hello world"
        cell.dollarLabel.text = "$69"
        return cell
    }
}
