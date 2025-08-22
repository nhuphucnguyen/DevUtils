//
//  JWTView.swift
//  DevUtils
//
//  Created by Claude on 22/8/25.
//

import SwiftUI

struct JWTView: View {
    @StateObject private var utility = JWTUtility()
    
    var body: some View {
        VStack(spacing: 16) {
            header
            
            tokenInputSection
            
            if let component = utility.jwtComponent, component.isValid {
                ScrollView {
                    VStack(spacing: 16) {
                        headerSection(component.header)
                        payloadSection(component.payload)
                        signatureSection(component.signature)
                    }
                }
            }
            
            if !utility.errorMessage.isEmpty {
                errorView
            }
            
            Spacer()
        }
        .padding()
        .onChange(of: utility.inputToken) { _ in
            utility.parseJWT()
        }
    }
    
    private var header: some View {
        HStack {
            Text("JWT Token Viewer")
                .font(.title2)
                .fontWeight(.semibold)
            
            Spacer()
            
            Button("Clear", action: utility.clear)
                .buttonStyle(.bordered)
        }
    }
    
    private var tokenInputSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("JWT Token")
                .font(.headline)
                .foregroundColor(.secondary)
            
            TextEditor(text: $utility.inputToken)
                .font(.system(.body, design: .monospaced))
                .padding(8)
                .background(Color(NSColor.textBackgroundColor))
                .cornerRadius(8)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.secondary.opacity(0.3), lineWidth: 1)
                )
                .frame(height: 100)
        }
    }
    
    private func headerSection(_ header: [String: Any]) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("Header")
                    .font(.headline)
                    .foregroundColor(.secondary)
                
                Spacer()
                
                Button("Copy") {
                    NSPasteboard.general.clearContents()
                    NSPasteboard.general.setString(utility.formatJSON(header), forType: .string)
                }
                .buttonStyle(.borderless)
                .foregroundColor(.accentColor)
            }
            
            Text(utility.formatJSON(header))
                .font(.system(.body, design: .monospaced))
                .padding(12)
                .background(Color.blue.opacity(0.1))
                .cornerRadius(8)
                .textSelection(.enabled)
        }
    }
    
    private func payloadSection(_ payload: [String: Any]) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("Payload")
                    .font(.headline)
                    .foregroundColor(.secondary)
                
                Spacer()
                
                if let exp = payload["exp"] as? TimeInterval {
                    let date = Date(timeIntervalSince1970: exp)
                    let isExpired = date < Date()
                    Text(isExpired ? "Expired" : "Valid")
                        .font(.caption)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 2)
                        .background(isExpired ? Color.red : Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(4)
                }
                
                Button("Copy") {
                    NSPasteboard.general.clearContents()
                    NSPasteboard.general.setString(utility.formatJSON(payload), forType: .string)
                }
                .buttonStyle(.borderless)
                .foregroundColor(.accentColor)
            }
            
            Text(utility.formatJSON(payload))
                .font(.system(.body, design: .monospaced))
                .padding(12)
                .background(Color.green.opacity(0.1))
                .cornerRadius(8)
                .textSelection(.enabled)
        }
    }
    
    private func signatureSection(_ signature: String) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("Signature")
                    .font(.headline)
                    .foregroundColor(.secondary)
                
                Spacer()
                
                Button("Copy") {
                    NSPasteboard.general.clearContents()
                    NSPasteboard.general.setString(signature, forType: .string)
                }
                .buttonStyle(.borderless)
                .foregroundColor(.accentColor)
            }
            
            Text(signature)
                .font(.system(.body, design: .monospaced))
                .padding(12)
                .background(Color.orange.opacity(0.1))
                .cornerRadius(8)
                .textSelection(.enabled)
        }
    }
    
    private var errorView: some View {
        HStack {
            Image(systemName: "exclamationmark.triangle.fill")
                .foregroundColor(.red)
            Text(utility.errorMessage)
                .foregroundColor(.red)
            Spacer()
        }
        .padding()
        .background(Color.red.opacity(0.1))
        .cornerRadius(8)
    }
}

#Preview {
    JWTView()
        .frame(width: 800, height: 600)
}