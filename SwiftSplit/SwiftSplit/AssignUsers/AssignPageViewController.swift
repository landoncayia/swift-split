//
//  AssignPageViewController.swift
//  SwiftSplit
//
//  Created by Austin Block on 12/1/21.
//

import UIKit

class AssignPageViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    //MARK: --- VARIABLES ---
    var receipt: Receipt!
    var idx: Int = -1
    
    //MARK: --- WIDGETS ON PAGE ---
    @IBOutlet var personName: UILabel!
    @IBOutlet var assignTable: UITableView! {
        didSet {
            assignTable.delegate = self
            assignTable.dataSource = self
            assignTable.rowHeight = UITableView.automaticDimension
        }
    }
    
    //MARK: --- SETUP VIEW ---
    override func viewDidLoad() {
        super.viewDidLoad()
        
        personName.text = receipt.persons[idx].name
        print("AssignPageViewController did load")
        
        print("Number of items that should appear in table:", receipt.items.count)
    }
    
    //MARK: --- TABLE WIDGET ON THIS PAGE ---
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return receipt.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = assignTable.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath) as! UserItemCell
        cell.itemName.text = receipt.items[indexPath.row].name
        cell.itemName.tag = indexPath.row
        return cell
    }
    
    //SEGUE TO ASSIGN USERS
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "toReceiptTotal"?:
            let receiptTotalViewController = segue.destination as! ReceiptTotalsViewController
            receiptTotalViewController.receipt = receipt
        default:
            preconditionFailure("Unexpected segue identifier.")
        }
    }
}
    
