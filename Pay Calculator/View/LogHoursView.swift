//
//  LogHoursView.swift
//  Pay Calculator
//
//  Created by Ben Brackenbury on 28/06/2022.
//

import SwiftUI

struct LogHoursView: View {
    @EnvironmentObject var cloudKitManager: CloudKitManager
    
    @State private var hoursWorked: Double = 0
    @State private var newHours = 1
    
    func refreshData() {
        cloudKitManager.getiCloudData()
        self.hoursWorked = cloudKitManager.hoursWorked
    }
    
    var body: some View {
        Form {
            VStack {
                Text(newHours, format: .number)
                    .font(.title)
                Stepper("Hours", value: $newHours)
            }
            Button("Add") {
                var newValue = hoursWorked
                newValue += Double(newHours)
                print(hoursWorked)
                print(newValue)
                cloudKitManager.setHoursWorked(newValue)
                refreshData()
            }
        }
        .formStyle(.grouped)
        .navigationTitle("Log Hours")
        .onAppear(perform: refreshData)
        #if os(iOS)
        .navigationBarTitleDisplayMode(.inline)
        #endif
    }
}

struct LogHoursView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            LogHoursView()
        }
    }
}
