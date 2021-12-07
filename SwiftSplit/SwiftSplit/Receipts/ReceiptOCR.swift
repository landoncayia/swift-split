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
    
    func processRecognizedText(recognizedText: [VNRecognizedTextObservation]) {
        
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
        convertScannedReceipt(lines)
        
    }
    
    func convertScannedReceipt(_ lines: [String]) {
        
        var items = [ReceiptItem]()
        var taxAmt = 0.0
        
        // word lists
        let balanceWords = ["balance", "subtotal", "total"]
        let ignoreWords = globalSettings.currentSettings.ignoredWords.map{$0.lowercased()}
        let wordsToIgnore = balanceWords + ignoreWords
        
        // letters for tax status
        // A for costco
        // X for walmart
        // B or T for shaws
        let taxLetters = ["A", "B", "T", "X"]
        
        for line in lines {
            
            if line.lowercased().contains("tax") {
                // Is this line the tax?
                
                // Split up the line so we can process each part
                let splitLine = line.components(separatedBy: " ")

                // Look for the tax amount in this line
                for term in splitLine {
                    if Double(term) != nil && term.contains(".") {
                        taxAmt = Double(term) ?? 0.0
                    }
                }
                
            } else if wordsToIgnore.contains(where: line.lowercased().contains) {
                // Is this line something we should ignore?
            } else {
                // This line an item
                
                // Defaults for the item
                var name = ""
                var price = 0.0
                var taxed = false
                var hasPrice = false
                
                // Split up the line so we can process each part
                var splitLine = line.components(separatedBy: " ")

                // To keep track of where parts are
                var currIdx = 0
                var priceIdx = 0
                var taxIdx = -1
                
                for var term in splitLine {
                    // Handle negatives with a "-" after the price
                    if term.last! == "-" {
                        term.removeLast()
                        term = "-" + term
                    }
                    
                    // Find the price and tax status in this line
                    if Double(term) != nil && term.contains(".") {
                        price = Double(term) ?? 0.0
                        hasPrice = true
                        priceIdx = currIdx
                    } else if (term.uppercased().count == 1 && taxLetters.contains(term.uppercased()) && (currIdx == priceIdx + 1 || currIdx == priceIdx - 1)) {
                        taxed = true
                        taxIdx = currIdx
                    }
                    currIdx += 1
                }
                
                if (hasPrice) {
                    print("item line: ", line)
                    
                    // Remove price at index
                    splitLine.remove(at: priceIdx)
                    
                    // Remove tax letter at index if needed
                    if taxIdx != -1 {
                        splitLine.remove(at: taxIdx)
                    }
                    
                    // Generate an item name
                    name = splitLine.joined(separator: " ")
                    
                    // Add the item
                    let newItem = ReceiptItem(name: name, price: price, taxed: taxed)
                    items.append(newItem)
                } else {
                    print("ignored line: ", line)
                }
                
            }

        }
        
        // Load the new values into receipt
        self.receipt.items = items
        self.receipt.setTaxAmt(taxAmt)
        
    }

}

