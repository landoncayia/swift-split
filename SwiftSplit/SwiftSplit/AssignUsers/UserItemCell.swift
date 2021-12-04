//
//  UserItemCell.swift
//  SwiftSplit
//
//  Created by Austin Block on 12/1/21.
//

import UIKit
class UserItemCell: UITableViewCell {
    
    @IBOutlet var itemName: UILabel!
    
    // So you can see "selected" cells
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        self.accessoryType = selected ? .checkmark : .none
    }
}
