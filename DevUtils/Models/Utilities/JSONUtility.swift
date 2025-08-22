//
//  JSONUtility.swift
//  DevUtils
//
//  Created by Claude on 22/8/25.
//

import Foundation
import Combine

class JSONUtility: ObservableObject {
    @Published var inputText = ""
    @Published var outputText = ""
    @Published var isValid = false
    @Published var errorMessage = ""
    @Published var indentLevel = 2
    
    func formatJSON() {
        guard !inputText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            outputText = ""
            isValid = false
            errorMessage = ""
            return
        }
        
        let trimmedInput = inputText.trimmingCharacters(in: .whitespacesAndNewlines)
        
        do {
            guard let data = trimmedInput.data(using: .utf8) else {
                throw JSONError.invalidEncoding
            }
            
            let jsonObject = try JSONSerialization.jsonObject(with: data, options: [])
            
            var options: JSONSerialization.WritingOptions = [.prettyPrinted, .sortedKeys]
            if #available(macOS 10.15, *) {
                options.insert(.withoutEscapingSlashes)
            }
            
            let formattedData = try JSONSerialization.data(withJSONObject: jsonObject, options: options)
            
            guard var formattedString = String(data: formattedData, encoding: .utf8) else {
                throw JSONError.invalidEncoding
            }
            
            if indentLevel != 2 {
                formattedString = adjustIndentation(formattedString, to: indentLevel)
            }
            
            outputText = formattedString
            isValid = true
            errorMessage = ""
            
        } catch {
            outputText = ""
            isValid = false
            if let jsonError = error as? JSONError {
                errorMessage = jsonError.localizedDescription
            } else {
                errorMessage = "Invalid JSON: \(error.localizedDescription)"
            }
        }
    }
    
    func minifyJSON() {
        guard !inputText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            outputText = ""
            isValid = false
            errorMessage = ""
            return
        }
        
        let trimmedInput = inputText.trimmingCharacters(in: .whitespacesAndNewlines)
        
        do {
            guard let data = trimmedInput.data(using: .utf8) else {
                throw JSONError.invalidEncoding
            }
            
            let jsonObject = try JSONSerialization.jsonObject(with: data, options: [])
            
            var options: JSONSerialization.WritingOptions = []
            if #available(macOS 10.15, *) {
                options.insert(.withoutEscapingSlashes)
            }
            
            let minifiedData = try JSONSerialization.data(withJSONObject: jsonObject, options: options)
            
            guard let minifiedString = String(data: minifiedData, encoding: .utf8) else {
                throw JSONError.invalidEncoding
            }
            
            outputText = minifiedString
            isValid = true
            errorMessage = ""
            
        } catch {
            outputText = ""
            isValid = false
            if let jsonError = error as? JSONError {
                errorMessage = jsonError.localizedDescription
            } else {
                errorMessage = "Invalid JSON: \(error.localizedDescription)"
            }
        }
    }
    
    func validateOnly() {
        guard !inputText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            outputText = ""
            isValid = false
            errorMessage = ""
            return
        }
        
        let trimmedInput = inputText.trimmingCharacters(in: .whitespacesAndNewlines)
        
        do {
            guard let data = trimmedInput.data(using: .utf8) else {
                throw JSONError.invalidEncoding
            }
            
            _ = try JSONSerialization.jsonObject(with: data, options: [])
            
            outputText = "✅ Valid JSON"
            isValid = true
            errorMessage = ""
            
        } catch {
            outputText = ""
            isValid = false
            if let jsonError = error as? JSONError {
                errorMessage = jsonError.localizedDescription
            } else {
                errorMessage = "Invalid JSON: \(error.localizedDescription)"
            }
        }
    }
    
    private func adjustIndentation(_ json: String, to spaces: Int) -> String {
        let lines = json.components(separatedBy: .newlines)
        var result: [String] = []
        
        for line in lines {
            let trimmedLine = line.trimmingCharacters(in: .whitespaces)
            if trimmedLine.isEmpty {
                result.append("")
                continue
            }
            
            let leadingSpaces = line.prefix { $0 == " " }.count
            let indentLevel = leadingSpaces / 2
            let newIndent = String(repeating: " ", count: indentLevel * spaces)
            
            result.append(newIndent + trimmedLine)
        }
        
        return result.joined(separator: "\n")
    }
    
    func clear() {
        inputText = ""
        outputText = ""
        isValid = false
        errorMessage = ""
    }
    
    func swapInputOutput() {
        let temp = inputText
        inputText = outputText
        outputText = temp
    }
}

enum JSONError: LocalizedError {
    case invalidEncoding
    
    var errorDescription: String? {
        switch self {
        case .invalidEncoding:
            return "Unable to encode/decode text as UTF-8"
        }
    }
}