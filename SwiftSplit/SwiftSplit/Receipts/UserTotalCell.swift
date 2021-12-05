//
//  UserTotalCell.swift
//  SwiftSplit
//
//  Created by user207825 on 12/2/21.
//

import UIKit
class UserTotalCell: UITableViewCell {
    //TODO: connect
    @IBOutlet var userName: UILabel!
    @IBOutlet var userTotal: UILabel!
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        
        // Make the cell less 'selectable'
        self.selectionStyle = .none
        
        // Make the cell pretty
        let verticalPadding: CGFloat = 10
        let maskLayer = CALayer()
        maskLayer.cornerRadius = 8    //if you want round edges
        maskLayer.backgroundColor = UIColor.black.cgColor
        maskLayer.frame = CGRect(x: self.bounds.origin.x, y: self.bounds.origin.y, width: self.bounds.width, height: self.bounds.height).insetBy(dx: 0, dy: verticalPadding/2)
        self.layer.mask = maskLayer
    }
}
