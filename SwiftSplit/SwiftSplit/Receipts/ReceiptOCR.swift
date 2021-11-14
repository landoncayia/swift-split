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

// MARK: RecognizedTextDataSource
extension ReceiptViewController: RecognizedTextDataSource {
    
    func processRecognizedText(recognizedText: [VNRecognizedTextObservation]) {
        
        // Create a dictionary
        // observation_content: (min_y, max_y)
        
        var locToObs = [ReceiptObservation]()
        // var observationToLocation = [String:(Double,Double)]()
        
        var lines = [[String]]()
        
        let maximumCandidates = 1
        
        // Step 1: Loop through all observations and put them into a dictionary
        for observation in recognizedText {
            
            guard let candidate = observation.topCandidates(maximumCandidates).first else { continue }
            
            // Ignore "title" of receipt
//            let isLarge = (observation.boundingBox.height > ReceiptViewController.textHeightThreshold)
            
//            if !isLarge {
                
                // Get text from this observations
                let text = candidate.string
                
//                print("observaton text is:", text)
//                print("bounding box min:", observation.boundingBox.minX, ",", observation.boundingBox.minY)
//                print("bounding box max:", observation.boundingBox.maxX, ",", observation.boundingBox.maxY)
                
                let bottomOfLine = observation.boundingBox.minY
                let topOfLine = observation.boundingBox.maxY
                let newObs = ReceiptObservation(minY: bottomOfLine, maxY: topOfLine, text: text)
                
            locToObs.append(newObs)
                
//                // Does the observation start on the left half of receipt?
//                if observation.boundingBox.minX < 0.5 {
//                    let bottomOfLine = observation.boundingBox.minY
//                    let topOfLine = observation.boundingBox.maxY
//                    lines[text] = (Double(bottomOfLine), Double(topOfLine))
//                }
//
//            }
            
        }
        
        // Step 2: Match up dictionary entries
        while (!locToObs.isEmpty) {

            // Store temp
            let thisObservation = locToObs[0]
            
            lines.append([thisObservation.text])

            let filteredObservations = locToObs.filter({
                let minYDiff = abs($0.minY - thisObservation.minY)
                let maxYDiff = abs($0.maxY - thisObservation.maxY)
                let someBound = 0.5 * abs(thisObservation.maxY - thisObservation.minY)
                let sameKey = ($0 == thisObservation)
                return ((minYDiff < someBound) && (maxYDiff < someBound) && !sameKey)
            })
            
            if (!filteredObservations.isEmpty) {
                for n in 0...filteredObservations.count-1 {
                    let otherObservation = filteredObservations[n]
                    lines[lines.count-1].append(otherObservation.text)
                    locToObs = locToObs.filter({ $0 != otherObservation })
                }
            }
            
            // Remove this observation so we don't get it again (inside the second for loop)
            locToObs.remove(at: 0)
        }

        for line in lines {
            print(line)
        }
        
        
        //    // Create a full transcript to run analysis on.
        //    var currLabel: String?
        //    let maximumCandidates = 1
        //    for observation in recognizedText {
        //        guard let candidate = observation.topCandidates(maximumCandidates).first else { continue }
        //        let isLarge = (observation.boundingBox.height > ReceiptViewController.textHeightThreshold)
        //        var text = candidate.string
        //
        //
        //
        //        // The value might be preceded by a qualifier (e.g A small '3x' preceding 'Additional shot'.)
        //        var valueQualifier: VNRecognizedTextObservation?
        //
        //        if isLarge {
        //            if let label = currLabel {
        //                if let qualifier = valueQualifier {
        //                    if abs(qualifier.boundingBox.minY - observation.boundingBox.minY) < 0.01 {
        //                        // The qualifier's baseline is within 1% of the current observation's baseline, it must belong to the current value.
        //                        let qualifierCandidate = qualifier.topCandidates(1)[0]
        //                        text = qualifierCandidate.string + " " + text
        //                    }
        //                    valueQualifier = nil
        //                }
        //
        //                contents.items.append((label, text))
        //                currLabel = nil
        //            } else if contents.name == nil && observation.boundingBox.minX < 0.5 && text.count >= 2 {
        //                // Name is located on the top-left of the receipt.
        //                contents.name = text
        //            }
        //        } else {
        //            if text.starts(with: "#") {
        //                // Order number is the only thing that starts with #.
        //                contents.items.append(("Order", text))
        //            } else if currLabel == nil {
        //                currLabel = text
        //            } else {
        //                do {
        //                    // Create an NSDataDetector to detect whether there is a date in the string.
        //                    let types: NSTextCheckingResult.CheckingType = [.date]
        //                    let detector = try NSDataDetector(types: types.rawValue)
        //                    let matches = detector.matches(in: text, options: .init(), range: NSRange(location: 0, length: text.count))
        //                    if !matches.isEmpty {
        //                        contents.items.append(("Date", text))
        //                    } else {
        //                        // This observation is potentially a qualifier.
        //                        valueQualifier = observation
        //                    }
        //                } catch {
        //                    print(error)
        //                }
        //
        //            }
        //        }
        //    }
        //    tableView.reloadData()
        //    navigationItem.title = contents.name != nil ? contents.name : "Scanned Receipt"
    }
}
