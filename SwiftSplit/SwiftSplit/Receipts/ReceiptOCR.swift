//
//  ReceiptOCR.swift
//  SwiftSplit
//
//  Created by Austin Block on 11/4/21.
//

import Vision
import VisionKit
import Photos
import Foundation
import CoreGraphics

extension ReceiptViewController {
    
    func processRecognizedText(recognizedText: [VNRecognizedTextObservation])  -> [ReceiptItem] {
        
        // An array of all the observations on the page
        var locToObs = [ReceiptObservation]()
        
        // An array of all the lines on the page
        var lines = [String]()
        
        let maximumCandidates = 1
        
        // Step 1: Loop through all observations and put them into a dictionary
        for observation in recognizedText {
            
            guard let candidate = observation.topCandidates(maximumCandidates).first else { continue }

            let text = candidate.string
            
            let bottomOfLine = observation.boundingBox.minY
            let topOfLine = observation.boundingBox.maxY
            let newObs = ReceiptObservation(minY: bottomOfLine, maxY: topOfLine, text: text)
                
            locToObs.append(newObs)
            
        }
        
        // Step 2: Match up observations by line
        while (!locToObs.isEmpty) {

            // Store temp
            let thisObservation = locToObs[0]
            
            lines.append(thisObservation.text)

            // Filter out every observation NOT on this line
            let filteredObservations = locToObs.filter({
                let minYDiff = abs($0.minY - thisObservation.minY)
                let maxYDiff = abs($0.maxY - thisObservation.maxY)
                let someBound = 0.5 * abs(thisObservation.maxY - thisObservation.minY)
                let sameKey = ($0 == thisObservation)
                return ((minYDiff < someBound) && (maxYDiff < someBound) && !sameKey)
            })
            
            // Append observations that ARE on this line, to that line's respective array
            if (!filteredObservations.isEmpty) {
                for n in 0...filteredObservations.count-1 {
                    let otherObservation = filteredObservations[n]
                    lines[lines.count-1] = lines[lines.count-1] + " " + otherObservation.text
                    // lines[lines.count-1].append(otherObservation.text)
                    locToObs = locToObs.filter({ $0 != otherObservation })
                }
            }
            
            // Remove this observation so we don't get it again
            locToObs.remove(at: 0)
        }

        // DEBUG: Temporary printing of the scanned lines
//        for line in lines {
//            print(line)
//        }
        
        return convertScannedReceipt(lines)
//        convertToReceipt()
//        tableView.reloadData()
//        navigationItem.title = contents.name != nil ? contents.name : "Scanned Receipt"
        
    }
}

func convertScannedReceipt(_ lines: [String]) -> [ReceiptItem] {
    
    var items = [ReceiptItem]()
    
    // words to ignore
    let wordsToIgnore = globalSettings.currentSettings.ignoredWords
    
    // letters for tax status
    // A for costco
    // X for walmart
    // B or T for shaws
    let taxLetters = ["A", "B", "T", "X"]
    
    for line in lines {
        // Check if this is an item by looking for a name and price
        
        // Defaults for the item
        var name = ""
        var price = 0.0
        var taxed = false
        
        var hasPrice = false
        var isItem = true
        
        let splitLine = line.components(separatedBy: " ")
        
        var currIdx = 0
        var priceIdx = 0
        
        for term in splitLine {
            // TODO add regex to remove anything other than number, letter, or period

            if wordsToIgnore.contains(term.lowercased()) {
                // This line contains a word that means we should ignore the whole thing
                isItem = false
            } else if Double(term) != nil && term.contains(".") {
                
                //print("Found double: ", term, "at index", currIdx)
                priceIdx = currIdx
                hasPrice = true
                
            } else if (term.uppercased().count == 1 && taxLetters.contains(term.uppercased())) {
                taxed = true
            }
            
            currIdx += 1

        }
        
        if (isItem && hasPrice) {
            
            name = splitLine[0 ..< priceIdx].joined(separator: " ")
            price = Double(splitLine[priceIdx]) ?? 0.0
            
            // DEBUG
            // print("name:", name, ", price:", price, ", taxed:", taxed, "\n")

            // Add the item
            let newItem = ReceiptItem(name: name, price: price, taxed: taxed)
            items.append(newItem)
        }
    }
    
    // Return an array of receipt items, to put into the receipt
    return items
    
}
