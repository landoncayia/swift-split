//
//  UserCell.swift
//  SwiftSplit
//
//  Created by user203780 on 11/18/21.
//

import UIKit

class DetailsNameCell: UITableViewCell, UITextViewDelegate {
    @IBOutlet var nameField: UITextField!
    
}

class DetailsDateCell: UITableViewCell, UITextViewDelegate {
    @IBOutlet var datePicker: UIDatePicker!
    
}

class DetailsPersonHeadingCell: UITableViewCell {
    @IBOutlet var addBtn: UIButton!
    
}

class DetailsPersonCell: UITableViewCell, UITextViewDelegate {
    @IBOutlet var userName: UITextField!
    @IBOutlet var deleteBtn: UIButton!
    
}
