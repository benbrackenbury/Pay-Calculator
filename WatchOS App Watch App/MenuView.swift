//
//  MenuView.swift
//  WatchOS App Watch App
//
//  Created by Ben Brackenbury on 29/06/2022.
//

import SwiftUI

struct MenuView: View {
    @EnvironmentObject var cloudKitManager: CloudKitManager
    
    var body: some View {
        NavigationView {
            List {
                NavigationLink(destination: {
                    ContentView()
                        .environmentObject(cloudKitManager)
                }) {
                    Label("Home", systemImage: "house.fill")
                }
                .tag(0)
                
                NavigationLink(destination: {
                    SettingsView()
                        .environmentObject(cloudKitManager)
                }) {
                    Label("Settings", systemImage: "gear")
                }
                .tag(0)
            }
            .navigationTitle("Pay Calculator")
        }
    }
}

struct MenuView_Previews: PreviewProvider {
    static var previews: some View {
        MenuView()
    }
}
