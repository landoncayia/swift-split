//  BrowseViewController.swift
//  SwiftSplit

import UIKit

class BrowseViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    var receiptStore: ReceiptStore!
    var filteredReceipts: [Receipt]!
    
    @IBOutlet var searchBar: UISearchBar!
    
    // Nested table view
    @IBOutlet var receiptTable: UITableView!{
        didSet {
            receiptTable.delegate = self
            receiptTable.dataSource = self
            receiptTable.rowHeight = UITableView.automaticDimension
            receiptTable.estimatedRowHeight = 80
            
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        view.endEditing(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        searchBar.placeholder = "Search for a receipt name"
        searchBar.enablesReturnKeyAutomatically = false
        searchBar.returnKeyType = .done
        filteredReceipts = receiptStore.receipts
        print("Browse view controller loaded")
    }
 
    @IBAction func bkgdTapped(_ sender: UITapGestureRecognizer){
        view.endEditing(true)
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
            

        let dateFormat = DateFormatter()
        dateFormat.locale = Locale(identifier: "en_US")
            
        // TODO: uncomment the receipt line when date gets fixed
            
        let date = Date()
        dateFormat.dateFormat = "MM/dd/yyyy"
        let today = dateFormat.string(from: date)
        
        if today == dateFormat.string(from: receipt.date){
            dateFormat.dateFormat = "hh:mm a"
            cell.dateLabel.text = "Today @ \(dateFormat.string(from: date))"
        } else {
            //cell.dateLabel.text = dateFormat.string(from: receipt.date)
            cell.dateLabel.text = dateFormat.string(from: date)
        }
            
        cell.layer.borderColor = CGColor(red: 255, green: 255, blue: 255, alpha: 255)
        cell.layer.borderWidth = 1.0
        cell.layer.cornerRadius = 8
        cell.clipsToBounds = true
        
            
        return cell
        
    }
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // Code from - https://guides.codepath.com/ios/Search-Bar-Guide
        filteredReceipts = searchText.isEmpty ? receiptStore.receipts : receiptStore.receipts.filter { (receipt: Receipt) ->
            Bool in
            return receipt.name.range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil
        }
        receiptTable.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        // Close keyboard
        view.endEditing(true)
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) { print("Began editing") }
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) { print("Stopped editing") }
}

class ReceiptCell: UITableViewCell {
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var costLabel: UILabel!
}
