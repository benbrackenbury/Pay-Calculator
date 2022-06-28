//
//  CloudKitManager.swift
//  Pay Calculator
//
//  Created by Ben Brackenbury on 28/06/2022.
//

import Foundation
import CloudKit

class CloudKitManager: ObservableObject {
    
    @Published var isSignedInToiCloud: Bool = false
    @Published var error: String = ""
    
    @Published var hoursWorked: Double = 0.00
    @Published var hoursPerDay: Double = 8.00
    @Published var pay: Double = 10.50
    @Published var incomeGoal: Double = 1170
    
    private let database = CKContainer.default().privateCloudDatabase
    private let keyValStore = NSUbiquitousKeyValueStore()
    
    init() {
        getiCloudStatus()
        getiCloudData()
    }
    
    private func getiCloudStatus() {
        CKContainer.default().accountStatus { [weak self] status, error in
            DispatchQueue.main.async {
                switch status {
                case .couldNotDetermine:
                    self?.error = CloudKitError.iCloudAccountNotDetermined.localizedDescription
                case .available:
                    self?.isSignedInToiCloud = true
                case .restricted:
                    self?.error = CloudKitError.iCloudAccountRestricted.localizedDescription
                case .noAccount:
                    self?.error = CloudKitError.iCloudAccountNotFound.localizedDescription
                case .temporarilyUnavailable:
                    self?.error = CloudKitError.iCloudAccountUnavailable.localizedDescription
                @unknown default:
                    self?.error = CloudKitError.iCloudAccountUnknown.localizedDescription
                }
            }
        }
    }
    
    @objc func getiCloudData() {
        self.hoursWorked = keyValStore.double(forKey: "hoursWorked")
        self.hoursPerDay = keyValStore.double(forKey: "hoursPerDay")
        self.pay = keyValStore.double(forKey: "pay")
        self.incomeGoal = keyValStore.double(forKey: "incomeGoal")
    }
    
    @objc func setHoursWorked(_ hours: Double) {
        keyValStore.set(hours, forKey: "hoursWorked")
        keyValStore.synchronize()
    }
    
    @objc func setHoursPerDay(_ hours: Double) {
        keyValStore.set(hours, forKey: "hoursPerDay")
        keyValStore.synchronize()
    }
    
    @objc func setPay(_ pay: Double) {
        keyValStore.set(pay, forKey: "pay")
        keyValStore.synchronize()
    }
    
    @objc func setIncomeGoal(_ goal: Double) {
        keyValStore.set(goal, forKey: "incomeGoal")
        keyValStore.synchronize()
    }
}


extension CloudKitManager {
    enum CloudKitError: LocalizedError {
        case iCloudAccountNotFound
        case iCloudAccountNotDetermined
        case iCloudAccountRestricted
        case iCloudAccountUnavailable
        case iCloudAccountUnknown
    }
}
