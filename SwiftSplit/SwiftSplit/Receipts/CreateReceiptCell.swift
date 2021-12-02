//
//  ReceiptCell.swift
//  SwiftSplit
//
//  Created by Austin Block on 11/4/21.
//

import UIKit
class CreateReceiptCell: UITableViewCell {
    @IBOutlet var itemName: UITextField!
    @IBOutlet var itemPrice: CurrencyField!
    @IBOutlet var taxSwitch: UISwitch!
    @IBOutlet var deleteBtn: UIButton!
}
