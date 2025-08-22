//
//  WindowManager.swift
//  DevUtils
//
//  Created by Claude on 22/8/25.
//

import AppKit
import SwiftUI

class WindowManager: NSObject {
    private var window: NSWindow?
    private let appState: AppState
    
    init(appState: AppState) {
        self.appState = appState
        super.init()
        setupWindow()
    }
    
    private func setupWindow() {
        window = NSWindow(
            contentRect: appState.windowFrame,
            styleMask: [.titled, .closable, .miniaturizable, .resizable],
            backing: .buffered,
            defer: false
        )
        
        window?.title = "DevUtils"
        window?.isReleasedWhenClosed = false
        window?.delegate = self
        window?.center()
        
        // Hide from dock and make window float above other apps
        NSApp.setActivationPolicy(.accessory)
        window?.level = .floating
        
        // Make window appear in all spaces
        window?.collectionBehavior = [.canJoinAllSpaces, .fullScreenAuxiliary]
    }
    
    func setContentView<Content: View>(@ViewBuilder content: () -> Content) {
        window?.contentView = NSHostingView(rootView: content())
    }
    
    func showWindow() {
        guard let window = window else { return }
        
        if !window.isVisible {
            window.setFrame(appState.windowFrame, display: true)
            window.makeKeyAndOrderFront(nil)
            NSApp.activate(ignoringOtherApps: true)
        } else {
            window.orderOut(nil)
        }
    }
    
    func hideWindow() {
        window?.orderOut(nil)
    }
    
    func toggleWindow() {
        if window?.isVisible == true {
            hideWindow()
            appState.isMainWindowVisible = false
        } else {
            showWindow()
            appState.isMainWindowVisible = true
        }
    }
}

extension WindowManager: NSWindowDelegate {
    func windowWillClose(_ notification: Notification) {
        appState.isMainWindowVisible = false
        appState.saveWindowState()
    }
    
    func windowDidResize(_ notification: Notification) {
        if let window = window {
            appState.windowFrame = window.frame
        }
    }
    
    func windowDidMove(_ notification: Notification) {
        if let window = window {
            appState.windowFrame = window.frame
        }
    }
    
    func windowShouldClose(_ sender: NSWindow) -> Bool {
        // Don't actually close, just hide
        hideWindow()
        appState.isMainWindowVisible = false
        return false
    }
}