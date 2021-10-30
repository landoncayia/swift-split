//
//  RecognizedTextDataSource.swift
//  SwiftSplit
//
//  Created by Landon Cayia on 10/23/21.
//

import UIKit
import Vision

protocol RecognizedTextDataSource: AnyObject {
    func processRecognizedText(recognizedText: [VNRecognizedTextObservation])
}
