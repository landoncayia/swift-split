//
//  Person.swift
//  SwiftSplit
//
//  Created by Austin Block on 10/18/21.
//

class Person: Equatable, Codable {
    var name: String
    
    init(_ name: String) {
        self.name = name
    }
    
    static func ==(lhs: Person, rhs: Person) -> Bool {
        return lhs.name == rhs.name
    }
}
