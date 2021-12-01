//
//  SettingsStore.swift
//  SwiftSplit
//
//  Created by Landon Cayia on 11/4/21.
//

import UIKit

enum RecognitionLevel: String, Codable {
    case accurate = ".accurate", fast = ".fast"
}

struct Settings: Codable {
    // Variable for each settings item
    // FIRST SECTION (0)
    var recognitionLevel: RecognitionLevel
    var customWords: [String]
    var ignoredWords: [String]
    var languageCorrection: Bool
    
    init(recognitionLevel: RecognitionLevel, customWords: [String], ignoredWords: [String], languageCorrection: Bool) {
        self.recognitionLevel = recognitionLevel
        self.customWords = customWords
        self.ignoredWords = ignoredWords
        self.languageCorrection = languageCorrection
    }
    
    // Default settings
    init() {
        recognitionLevel = .accurate
        customWords = ["Apples", "Oranges", "Bananas"]
        ignoredWords = ["Savings", "Price", "Sale", "Coupon", "Discount"]
        languageCorrection = true
    }
}

class SettingsStore {
    
    var currentSettings = Settings()
    
    // Set up settings data plist
    let settingsArchiveURL: URL = {
        let documentsDirectories = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentDirectory = documentsDirectories.first!
        return documentDirectory.appendingPathComponent("settings.plist")
    }()
    
    init() {
        do {
            let data = try Data(contentsOf: settingsArchiveURL)
            let unarchiver = PropertyListDecoder()
            let settings = try unarchiver.decode(Settings.self, from: data)
            currentSettings = settings
            
        } catch {
            print("Error reading in saved words: \(error)")
        }
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self,
                                       selector: #selector(saveChanges),
                                       name: UIScene.didEnterBackgroundNotification,
                                       object: nil)
    }
    
    @objc func saveChanges() -> Bool {
        print("Saving items to: \(settingsArchiveURL)")
        
        do {
            let encoder = PropertyListEncoder()
            let data = try encoder.encode(currentSettings)
            try data.write(to: settingsArchiveURL, options: [.atomic])
            print("Saved all custom words.")
            return true
        } catch let encodingError {
            print("Error encoding custom words: \(encodingError)")
            return false
        }
    }
}
