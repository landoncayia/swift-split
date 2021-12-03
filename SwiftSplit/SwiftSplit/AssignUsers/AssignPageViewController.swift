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
    
    // TODO: On the last page when pressing next the table view loads before this is executed
    override func viewDidDisappear(_ animated: Bool) {
        for i in 0...receipt.items.count-1 {
            if assignTable.cellForRow(at: IndexPath(row: i, section: 0))!.isSelected {
                let person = receipt.persons.firstIndex(of: Person(personName.text!))!
                receipt.items[i].addPerson(receipt.persons[person])
            }
        }
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
    
}
    
