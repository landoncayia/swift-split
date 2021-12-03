//
//  ReceiptTotals.swift
//  SwiftSplit
//
//  Created by user207825 on 12/1/21.
//

import UIKit
class ReceiptTotalsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // MARK: Variables
    var receipt:  Receipt!
    var totals = [ReceiptTotal]()
 
    @IBOutlet var tax: UILabel!
    @IBOutlet var total: UILabel!
    
    @IBOutlet var totalTableView: UITableView! {
        didSet {
            totalTableView.delegate = self
            totalTableView.dataSource = self
            totalTableView.rowHeight = UITableView.automaticDimension
        }
    }

    override func viewDidLoad() {
        totals = receipt.getTotals()
        tax.text = String(receipt.taxAmt)
        total.text = String(receipt.getWholeCost())
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return totals.count
    }
        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = totalTableView.dequeueReusableCell(withIdentifier: "UserTotalCell", for: indexPath) as! UserTotalCell
        cell.name.text = totals[indexPath.row].person.name
        cell.total.text = "$"+String(totals[indexPath.row].amount)
        return cell
    }
    
}
