//
//  LogHoursView.swift
//  Pay Calculator
//
//  Created by Ben Brackenbury on 28/06/2022.
//

import SwiftUI

struct LogHoursView: View {
    @EnvironmentObject var cloudKitManager: CloudKitManager
    @Binding var showHoursLog: Bool
    
    @State private var hoursWorked: Double = 0
    @State private var newHours = 1
    
    func refreshData() {
        cloudKitManager.getiCloudData()
        self.hoursWorked = cloudKitManager.hoursWorked
    }
    
    var body: some View {
        Form {
            VStack {
                Stepper("\(newHours, format: .number)", value: $newHours)
            }
            Button("Add") {
                var newValue = hoursWorked
                newValue += Double(newHours)
                print(hoursWorked)
                print(newValue)
                cloudKitManager.setHoursWorked(newValue)
                refreshData()
                showHoursLog = false
            }
        }
        .formStyle(.grouped)
        .onAppear(perform: refreshData)
    }
}
