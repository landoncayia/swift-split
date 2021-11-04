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
    // Create a full transcript to run analysis on.
    var currLabel: String?
    let maximumCandidates = 1
    for observation in recognizedText {
        guard let candidate = observation.topCandidates(maximumCandidates).first else { continue }
        let isLarge = (observation.boundingBox.height > ReceiptViewController.textHeightThreshold)
        var text = candidate.string
        // The value might be preceded by a qualifier (e.g A small '3x' preceding 'Additional shot'.)
        var valueQualifier: VNRecognizedTextObservation?

        if isLarge {
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
        } else {
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
    tableView.reloadData()
    navigationItem.title = contents.name != nil ? contents.name : "Scanned Receipt"
}
}
