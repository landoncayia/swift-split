//
//  ReceiptStore.swift
//  SwiftSplit
//
//  Created by Austin Block on 10/18/21.
//

import UIKit
import Foundation

class ReceiptStore {
    var receipts = [Receipt]()
    
    // -- MANAGE RECEIPTS --
    
    // New receipt
    func addReceipt(_ newReceipt: Receipt) {
        receipts.append(newReceipt)
    }
    
    // Remove receipt
    func removeReceipt(_ receipt: Receipt) {
        if let index = receipts.firstIndex(of: receipt) {
            receipts.remove(at: index)
        }
    }
    
    // Move receipt
    func moveReceipt(from fromIndex: Int, to toIndex: Int) {
        if fromIndex == toIndex {
            return
        }
        let receiptToMove = receipts[fromIndex]
        receipts.remove(at: fromIndex)
        receipts.insert(receiptToMove, at: toIndex)
    }
    
    // -- INIT AND SAVES --
    // TODO read from storage. these are just temporary
    init(){
        
        let date = Date()
        let calendar = Calendar.current
        let startDate = calendar.startOfDay(for: date)
        let receipt = Receipt(name: "Shaws", date: startDate)
        
        let person_a = Person("Bob")
        receipt.addPerson(person_a)
        
        let person_b = Person("Dylan")
        receipt.addPerson(person_b)
        
        let person_c = Person("Jake")
        receipt.addPerson(person_c)
        
        receipt.addItem(ReceiptItem(name: "Batteries", price: 5.00, taxed: true))
        receipt.items[0].addPerson(person_a)
        receipt.items[0].addPerson(person_b)
        
        receipt.addItem(ReceiptItem(name: "Lettuce", price: 4.00, taxed: false))
        receipt.items[1].addPerson(person_a)
        receipt.items[1].addPerson(person_b)
        
        receipt.addItem(ReceiptItem(name: "Onion", price: 0.99, taxed: false))
        //receipt.items[2].addPerson(person_c)
        
        // Assume 7% tax for a second
        // Should be $0.35 tax total
        
        receipt.setTaxAmt(0.35)
        
        receipts.append(receipt)

    }
    
    
}
