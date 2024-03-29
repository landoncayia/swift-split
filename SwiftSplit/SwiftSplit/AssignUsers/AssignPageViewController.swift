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
        //print("Number of items that should appear in table:", receipt.items.count)
    }
    
    func updateItemPersons(indexPath: IndexPath) -> Bool {
        let item = receipt.items[indexPath.row]
        let person = Person("")
        var index = 0
        person.name = personName.text!
        index = receipt.persons.firstIndex(of: person)!
        
        if !item.persons.contains(person) {
            item.addPerson(receipt.persons[index])
            return true
        } else {
            item.removePerson(receipt.persons[index])
            return false
        }
    }
    
    //MARK: --- TABLE WIDGET ON THIS PAGE ---
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return receipt.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = assignTable.dequeueReusableCell(withIdentifier: "UserItemCell", for: indexPath) as! UserItemCell
        cell.itemName.text = receipt.items[indexPath.row].name
        cell.itemName.tag = indexPath.row
        
        // MARK: Doesn't work not sure how to get the cell selection animation
        if receipt.items[indexPath.row].persons.contains(Person(personName.text!)) {
            assignTable.selectRow(at: indexPath, animated: false, scrollPosition: .none)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if updateItemPersons(indexPath: indexPath) {
            assignTable.selectRow(at: indexPath, animated: false, scrollPosition: .none)
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if updateItemPersons(indexPath: indexPath) {
            assignTable.selectRow(at: indexPath, animated: false, scrollPosition: .none)
        }
    }
    
}
    
