//
//  SettingsView.swift
//  Pay Calculator
//
//  Created by Ben Brackenbury on 28/06/2022.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var cloudKitManager: CloudKitManager
    
    @State private var pay: Double = 10.50
    @State private var hoursPerDay: Double = 8
    @State private var incomeGoal: Double = 1170
    
    func refreshData() {
        cloudKitManager.getiCloudData()
        self.hoursPerDay = cloudKitManager.hoursPerDay
        self.pay = cloudKitManager.pay
        self.incomeGoal = cloudKitManager.incomeGoal
    }
    
    var body: some View {
        
        let hoursPerDayBinding = Binding<Double> {
            self.hoursPerDay
        } set: { newVal in
            cloudKitManager.setHoursPerDay(newVal)
            refreshData()
        }
        
        let payBinding = Binding<Double> {
            self.pay
        } set: { newVal in
            cloudKitManager.setPay(newVal)
            refreshData()
        }
        
        let incomeGoalBinding = Binding<Double> {
            self.incomeGoal
        } set: { newVal in
            cloudKitManager.setIncomeGoal(newVal)
            refreshData()
        }
        
        
        Form {
            Section("Job Info") {
                HStack {
                    #if os(iOS)
                    Text("Hourly Pay")
                        .bold()
                        .padding(.trailing)
                    #endif
                    TextField("Hourly pay", value: payBinding, format: .currency(code: "GBP"))
                    #if os(iOS)
                    .keyboardType(.decimalPad)
                    #endif
                }
                
                HStack {
                    #if os(iOS)
                    Text("Hours per day")
                        .bold()
                        .padding(.trailing)
                    #endif
                    TextField("Hours per day", value: hoursPerDayBinding, format: .number)
                    #if os(iOS)
                    .keyboardType(.numberPad)
                    #endif
                }
                
                HStack {
                    #if os(iOS)
                    Text("Income Goal")
                        .bold()
                        .padding(.trailing)
                    #endif
                    TextField("Income Goal", value: incomeGoalBinding, format: .currency(code: "GBP"))
                    #if os(iOS)
                    .keyboardType(.decimalPad)
                    #endif
                }
            }
            
            Section("About") {
                VStack(alignment: .leading, spacing: 6) {
                    Text("Pay Calculator")
                    Text("© Ben Brackenbury 2022")
                        .font(.caption)
                }
            }
        }
        .formStyle(.grouped)
        .navigationTitle("Settings")
        #if os(watchOS)
        .navigationBarTitleDisplayMode(.inline)
        #endif
        .onAppear(perform: refreshData)
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            SettingsView()
        }
    }
}
