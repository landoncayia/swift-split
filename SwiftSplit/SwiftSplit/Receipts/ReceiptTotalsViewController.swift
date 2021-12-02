//
//  ReceiptTotals.swift
//  SwiftSplit
//
//  Created by user207825 on 12/1/21.
//

import UIKit
class ReceiptTotalsViewController: UIViewController/*, UITableViewDataSource, UITableViewDelegate*/ {
    
    var receipt:  Receipt!
    @IBOutlet var tax: UILabel!
    @IBOutlet var total: UILabel!
    /*
    @IBOutlet var userTableView: UITableView! {
        didSet {
            userTableView.delegate = self
            userTableView.dataSource = self
            userTableView.rowHeight = UITableView.automaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        <#code#>
    }
     */
}
