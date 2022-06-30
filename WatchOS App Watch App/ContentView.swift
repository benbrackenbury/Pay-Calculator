//
//  ContentView.swift
//  Pay Calculator Watch App
//
//  Created by Ben Brackenbury on 28/06/2022.
//

import SwiftUI
import WidgetKit

struct ContentView: View {
    @EnvironmentObject var cloudKitManager: CloudKitManager
    @State private var showSettings = false
    @State private var showHoursLog = false
    
    @State private var hoursWorked: Double = 0
    @AppStorage("hoursWorkedGlobal", store: UserDefaults(suiteName: "group.benbrackenbury.Pay-Calculator")) var hoursWorkedGlobal: Double = 0
    @State private var hoursPerDay: Double = 8
    @State private var pay: Double = 10.50
    @State private var incomeGoal: Double = 1170
    
    #if os(macOS)
    @Environment(\.openWindow) private var openWindow
    #endif
    
    func refreshData() {
        cloudKitManager.getiCloudData()
        self.hoursWorked = cloudKitManager.hoursWorked
        self.hoursPerDay = cloudKitManager.hoursPerDay
        self.pay = cloudKitManager.pay
        self.incomeGoal = cloudKitManager.incomeGoal
    }
    
    var body: some View {
        
        let hoursWorkedBinding = Binding<Double> {
            self.hoursWorked
        } set: { newVal in
            cloudKitManager.setHoursWorked(newVal)
            self.hoursWorkedGlobal = newVal
            refreshData()
            WidgetCenter.shared.reloadAllTimelines()
        }
        
        Form {
            Section("Hours") {
                HStack {
                    TextField("", value: hoursWorkedBinding, formatter: NumberFormatter())
                    #if os(iOS)
                    .keyboardType(.numberPad)
                    #endif
                    Stepper("", value: hoursWorkedBinding, in: 0...500)
                }
                
                #if !os(macOS)
                Button(action: { showHoursLog.toggle() }) {
                    Label("Batch Log", systemImage: "rectangle.stack.fill.badge.plus")
                }
                #endif
            }
            Section("Income") {
                LabeledContent("Income", value: hoursWorked * pay, format: .currency(code: "GBP"))
                VStack(alignment: .leading, spacing: 6) {
                    Text("\(Double(incomeGoal) - (hoursWorked * pay), format: .currency(code: "GBP")) left until goal,")
                    Text("**\(ceil((Double(incomeGoal) - (hoursWorked * pay)) / Double(pay)), format: .number) more hours** are required to meet goal")
                    Text("This equates to **\(ceil((Double(incomeGoal) - (hoursWorked * pay)) / pay / cloudKitManager.hoursPerDay), format: .number) work days**")
                }
            }
        }
        .onAppear(perform: refreshData)
        
        .sheet(isPresented: $showHoursLog, content: {
            NavigationStack {
                LogHoursView(showHoursLog: $showHoursLog)
            }
            .presentationDetents([.height(300)])
        })
        
        .navigationTitle("Home")
        .navigationBarTitleDisplayMode(.inline)
        .formStyle(.grouped)
    }
}
