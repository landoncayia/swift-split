//
//  ReceiptItem.swift
//  SwiftSplit
//
//  Created by Austin Block on 10/18/21.
//

class ReceiptItem: Equatable, Codable {
    var name: String
    var price: Double
    var taxed: Bool
    
    init(name: String, price: Double, taxed: Bool) {
        self.name = name
        self.price = price
        self.taxed = taxed
    }
    
    static func ==(lhs: ReceiptItem, rhs: ReceiptItem) -> Bool {
        return lhs.name == rhs.name
            && lhs.price == rhs.price
            && lhs.taxed == rhs.taxed
    }
}
