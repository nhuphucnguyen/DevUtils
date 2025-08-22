//
//  HotKeyManager.swift
//  DevUtils
//
//  Created by Claude on 22/8/25.
//

import Carbon
import AppKit

class HotKeyManager {
    private var hotKeyRef: EventHotKeyRef?
    private let windowManager: WindowManager
    
    init(windowManager: WindowManager) {
        self.windowManager = windowManager
        setupHotKey()
    }
    
    deinit {
        unregisterHotKey()
    }
    
    private func setupHotKey() {
        // Register ⌘+Shift+D hotkey
        let keyCode = UInt32(kVK_ANSI_D)
        let modifiers = UInt32(cmdKey | shiftKey)
        
        var eventType = EventTypeSpec(eventClass: OSType(kEventClassKeyboard), eventKind: OSType(kEventHotKeyPressed))
        
        InstallEventHandler(GetApplicationEventTarget(), { (nextHandler, theEvent, userData) -> OSStatus in
            guard let userData = userData else { return OSStatus(eventNotHandledErr) }
            let hotKeyManager = Unmanaged<HotKeyManager>.fromOpaque(userData).takeUnretainedValue()
            hotKeyManager.windowManager.toggleWindow()
            return OSStatus(noErr)
        }, 1, &eventType, Unmanaged.passUnretained(self).toOpaque(), nil)
        
        let hotKeyID = EventHotKeyID(signature: fourCharCode("DVUT"), id: 1)
        RegisterEventHotKey(keyCode, modifiers, hotKeyID, GetApplicationEventTarget(), 0, &hotKeyRef)
    }
    
    private func unregisterHotKey() {
        if let hotKeyRef = hotKeyRef {
            UnregisterEventHotKey(hotKeyRef)
        }
    }
}

private func fourCharCode(_ string: String) -> FourCharCode {
    assert(string.count == 4)
    var result: FourCharCode = 0
    for char in string.utf16 {
        result = (result << 8) + FourCharCode(char)
    }
    return result
}