//  BrowseViewController.swift
//  SwiftSplit

import UIKit

class BrowseViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    var filteredReceipts: [Receipt]!

    @IBOutlet var editBar: UIBarButtonItem!
    @IBOutlet var editBtn: UIButton!
    @IBOutlet var searchBar: UISearchBar!
        
    // Nested collection view
    @IBOutlet var receiptTable: UITableView!{
        didSet {
            receiptTable.delegate = self
            receiptTable.dataSource = self
            receiptTable.rowHeight = UITableView.automaticDimension
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        view.endEditing(true)
        editBtn.setTitle("Edit", for: .normal)
        globalReceipts.setTags()
        
        // Clears cell selection when you come from another view
        if let indexPath = receiptTable.indexPathForSelectedRow {
            receiptTable.deselectRow(at: indexPath, animated: true)
        }
        
        filteredReceipts = globalReceipts.receipts
        receiptTable.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        searchBar.placeholder = "Search for a receipt name"
        searchBar.enablesReturnKeyAutomatically = false
        searchBar.returnKeyType = .done
        filteredReceipts = globalReceipts.receipts
        editBtn.setTitle("Edit", for: .normal)
        navigationItem.setRightBarButtonItems([editBar], animated: false)
    }
 
    @IBAction func bkgdTapped(_ sender: UITapGestureRecognizer){
        view.endEditing(true)
    }

    // When a user selects a cell, it segues to the receipt details in Create
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       if segue.identifier == "openReceipt" {
           if let receiptDetailsVC = segue.destination as? CreateViewController {
               receiptDetailsVC.receipt = (sender as? ReceiptCell)?.thisReceipt
               receiptDetailsVC.navigationItem.leftBarButtonItem = nil
           }
       }
    }

    
    func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        self.receiptTable.setEditing(editing, animated: animated)
    }
    
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return UITableViewCell.EditingStyle.delete
    }

    // Delete a row
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            let receiptToDelete = filteredReceipts[indexPath.row]
            
            
            let alertController = UIAlertController(title: nil, message: "Are you sure you want to delete the receipt named \(receiptToDelete.name)?", preferredStyle: .alert)
            
            let delete = UIAlertAction(title: "Delete", style: .default) { _ in
                globalReceipts.removeReceipt(self.filteredReceipts[indexPath.row])
                self.filteredReceipts = globalReceipts.receipts
                self.receiptTable.deleteRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
            }
            alertController.addAction(delete)
            
            let cancel = UIAlertAction(title: "Cancel", style: .default)
            alertController.addAction(cancel)
            
            present(alertController, animated: true, completion: nil)
        }
    }
    
    // Edit button onTap
    @IBAction func toggleEdit(_ sender: UIButton){
        if isEditing {
            editBtn.setTitle("Edit", for: .normal)
            setEditing(false, animated: true)
            if let indexPath = receiptTable.indexPathForSelectedRow {
                receiptTable.deselectRow(at: indexPath, animated: true)
            }
        } else {
            editBtn.setTitle("Done", for: .normal)
            setEditing(true, animated: true)
        }
    }
    

    // Return num of rows in a section of the view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredReceipts.count
    }
    
    // Insert a cell at a location in the view
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReceiptCell", for: indexPath) as! ReceiptCell

        let receipt = filteredReceipts[indexPath.row]

        let cost = String(format: "%.2f", receipt.getWholeCost())

        cell.nameLabel.text = receipt.name
        cell.costLabel.text = "$\(cost)"
        cell.thisReceipt = receipt

        let dateFormat = DateFormatter()
        dateFormat.locale = Locale(identifier: "en_US")
        dateFormat.dateFormat = "MM/dd/yyyy"
        cell.dateLabel.text = dateFormat.string(from: receipt.date)

        return cell

    }
    

    // Search Bar filter function
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchText.isEmpty {
            filteredReceipts = globalReceipts.receipts
        } else {
            filteredReceipts = globalReceipts.receipts.filter {(receipt: Receipt) -> Bool in
                return receipt.name.range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil
            }
        }
        
        receiptTable.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
    }
}

class ReceiptCell: UITableViewCell {
    var thisReceipt: Receipt!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var costLabel: UILabel!
    
    override func layoutSubviews() {
    
        super.layoutSubviews()
        
        // Adds padding between cells and rounded edges
        let verticalPadding: CGFloat = 10
        let maskLayer = CALayer()
        maskLayer.cornerRadius = 8
        maskLayer.backgroundColor = UIColor.black.cgColor
        maskLayer.frame = CGRect(x: self.bounds.origin.x, y: self.bounds.origin.y, width: self.bounds.width, height: self.bounds.height).insetBy(dx: 0, dy: verticalPadding/2)
        self.layer.mask = maskLayer
    }
}
