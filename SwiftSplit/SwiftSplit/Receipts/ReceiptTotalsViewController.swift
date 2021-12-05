//
//  ReceiptTotals.swift
//  SwiftSplit
//
//  Created by user207825 on 12/1/21.
//

import UIKit
class ReceiptTotalsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // MARK: Variables
    var receipt:  Receipt!
    var totals = [ReceiptTotal]()
 
    @IBOutlet var grandTax: CurrencyField!
    @IBOutlet var grandTotal: UILabel!
    
    @IBOutlet var totalTableView: UITableView! {
        didSet {
            totalTableView.delegate = self
            totalTableView.dataSource = self
            totalTableView.rowHeight = UITableView.automaticDimension
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        totals = receipt.getTotals()
        // currencyInputFormatting is a String extension found in ReceiptViewController
        grandTax.text = String(receipt.taxAmt).currencyInputFormatting()
        grandTax.addTarget(self, action: #selector(self.taxFieldDidChange(_:)), for: .editingChanged)
        grandTotal.text = String(receipt.getWholeCost()).currencyInputFormatting()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillHide() {
        self.view.frame.origin.y = 0
    }
    
    @objc func keyboardWillChange(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if let tabBarHeight = tabBarController?.tabBar.frame.size.height {
                if grandTax.isFirstResponder {
                    self.view.frame.origin.y = -keyboardSize.height + tabBarHeight
                }
            }
        }
    }
    
    @objc func taxFieldDidChange(_ taxField: CurrencyField) {
        // Set tax amount and update the total
        receipt.setTaxAmt(taxField.doubleValue)
        grandTotal.text = String(receipt.getWholeCost()).currencyInputFormatting()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return totals.count
    }
        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = totalTableView.dequeueReusableCell(withIdentifier: "UserTotalCell", for: indexPath) as! UserTotalCell
        cell.userName.text = totals[indexPath.row].person.name
        cell.userTotal.text = String(totals[indexPath.row].amount).currencyInputFormatting()
        return cell
    }
    
    @IBAction func backgroundTapped(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
}
