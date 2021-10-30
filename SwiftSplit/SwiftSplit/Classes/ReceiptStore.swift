//
//  ReceiptStore.swift
//  SwiftSplit
//
//  Created by Austin Block on 10/18/21.
//

import UIKit
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
        
        //for _ in 0...4 {
            let receipt = Receipt(name: "Test1", date: .init())
            receipt.addPerson(Person("Bob"))
            receipt.addPerson(Person("Dylan"))
            receipt.addItem(ReceiptItem(name: "Batteries", price: 20.00, taxed: false))
            receipts.append(receipt)
        //}
    }
    
    
}
