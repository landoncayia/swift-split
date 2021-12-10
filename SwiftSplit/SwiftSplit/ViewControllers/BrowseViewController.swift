//  BrowseViewController.swift
//  SwiftSplit

import UIKit

class BrowseViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    var filteredReceipts: [Receipt]!
    
//    @IBOutlet var editBtn: UIBarButtonItem!
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
//        view.endEditing(true)
//        editBtn.title = "Edit"
        globalReceipts.setTags()
        
        // Clears cell selection when you come from another view
//        if let indexPath = receiptTable.indexPathForSelectedRow {
//            receiptTable.deselectRow(at: indexPath, animated: true)
//        }
        
        // filteredReceipts = globalReceipts.receipts
        performSearch()
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        print("setediting")
        // Takes care of toggling the button's title.
        super.setEditing(editing, animated: true)

        // Toggle table view editing.
        receiptTable.setEditing(editing, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        searchBar.placeholder = "Search for a receipt name"
        searchBar.enablesReturnKeyAutomatically = false
        searchBar.returnKeyType = .done
        searchBar.backgroundImage = UIImage()
        performSearch()
        
        navigationItem.rightBarButtonItem = editButtonItem
//        editBtn.title = "Edit"
    }
    
    @IBAction func bkgdTapped(_ sender: UITapGestureRecognizer){
        view.endEditing(true)
    }
    
    // When a user selects a cell, it segues to the receipt details in Create
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "openReceipt" {
            if let receiptDetailsVC = segue.destination as? ReceiptDetailsController {
                receiptDetailsVC.receipt = (sender as? ReceiptCell)?.thisReceipt
                receiptDetailsVC.navigationItem.leftBarButtonItem = nil
            }
        }
    }
    
    
//    func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
//        return true
//    }
    
    
//    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
//        return true
//    }
//
//    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
//        return UITableViewCell.EditingStyle.delete
//    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath)
    -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: nil) { (_, _, completionHandler) in
            
            let receiptToDelete = self.filteredReceipts[indexPath.row]
            
            let alertController = UIAlertController(title: nil, message: "Are you sure you want to delete the receipt named \(receiptToDelete.name)?", preferredStyle: .alert)
            
            let cancel = UIAlertAction(title: "Cancel", style: .default) { _ in
                completionHandler(false)
            }
            alertController.addAction(cancel)
            
            let delete = UIAlertAction(title: "Delete", style: .destructive) { _ in
                globalReceipts.removeReceipt(self.filteredReceipts[indexPath.row])
                self.filteredReceipts = globalReceipts.receipts
                self.receiptTable.deleteRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
                completionHandler(true)
            }
            alertController.addAction(delete)
            
            self.present(alertController, animated: true, completion: nil)
            
        }
        let imageIcon = UIImage(systemName: "trash")?.withTintColor(.white, renderingMode: .alwaysOriginal)
        deleteAction.image = imageIcon
        deleteAction.backgroundColor = UIColor.red
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        return configuration
    }
    
    // Edit button onTap
//    @IBAction func toggleEdit(_ sender: UIBarButtonItem){
//        if self.receiptTable.isEditing {
//            editBtn.title = "Edit"
//            self.receiptTable.setEditing(false, animated: true)
//            if let indexPath = receiptTable.indexPathForSelectedRow {
//                receiptTable.deselectRow(at: indexPath, animated: true)
//            }
//        } else {
//            editBtn.title = "Done"
//            self.receiptTable.setEditing(true, animated: true)
//        }
//    }
    
    
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
        
        cell.preservesSuperviewLayoutMargins = false
        cell.separatorInset = UIEdgeInsets.zero
        cell.layoutMargins = UIEdgeInsets.zero
        
        return cell
        
    }
    
    func performSearch() {
        let searchText = searchBar.text ?? ""
        
        if searchText.isEmpty {
            filteredReceipts = globalReceipts.receipts
        } else {
            filteredReceipts = globalReceipts.receipts.filter {(receipt: Receipt) -> Bool in
                return receipt.name.range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil
            }
        }
        
        receiptTable.reloadData()
    }
    
    
    // Search Bar filter function
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        performSearch()
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
    
//    override func layoutSubviews() {
//
//        super.layoutSubviews()
//
//        // Adds padding between cells and rounded edges
//        let xPadding: CGFloat = 0
//        let yPadding: CGFloat = 10
//        let maskLayer = CALayer()
//        maskLayer.cornerRadius = 8
//        maskLayer.backgroundColor = UIColor.black.cgColor
//        maskLayer.frame = CGRect(x: self.bounds.origin.x, y: self.bounds.origin.y, width: self.bounds.width, height: self.bounds.height).insetBy(dx: xPadding, dy: yPadding)
//        self.layer.mask = maskLayer
//
//    }
    
    
    
}

