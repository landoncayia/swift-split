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
    // TODO
    
}
