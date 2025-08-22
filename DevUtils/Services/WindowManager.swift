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
        print("Creating window with frame: \(appState.windowFrame)")
        
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
        
        print("Window created: \(window != nil)")
        print("Window frame after creation: \(window?.frame ?? CGRect.zero)")
        
        // Try without floating level and accessory policy first
        // NSApp.setActivationPolicy(.accessory)
        // window?.level = .floating
        
        // Make window appear in all spaces
        window?.collectionBehavior = [.canJoinAllSpaces, .fullScreenAuxiliary]
    }
    
    func setContentView<Content: View>(@ViewBuilder content: () -> Content) {
        let hostingView = NSHostingView(rootView: content())
        hostingView.frame = window?.contentView?.frame ?? CGRect(x: 0, y: 0, width: 600, height: 500)
        window?.contentView = hostingView
        
        print("Content view set with SwiftUI NSHostingView")
    }
    
    func showWindow() {
        guard let window = window else { 
            print("ERROR: Window is nil!")
            return 
        }
        
        print("Showing window...")
        print("Window frame: \(window.frame)")
        print("Window isVisible: \(window.isVisible)")
        
        window.setFrame(appState.windowFrame, display: true)
        window.makeKeyAndOrderFront(nil)
        window.orderFrontRegardless()
        NSApp.activate(ignoringOtherApps: true)
        
        print("After show - Window isVisible: \(window.isVisible)")
        print("Window level: \(window.level.rawValue)")
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
        DispatchQueue.main.async {
            self.appState.isMainWindowVisible = false
            self.appState.saveWindowState()
        }
    }
    
    func windowDidResize(_ notification: Notification) {
        if let window = window {
            DispatchQueue.main.async {
                self.appState.windowFrame = window.frame
            }
        }
    }
    
    func windowDidMove(_ notification: Notification) {
        if let window = window {
            DispatchQueue.main.async {
                self.appState.windowFrame = window.frame
            }
        }
    }
    
    func windowShouldClose(_ sender: NSWindow) -> Bool {
        // Don't actually close, just hide
        hideWindow()
        DispatchQueue.main.async {
            self.appState.isMainWindowVisible = false
        }
        return false
    }
}