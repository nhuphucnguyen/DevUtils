//
//  JSONView.swift
//  DevUtils
//
//  Created by Claude on 22/8/25.
//

import SwiftUI

struct JSONView: View {
    @StateObject private var utility = JSONUtility()
    
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
        .onChange(of: utility.inputText) {
            if !utility.inputText.isEmpty {
                utility.formatJSON()
            } else {
                utility.clear()
            }
        }
        .onChange(of: utility.indentLevel) {
            if !utility.inputText.isEmpty && utility.isValid {
                utility.formatJSON()
            }
        }
    }
    
    private var header: some View {
        VStack(spacing: 12) {
            HStack {
                Text("JSON Formatter")
                    .font(.title2)
                    .fontWeight(.semibold)
                
                Spacer()
                
                Button("Clear", action: utility.clear)
                    .buttonStyle(.bordered)
            }
            
            HStack(spacing: 12) {
                Button("Format") {
                    utility.formatJSON()
                }
                .buttonStyle(.borderedProminent)
                
                Button("Minify") {
                    utility.minifyJSON()
                }
                .buttonStyle(.bordered)
                
                Button("Validate") {
                    utility.validateOnly()
                }
                .buttonStyle(.bordered)
                
                Button("Swap ⇄") {
                    utility.swapInputOutput()
                }
                .buttonStyle(.bordered)
                
                Spacer()
                
                HStack(spacing: 6) {
                    Text("Indent:")
                        .foregroundColor(.secondary)
                        .font(.caption)
                        .fixedSize()
                    
                    Picker("", selection: $utility.indentLevel) {
                        Text("2").tag(2)
                        Text("4").tag(4)
                        Text("⇥").tag(8)
                    }
                    .pickerStyle(.segmented)
                    .frame(width: 100)
                    .labelsHidden()
                }
            }
        }
    }
    
    private var inputSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("JSON Input")
                .font(.headline)
                .foregroundColor(.secondary)
            
            TextEditor(text: $utility.inputText)
                .font(.system(.body, design: .monospaced))
                .padding(8)
                .background(Color(NSColor.textBackgroundColor))
                .cornerRadius(8)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(utility.isValid ? Color.green : (utility.errorMessage.isEmpty ? Color.secondary.opacity(0.3) : Color.red), lineWidth: 1)
                )
        }
    }
    
    private var outputSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("Formatted Output")
                    .font(.headline)
                    .foregroundColor(.secondary)
                
                if utility.isValid {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.green)
                }
                
                Spacer()
                
                if !utility.outputText.isEmpty && utility.outputText != "✅ Valid JSON" {
                    Button("Copy") {
                        NSPasteboard.general.clearContents()
                        NSPasteboard.general.setString(utility.outputText, forType: .string)
                    }
                    .buttonStyle(.borderless)
                    .foregroundColor(.accentColor)
                }
            }
            
            ScrollView {
                Text(utility.outputText.isEmpty ? "Formatted JSON will appear here..." : utility.outputText)
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
    JSONView()
        .frame(width: 800, height: 600)
}