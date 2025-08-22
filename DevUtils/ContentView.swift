//
//  ContentView.swift
//  DevUtils
//
//  Created by Nguyen Nhu Phuc on 21/8/25.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        TabView(selection: $appState.selectedTab) {
            Base64View()
                .tabItem {
                    Image(systemName: "textformat.abc")
                    Text("Base64")
                }
                .tag(0)
            
            JWTView()
                .tabItem {
                    Image(systemName: "key")
                    Text("JWT")
                }
                .tag(1)
            
            JSONView()
                .tabItem {
                    Image(systemName: "doc.text")
                    Text("JSON")
                }
                .tag(2)
        }
        .frame(minWidth: 600, minHeight: 500)
        .onReceive(NotificationCenter.default.publisher(for: NSApplication.willTerminateNotification)) { _ in
            appState.saveWindowState()
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(AppState())
}
