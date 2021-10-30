//
//  Receipt.swift
//  SwiftSplit
//
//  Created by Austin Block on 10/18/21.
//

import Foundation

class Receipt: Equatable, Codable {
    var name: String
    var date: Date
    var items = [ReceiptItem]()
    var persons = [Person]()
    
    init(name: String, date: Date) {
        self.name = name
        self.date = date
    }
    
    // -- GET THE TOTALS --
    func getTotals() -> [ReceiptTotal] {
        // TODO: NEEDS WORK!!!
        // Right now, it splits items
        // But ignores tax, for testing ONLY
        
        var receiptTotals = [ReceiptTotal]()
        
        // Init a receipt item for each person on the receipt
        for person in persons {
            let newTotal = ReceiptTotal(person: person, amount: 0.0)
            receiptTotals.append(newTotal)
        }
        
        // Loop through all receipt items and add them up
        for item in items {
            for person in item.persons {
                if let index = receiptTotals.firstIndex(where: {$0.person == person}) {
                    let previousAmt = receiptTotals[index].amount
                    receiptTotals[index].amount = previousAmt + Double((item.price / Double(item.persons.count)))
                } else {
                    print("just go home, it didnt work")
                }
            }
        }
        
        return receiptTotals
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
    
    // -- EQUALITY --
    
    static func ==(lhs: Receipt, rhs: Receipt) -> Bool {
        return lhs.name == rhs.name
            && lhs.date == rhs.date
            && lhs.items == rhs.items
            && lhs.persons == rhs.persons
    }
    
}
