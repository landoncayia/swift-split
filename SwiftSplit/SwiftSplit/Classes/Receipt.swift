//
//  Receipt.swift
//  SwiftSplit
//
//  Created by Austin Block on 10/18/21.
//

import Foundation

class Receipt {
    var name: String
    var date: Date
    var items = [ReceiptItem]()
    var persons = [Person]()
    
    init(name: String, date: Date) {
        self.name = name
        self.date = date
    }
    
    // -- ITEMS --
    
    // Add receipt item
    func addItem(_ newItem: ReceiptItem) {
        items.append(newItem)
    }
    
    // Remove receipt item
    func removeItem(_ item: ReceiptItem) {
        if let index = items.firstIndex(of: item) {
            items.remove(at: index)
        }
    }
    
    // Move an item
    func moveItem(from fromIndex: Int, to toIndex: Int) {
        if fromIndex == toIndex {
            return
        }
        let itemToMove = items[fromIndex]
        items.remove(at: fromIndex)
        items.insert(itemToMove, at: toIndex)
    }
    
    // -- PERSONS --
    
    // Add person
    func addPerson(_ newPerson: Person) {
        persons.append(newPerson)
    }
    
    // Remove person
    func removePerson(_ person: Person) {
        if let index = persons.firstIndex(of: person) {
            persons.remove(at: index)
        }
    }
    
    // Move person
    func movePerson(from fromIndex: Int, to toIndex: Int) {
        if fromIndex == toIndex {
            return
        }
        let personToMove = persons[fromIndex]
        persons.remove(at: fromIndex)
        persons.insert(personToMove, at: toIndex)
    }
    
}
