//
//  Expenses.swift
//  iExpense
//
//  Created by Daniel Starnes on 3/17/26.
//

import Foundation
import SwiftData

@Model
class Expenses {
    var expenseType: String
    @Relationship var items = [Item]()
    
    init(type: String) {
        self.expenseType = type
    }
}

struct Item: Identifiable, Codable {
    var id = UUID()
    let name: String
    let type: String
    let amount: Double
}
