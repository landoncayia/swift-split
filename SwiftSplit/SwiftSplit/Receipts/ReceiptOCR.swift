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
        
        to do: create hashable struct type containing two Ints
        
        var observationToLocation = [String:(Double,Double)]()
        
        var lines = [[String]]()
        
        let maximumCandidates = 1
        
        // Loop through all observations
        for observation in recognizedText {
            
            guard let candidate = observation.topCandidates(maximumCandidates).first else { continue }
            
            // Ignore "title" of receipt
            let isLarge = (observation.boundingBox.height > ReceiptViewController.textHeightThreshold)
            
            if !isLarge {
                
                // Get text from this observations
                let text = candidate.string
                
//                print("observaton text is:", text)
//                print("bounding box min:", observation.boundingBox.minX, ",", observation.boundingBox.minY)
//                print("bounding box max:", observation.boundingBox.maxX, ",", observation.boundingBox.maxY)
                
                let bottomOfLine = observation.boundingBox.minY
                let topOfLine = observation.boundingBox.maxY
                observationToLocation[text] = (Double(bottomOfLine), Double(topOfLine))
                
//                // Does the observation start on the left half of receipt?
//                if observation.boundingBox.minX < 0.5 {
//                    let bottomOfLine = observation.boundingBox.minY
//                    let topOfLine = observation.boundingBox.maxY
//                    lines[text] = (Double(bottomOfLine), Double(topOfLine))
//                }
                
            }
            
        }
        
        var count = 0
        
        // Post processing, match up things on the lines
        
        for (observation, observationLocation) in observationToLocation {
            
            let thisObservation = observation
            let thisObservationLocation = observationLocation
            
            // Remove this observation so we don't get it again (inside the second for loop)
            observationToLocation.removeValue(forKey: observation)
            
            lines.append([thisObservation])
            
            for (otherObservation, otherObservationLocation) in observationToLocation {
                
                let thisOtherObservation = otherObservation
                let thisOtherObservationLocation = otherObservationLocation
                
                let minYDiff = abs(thisObservationLocation.0 - thisOtherObservationLocation.0)
                let maxYDiff = abs(thisObservationLocation.1 - thisOtherObservationLocation.1)
                
                if ((minYDiff < 0.01) && (maxYDiff < 0.01)) {
                    // otherObservation is on the same line as thisObservation
                    // Add to array (lines)
                    
                    lines[count].append(thisOtherObservation)
                    
                    // Remove otherObservation from dict
                    
                    observationToLocation.removeValue(forKey: otherObservation)
                }
                
            }
            
            count = count + 1
            
            
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
