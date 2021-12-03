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
    
    func updateItemPersons(indexPath: IndexPath, selected: Bool) {
        let item = receipt.items[indexPath.row]
        let person = Person("")
        var index = 0
        if selected {
            person.name = personName.text!
            index = receipt.persons.firstIndex(of: person)!
            item.addPerson(receipt.persons[index])
        } else {
            person.name = personName.text!
            index = receipt.persons.firstIndex(of: person)!
            item.removePerson(receipt.persons[index])
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = assignTable.cellForRow(at: indexPath) as! UserItemCell
        cell.setSelected(true, animated: true)
        updateItemPersons(indexPath: indexPath, selected: true)
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = assignTable.cellForRow(at: indexPath) as! UserItemCell
        cell.setSelected(false, animated: false)
        updateItemPersons(indexPath: indexPath, selected: false)
    }
    
}
    
