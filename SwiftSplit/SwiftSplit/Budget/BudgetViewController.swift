//
//  BudgetViewController.swift
//  SwiftSplit
//
//  Created by Austin Block on 10/21/21.
//

import UIKit

class BudgetViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // the receipt store, which will be set in scene delegate
    var receiptStore: ReceiptStore!
    
    // the list of people and amounts to show
    var budgetStore = [BudgetItem]()
    
    // Date picker widget outlets (to modify from Swift)
    @IBOutlet var fromDatePicker: UIDatePicker!
    @IBOutlet var toDatePicker: UIDatePicker!
    
    // Date picker widget actions (to modify from SB)
    @IBAction func fromDateChange(_ sender: UIDatePicker) {
        print("date changed")
        processReceipts()
    }
    
    @IBAction func toDateChange(_ sender: UIDatePicker) {
        print("date changed")
        processReceipts()
    }
    
    // Just cause this table is inside another view
    @IBOutlet var budgetTable: UITableView! {
            didSet {
                budgetTable.delegate = self;
                budgetTable.dataSource = self;
            }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("budgetStore count = ", budgetStore.count)
        return budgetStore.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // This is the cell
        let cell = budgetTable.dequeueReusableCell(withIdentifier: "BudgetCell") as! BudgetCell
        
        // This is the item
        let item = budgetStore[indexPath.row]
        
        // Set the cells contents
        cell.nameLabel.text = item.person.name
        cell.dollarLabel.text = String(item.amount)
        
        return cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Update the From date to -1 week
        if let dateMinusMonth = Calendar.current.date(byAdding: .month, value: -1, to: Date()) {
            fromDatePicker.setDate(dateMinusMonth, animated: false)
        }

        // Update the To date to current date
        toDatePicker.setDate(Date(), animated: false)
        
        // Update the table based on receipts within this range
        processReceipts()
        
        print("viewDidLoad")
    }
    
    func processReceipts() {
        print("processReceipts")
        
        // Clear out the list of receipts
        budgetStore.removeAll()
        
        // Get the range we need
        let minDate = fromDatePicker.date
        let maxDate = toDatePicker.date
        
        for receipt in receiptStore.receipts {
            let receiptDate = receipt.date
            
            // Is this receipt within the range?
            if isBetween(from: minDate, to: maxDate, toCheck: receiptDate) {
                // TODO: This is setup only for testing
                
                // Need to add each perons
                let theseTotals = receipt.getTotals()
                
                // Create a budget item
                let newItem = BudgetItem(person: theseTotals.person, amount: theseTotals.amount)
                
                budgetStore.append(newItem)
            }
            
        }
        
        // Reload the table
        print("reloading table")
        self.budgetTable.reloadData()
        
    }
    
    func isBetween(from: Date, to: Date, toCheck: Date) -> Bool {
        return (min(from, to) ... max(from, to)).contains(toCheck)
    }
}
