//
//  BudgetItem.swift
//  SwiftSplit
//
//  Created by Austin Block on 10/30/21.
//

import UIKit

class BudgetItem {
    var person: Person
    var amount: Double
    
    init(person: Person, amount: Double) {
        self.person = person
        self.amount = amount
    }
    
}
