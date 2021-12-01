//
//  UserCell.swift
//  SwiftSplit
//
//  Created by user203780 on 11/18/21.
//

import UIKit

class UserCell: UITableViewCell, UITextViewDelegate {
    @IBOutlet var userName: UITextField!
    @IBOutlet var deleteBtn: UIButton!
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        deleteBtn.setTitle("", for: .normal)
        
    }
}
