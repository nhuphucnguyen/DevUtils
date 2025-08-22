//
//  Base64Utility.swift
//  DevUtils
//
//  Created by Claude on 22/8/25.
//

import Foundation
import Combine

class Base64Utility: ObservableObject {
    @Published var inputText = ""
    @Published var outputText = ""
    @Published var isEncoding = true
    @Published var errorMessage = ""
    
    func encode() {
        guard !inputText.isEmpty else {
            outputText = ""
            errorMessage = ""
            return
        }
        
        let data = inputText.data(using: .utf8) ?? Data()
        outputText = data.base64EncodedString()
        errorMessage = ""
    }
    
    func decode() {
        guard !inputText.isEmpty else {
            outputText = ""
            errorMessage = ""
            return
        }
        
        guard let data = Data(base64Encoded: inputText),
              let decodedString = String(data: data, encoding: .utf8) else {
            outputText = ""
            errorMessage = "Invalid Base64 input"
            return
        }
        
        outputText = decodedString
        errorMessage = ""
    }
    
    func process() {
        if isEncoding {
            encode()
        } else {
            decode()
        }
    }
    
    func toggleMode() {
        isEncoding.toggle()
        let temp = inputText
        inputText = outputText
        outputText = temp
        process()
    }
    
    func clear() {
        inputText = ""
        outputText = ""
        errorMessage = ""
    }
}