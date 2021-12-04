//
//  UserCell.swift
//  SwiftSplit
//
//  Created by user203780 on 11/18/21.
//

import UIKit

class DetailsPersonCell: UITableViewCell, UITextViewDelegate {
    @IBOutlet var userName: UITextField!
    @IBOutlet var deleteBtn: UIButton!
    
}


class DetailsPersonHeadingCell: UITableViewCell {
    @IBOutlet var addBtn: UIButton!
    
}

class DetailsNameCell: UITableViewCell, UITextViewDelegate {
    @IBOutlet var nameField: UITextField!
    
}

class DetailsDateCell: UITableViewCell, UITextViewDelegate {
    @IBOutlet var datePicker: UIDatePicker!
    
}
