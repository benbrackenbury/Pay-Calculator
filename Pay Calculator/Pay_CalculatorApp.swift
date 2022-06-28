//
//  Pay_CalculatorApp.swift
//  Pay Calculator
//
//  Created by Ben Brackenbury on 28/06/2022.
//

import SwiftUI

@main
struct Pay_CalculatorApp: App {
    @StateObject var cloudKitManager = CloudKitManager()
    
    @AppStorage("hoursWorked") var hoursWorked = 0
    
    #if os(macOS)
    @Environment(\.openWindow) private var openWindow
    #endif

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(cloudKitManager)
        }
        
        #if os(macOS)
        .commands {
            CommandGroup(replacing: CommandGroupPlacement.newItem) {
                Menu("Log hours") {
                    Button("1") {
                        hoursWorked += 1
                    }
                    Button("5") {
                        hoursWorked += 5
                    }
                    Button("8") {
                        hoursWorked += 8
                    }
                    Divider()
                    Button("Custom...") {
                        openWindow(id: "loghours")
                    }
                }
            }
        }
        #endif
        
        #if os(macOS)
        Window("Log Hours", id: "loghours") {
            LogHoursView()
                .environmentObject(cloudKitManager)
        }
        .keyboardShortcut("l")
        .defaultSize(width: 200, height: 300)
        
        Settings {
            SettingsView()
                .environmentObject(cloudKitManager)
        }
        #endif
    }
}
