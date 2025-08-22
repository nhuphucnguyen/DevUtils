//
//  JWTUtility.swift
//  DevUtils
//
//  Created by Claude on 22/8/25.
//

import Foundation
import Combine

struct JWTComponent {
    let header: [String: Any]
    let payload: [String: Any]
    let signature: String
    let isValid: Bool
    let errorMessage: String?
}

class JWTUtility: ObservableObject {
    @Published var inputToken = ""
    @Published var jwtComponent: JWTComponent?
    @Published var errorMessage = ""
    
    func parseJWT() {
        guard !inputToken.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            jwtComponent = nil
            errorMessage = ""
            return
        }
        
        let token = inputToken.trimmingCharacters(in: .whitespacesAndNewlines)
        let parts = token.components(separatedBy: ".")
        
        guard parts.count == 3 else {
            jwtComponent = nil
            errorMessage = "Invalid JWT format. Expected 3 parts separated by dots."
            return
        }
        
        do {
            let header = try decodeJWTPart(parts[0])
            let payload = try decodeJWTPart(parts[1])
            let signature = parts[2]
            
            jwtComponent = JWTComponent(
                header: header,
                payload: payload,
                signature: signature,
                isValid: true,
                errorMessage: nil
            )
            errorMessage = ""
        } catch {
            jwtComponent = JWTComponent(
                header: [:],
                payload: [:],
                signature: parts.count > 2 ? parts[2] : "",
                isValid: false,
                errorMessage: error.localizedDescription
            )
            errorMessage = error.localizedDescription
        }
    }
    
    private func decodeJWTPart(_ part: String) throws -> [String: Any] {
        var base64 = part
            .replacingOccurrences(of: "-", with: "+")
            .replacingOccurrences(of: "_", with: "/")
        
        let remainder = base64.count % 4
        if remainder > 0 {
            base64 += String(repeating: "=", count: 4 - remainder)
        }
        
        guard let data = Data(base64Encoded: base64) else {
            throw JWTError.invalidBase64
        }
        
        guard let json = try JSONSerialization.jsonObject(with: data) as? [String: Any] else {
            throw JWTError.invalidJSON
        }
        
        return json
    }
    
    func clear() {
        inputToken = ""
        jwtComponent = nil
        errorMessage = ""
    }
    
    func formatJSON(_ dictionary: [String: Any]) -> String {
        do {
            let data = try JSONSerialization.data(withJSONObject: dictionary, options: [.prettyPrinted, .sortedKeys])
            return String(data: data, encoding: .utf8) ?? "Error formatting JSON"
        } catch {
            return "Error formatting JSON: \(error.localizedDescription)"
        }
    }
}

enum JWTError: LocalizedError {
    case invalidBase64
    case invalidJSON
    
    var errorDescription: String? {
        switch self {
        case .invalidBase64:
            return "Invalid Base64 encoding in JWT part"
        case .invalidJSON:
            return "Invalid JSON in JWT part"
        }
    }
}