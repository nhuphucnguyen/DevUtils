//
//  TabKeyboardHandler.swift
//  DevUtils
//
//  Created by Claude on 22/8/25.
//

import AppKit
import Carbon

class TabKeyboardHandler {
    private var localEventMonitor: Any?
    
    init() {
        setupKeyboardHandling()
    }
    
    deinit {
        stopKeyboardHandling()
    }
    
    private func setupKeyboardHandling() {
        localEventMonitor = NSEvent.addLocalMonitorForEvents(matching: [.keyDown]) { event in
            return self.handleKeyEvent(event) ? nil : event
        }
    }
    
    private func stopKeyboardHandling() {
        if let monitor = localEventMonitor {
            NSEvent.removeMonitor(monitor)
            localEventMonitor = nil
        }
    }
    
    private func handleKeyEvent(_ event: NSEvent) -> Bool {
        // Check if Command key is pressed
        guard event.modifierFlags.contains(.command) else { return false }
        
        // Check for number keys 1, 2, 3
        switch event.keyCode {
        case 18: // Key code for "1"
            switchToTab(0)
            return true
        case 19: // Key code for "2"
            switchToTab(1)
            return true
        case 20: // Key code for "3"
            switchToTab(2)
            return true
        default:
            return false
        }
    }
    
    private func switchToTab(_ index: Int) {
        print("Switching to tab \(index + 1)")
        NotificationCenter.default.post(
            name: NSNotification.Name("SwitchToTab"),
            object: index
        )
    }
}