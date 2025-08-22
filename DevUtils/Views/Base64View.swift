//
//  Base64View.swift
//  DevUtils
//
//  Created by Claude on 22/8/25.
//

import SwiftUI

struct Base64View: View {
    @StateObject private var utility = Base64Utility()
    
    var body: some View {
        VStack(spacing: 16) {
            header
            
            HStack(spacing: 16) {
                inputSection
                outputSection
            }
            
            if !utility.errorMessage.isEmpty {
                errorView
            }
            
            Spacer()
        }
        .padding()
        .onChange(of: utility.inputText) { _ in
            utility.process()
        }
        .onChange(of: utility.isEncoding) { _ in
            utility.process()
        }
    }
    
    private var header: some View {
        HStack {
            Text("Base64 Encoder/Decoder")
                .font(.title2)
                .fontWeight(.semibold)
            
            Spacer()
            
            Button(action: utility.toggleMode) {
                HStack {
                    Image(systemName: "arrow.left.arrow.right")
                    Text(utility.isEncoding ? "Switch to Decode" : "Switch to Encode")
                }
            }
            .buttonStyle(.bordered)
            
            Button("Clear", action: utility.clear)
                .buttonStyle(.bordered)
        }
    }
    
    private var inputSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(utility.isEncoding ? "Text to Encode" : "Base64 to Decode")
                .font(.headline)
                .foregroundColor(.secondary)
            
            TextEditor(text: $utility.inputText)
                .font(.system(.body, design: .monospaced))
                .padding(8)
                .background(Color(NSColor.textBackgroundColor))
                .cornerRadius(8)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.secondary.opacity(0.3), lineWidth: 1)
                )
        }
    }
    
    private var outputSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(utility.isEncoding ? "Base64 Output" : "Decoded Text")
                    .font(.headline)
                    .foregroundColor(.secondary)
                
                Spacer()
                
                if !utility.outputText.isEmpty {
                    Button("Copy") {
                        NSPasteboard.general.clearContents()
                        NSPasteboard.general.setString(utility.outputText, forType: .string)
                    }
                    .buttonStyle(.borderless)
                    .foregroundColor(.accentColor)
                }
            }
            
            ScrollView {
                Text(utility.outputText.isEmpty ? "Output will appear here..." : utility.outputText)
                    .font(.system(.body, design: .monospaced))
                    .foregroundColor(utility.outputText.isEmpty ? .secondary : .primary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(8)
                    .background(Color(NSColor.controlBackgroundColor))
                    .cornerRadius(8)
                    .textSelection(.enabled)
            }
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.secondary.opacity(0.3), lineWidth: 1)
            )
        }
    }
    
    private var errorView: some View {
        HStack {
            Image(systemName: "exclamationmark.triangle.fill")
                .foregroundColor(.orange)
            Text(utility.errorMessage)
                .foregroundColor(.orange)
            Spacer()
        }
        .padding()
        .background(Color.orange.opacity(0.1))
        .cornerRadius(8)
    }
}

#Preview {
    Base64View()
        .frame(width: 800, height: 600)
}