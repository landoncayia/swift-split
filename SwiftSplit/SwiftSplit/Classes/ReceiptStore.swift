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
        
        if receipts.isEmpty {
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
        
        print("RECEIPT STORE LOADED")
        print("Contents: ")
        print(receipts)
    }
}
