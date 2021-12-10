//
//  BudgetViewController.swift
//  SwiftSplit
//
//  Created by Austin Block on 10/21/21.
//

import UIKit

class BudgetViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // the list of people and amounts to show
    var allBudgets = [BudgetItem]()
    
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
        print("allBudgets count = ", allBudgets.count)
        return allBudgets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // This is the cell
        let cell = budgetTable.dequeueReusableCell(withIdentifier: "BudgetCell") as! BudgetCell
        
        // This is the item
        let item = allBudgets[indexPath.row]
        
        // Set the cells contents
        cell.nameLabel.text = item.person.name
        
        if let displayAmt = numberFormatter.string(from: NSNumber(value: item.amount)) {
            cell.dollarLabel.text = "$" + displayAmt
        }
        
        cell.preservesSuperviewLayoutMargins = false
        cell.separatorInset = UIEdgeInsets.zero
        cell.layoutMargins = UIEdgeInsets.zero
        
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
        allBudgets.removeAll()
        
        // Get the range we need
        let minDate = fromDatePicker.date
        let maxDate = toDatePicker.date
        
        for receipt in globalReceipts.receipts {
            let receiptDate = receipt.date
            
            // Is this receipt within the range?
            if isBetween(from: minDate, to: maxDate, toCheck: receiptDate) {
                
                // Get the receipt totals, then we'll break them up
                let theseTotals = receipt.getTotals()
                
                for total in theseTotals {
                    let currPerson = total.person
                    let currAmount = total.amount
                    
                    if let index = allBudgets.firstIndex(where: {$0.person == currPerson}) {
                        // There is already a budget entry for this person, so add to it
                        let addAmt = allBudgets[index].amount
                        allBudgets[index].amount = currAmount + addAmt
                    } else {
                        // There was not already a budget entry for this person
                        let newItem = BudgetItem(person: total.person, amount: total.amount)
                        allBudgets.append(newItem)
                    }

                }
                
            }
            
        }
        
        // Reload the table
        print("reloading table")
        self.budgetTable.reloadData()
        
    }
    
    func isBetween(from: Date, to: Date, toCheck: Date) -> Bool {
        // TODO: There is a bug here
        // It includes time in the query, not just the date
        // So it doesnt get receipts to the END of the day
        return (min(from, to) ... max(from, to)).contains(toCheck)
    }
    
    let numberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        return formatter
    }()
}
