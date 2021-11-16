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

extension ReceiptViewController: RecognizedTextDataSource {
    
    func processRecognizedText(recognizedText: [VNRecognizedTextObservation]) {
        
        // An array of all the observations on the page
        var locToObs = [ReceiptObservation]()
        
        // An array of all the lines on the page
        var lines = [[String]]()
        
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
            
            lines.append([thisObservation.text])

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
                    lines[lines.count-1].append(otherObservation.text)
                    locToObs = locToObs.filter({ $0 != otherObservation })
                }
            }
            
            // Remove this observation so we don't get it again
            locToObs.remove(at: 0)
        }

        // DEBUG: Temporary printing of the scanned lines
        for line in lines {
            print(line)
        }
        
        convertToReceipt()
        tableView.reloadData()
        navigationItem.title = contents.name != nil ? contents.name : "Scanned Receipt"
        
    }
}
