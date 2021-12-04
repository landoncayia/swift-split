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
            let dateFormat = DateFormatter()
            dateFormat.dateFormat = "MM/dd/yyyy"
            let d = dateFormat.date(from: "08/10/2021")
            
            
            
            
//            let date = Date()
//            let calendar = Calendar.current
//            let startDate = calendar.startOfDay(for: date)
            
            // Create a default receipt for new users
            let person_a = Person("Steve Jobs")
            let person_b = Person("Jony Ive")
            let person_c = Person("Tim Cook")
            
            let receipt = Receipt(name: "Apple", date: d!, persons: [person_a, person_b, person_c])
            
            receipt.addItem(ReceiptItem(name: "MacBook", price: 999.00, taxed: true))
            
            receipt.addItem(ReceiptItem(name: "USB-C Cable", price: 19.99, taxed: false))
            
            //receipt.items[2].addPerson(person_c)
            
            // Assume 7% tax for a second
            // Should be $0.35 tax total
            
            receipt.setTaxAmt(0.35)
            receipt.tag = 0
            receipts.append(receipt)
        }
        
    }
}
