//
//  TextRecognizeViewController.swift
//  SwiftSplit
//
//  Created by Landon Cayia on 10/23/21.
//

import UIKit
import Vision
import VisionKit
import Photos
import Foundation
import CoreGraphics

class ReceiptContentsViewController: UIViewController {
    
    // Use this height value to differentiate between big labels and small labels in a receipt.
    // NOTE: I currently have this commented out because I cannot figure out how to get it to work (or if it is even necessary for our use case at all).
    //static textHeightThreshold: CGFloat = 0.035
    
    typealias ReceiptContentField = (name: String, value: String)
    
    // The information to fetch from a scanned receipt.
    struct ReceiptContents {
        
        var name: String?
        var items = [ReceiptContentField]()
    }
    
    var contents = ReceiptContents()
}

    // MARK: Double StringProtocol Extension
extension StringProtocol {
    var double: Double? { Double(self) }
}

    // MARK: RecognizedTextDataSource
extension ReceiptContentsViewController: RecognizedTextDataSource {
    func processRecognizedText(recognizedText: [VNRecognizedTextObservation]) {
        var contents = ReceiptContents()
        var currLabel: String?
        let maximumCandidates = 1
        for observation in recognizedText {
            guard let candidate = observation.topCandidates(maximumCandidates).first else { continue }
            // NOTE: Commented out for now because we aren't using textHeightThreshold
            //let isLarge = (observation.boundingBox.height >
            //    textHeightThreshold)
            var text = candidate.string
            // The value might be preceded by a qualifier (e.g A small '3x' preceding 'Additional shot'.)
            var valueQualifier: VNRecognizedTextObservation?
            
            if let label = currLabel {
                if let qualifier = valueQualifier {
                    if abs(qualifier.boundingBox.minY - observation.boundingBox.minY) < 0.01 {
                        // The qualifier's baseline is within 1% of the current observation's baseline, it must belong to the current value.
                        let qualifierCandidate = qualifier.topCandidates(1)[0]
                        text = qualifierCandidate.string + " " + text
                    }
                    valueQualifier = nil
                }
                contents.items.append((label, text))
                currLabel = nil
            } else if contents.name == nil && observation.boundingBox.minX < 0.5 && text.count >= 2 {
                // Name is located on the top-left of the receipt.
                contents.name = text
            }
            if text.starts(with: "#") {
                // Order number is the only thing that starts with #.
                contents.items.append(("Order", text))
            } else if currLabel == nil {
                currLabel = text
            } else {
                do {
                    // Create an NSDataDetector to detect whether there is a date in the string.
                    let types: NSTextCheckingResult.CheckingType = [.date]
                    let detector = try NSDataDetector(types: types.rawValue)
                    let matches = detector.matches(in: text, options: .init(), range: NSRange(location: 0, length: text.count))
                    if !matches.isEmpty {
                        contents.items.append(("Date", text))
                    } else {
                        // This observation is potentially a qualifier.
                        valueQualifier = observation
                    }
                } catch {
                    print(error)
                }
            }
        }
    }
}
