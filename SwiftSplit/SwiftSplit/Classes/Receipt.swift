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
    var taxAmt: Double = 0
    var taxPercent: Double = 0
    var items = [ReceiptItem]()
    var persons = [Person]()
    var tag: Int = -1
    
    init(name: String, date: Date) {
        self.name = name
        self.date = date
    }
    
    // -- FOR THE TOTALS --
    func setTaxAmt(_ amount: Double) {
        self.taxAmt = amount;
        
        // Need to update the percent too
        var itemTotals = 0.0;
        
        for item in items {
            if item.taxed {
                itemTotals = itemTotals + item.price
            }
        }
        
        self.taxPercent = amount / itemTotals
        
    }
    
    func setTaxPercent(_ percent: Double) {
        self.taxPercent = percent;
        
        // Need to update the amount too
        var itemTotals = 0.0;
        
        for item in items {
            if item.taxed {
                itemTotals = itemTotals + item.price
            }
        }
        
        self.taxAmt = itemTotals * percent
        
    }
    
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
                    // How much the person currently owes
                    let previousAmt = receiptTotals[index].amount
                    
                    // How much of this item they are responsible for
                    var itemShare = Double((item.price / Double(item.persons.count)))
                    
                    // Consider tax implications
                    if item.taxed {
                        itemShare = itemShare + (itemShare * taxPercent)
                    }
                    
                    // Append to this persons total
                    receiptTotals[index].amount = previousAmt + itemShare
                    
                } else {
                    print("just go home, it didnt work")
                }
            }
        }
        
        return receiptTotals
    }
    
    
    // Returns the total receipt cost (not per person)
    func getWholeCost() -> Double{
        let totals = getTotals()
        var totalCost = 0.0
        for r in totals{
            totalCost += r.amount
        }
        return totalCost
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
