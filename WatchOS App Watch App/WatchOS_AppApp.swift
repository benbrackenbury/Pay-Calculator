//
//  WatchOS_AppApp.swift
//  WatchOS App Watch App
//
//  Created by Ben Brackenbury on 29/06/2022.
//

import SwiftUI

@main
struct WatchOS_App_Watch_AppApp: App {
    @StateObject var cloudKitManager = CloudKitManager()
    
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                MenuView()
                    .environmentObject(cloudKitManager)
            }
        }
    }
}
