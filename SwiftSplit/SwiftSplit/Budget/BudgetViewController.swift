//
//  BudgetViewController.swift
//  SwiftSplit
//
//  Created by Austin Block on 10/21/21.
//

import UIKit

class BudgetViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet var budgetTable: UITableView! {
            didSet {
                budgetTable.delegate = self;
                budgetTable.dataSource = self;
            }
    }
    
    var receipts: ReceiptStore! // Remove later
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
        // return receipts.receipts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = budgetTable.dequeueReusableCell(withIdentifier: "BudgetCell") as! BudgetCell
        cell.nameLabel.text = "testing"
        cell.dollarLabel.text = "$9.99"
        return cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // let date = Date()
        // let newReceipt = Receipt(name: "test", date: date)
        // receipts.addReceipt(newReceipt)
        print("viewDidLoad")
    }
}
