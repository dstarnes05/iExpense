//
//  iExpenseApp.swift
//  iExpense
//
//  Created by Daniel Starnes on 1/24/26.
//

import SwiftData
import SwiftUI

@main
struct iExpenseApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: Expenses.self)
    }
}
