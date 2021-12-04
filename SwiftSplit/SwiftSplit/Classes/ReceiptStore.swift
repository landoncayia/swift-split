//
//  ReceiptStore.swift
//  SwiftSplit
//
//  Created by Austin Block on 10/18/21.
//

import UIKit
import Foundation

public class ReceiptStore {
    var receipts = [Receipt]()
    let receiptsURL: URL = {
        let documentDirectories = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentDirectory = documentDirectories.first!
        return documentDirectory.appendingPathComponent("receipts.plist")
    }()
    
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
    
    
    // Read from receipts.plist
    func loadReceipts(){
        do {
            let data = try Data(contentsOf: receiptsURL)
            let decoder = PropertyListDecoder()
            let store = try decoder.decode([Receipt].self, from: data)
            receipts = store
            
        } catch {
            print("Party failed to load: \(error)")
        }
    }
    
    // Resets tags
    func setTags(){
        var cnt = 0
        for r in self.receipts {
            r.tag = cnt
            cnt += 1
        }
    }
    
    // Stores to receipts.plist
    @objc func saveReceipts() -> Bool{
        print("Attempting save to \(receiptsURL)")
        do {
            let encoder = PropertyListEncoder()
            let data = try encoder.encode(receipts)
            try data.write(to: receiptsURL, options: [.atomic])
            print("Receipts save successful")
            return true
        } catch let encodingError{
            print("Error saving receipts: \(encodingError)")
            return false
        }
    }

    
    // -- INIT AND SAVES --
    init(){
        let notifCenter = NotificationCenter.default
        notifCenter.addObserver(self, selector: #selector(saveReceipts), name: UIScene.didEnterBackgroundNotification, object: nil)
        
        loadReceipts()
        setTags()
        
        if receipts.isEmpty {
            
            // Create a default receipt for new users
            let person_a = Person("Steve Jobs")
            let person_b = Person("Jony Ive")
            let person_c = Person("Tim Cook")
            
            let item_a = ReceiptItem(name: "Apples", price: 1.99, taxed: false)
            let item_b = ReceiptItem(name: "Bananas", price: 1.99, taxed: false)
            let item_c = ReceiptItem(name: "Lemons", price: 0.99, taxed: false)
            let item_d = ReceiptItem(name: "Toothbrush", price: 2.99, taxed: true)
            let item_e = ReceiptItem(name: "Toothpaste", price: 3.99, taxed: true)
            
            item_a.persons = [person_a, person_b, person_c]
            item_b.persons = [person_a, person_b, person_c]
            item_c.persons = [person_a, person_c]
            
            item_d.persons = [person_b]
            item_e.persons = [person_b]
            
            let receipt = Receipt(name: "Sample", date: Date(), persons: [person_a, person_b, person_c])
            
            receipt.addItem(item_a)
            receipt.addItem(item_b)
            receipt.addItem(item_c)
            receipt.addItem(item_d)
            receipt.addItem(item_e)
            
            receipt.setTaxPercent(0.06)
            
            receipt.tag = 0
            receipts.append(receipt)
        }
        
        print("RECEIPT STORE LOADED")
        print("Contents: ")
        print(receipts)
    }
}
