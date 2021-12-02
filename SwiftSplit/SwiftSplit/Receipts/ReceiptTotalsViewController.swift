//
//  ReceiptTotals.swift
//  SwiftSplit
//
//  Created by user207825 on 12/1/21.
//

import UIKit
class ReceiptTotalsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var receipt:  Receipt!
    var totals = [ReceiptTotal]()
    
    // TODO: connect
    @IBOutlet var tax: UILabel!
    @IBOutlet var total: UILabel!
    
    @IBOutlet var userTableView: UITableView! {
        didSet {
            userTableView.delegate = self
            userTableView.dataSource = self
            userTableView.rowHeight = UITableView.automaticDimension
        }
    }

    override func viewDidLoad() {
        totals = receipt.getTotals()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return totals.count
    }
        
    // TODO: change default tablecells to UserTotalCells
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = userTableView.dequeueReusableCell(withIdentifier: "UserTotalCell", for: indexPath) as! UserTotalCell
        cell.name.text = totals[indexPath.row].person.name
        cell.total.text = "$"+String(totals[indexPath.row].amount)
        return cell
    }
    
}
