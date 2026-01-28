//
//  ContentView.swift
//  iExpense
//
//  Created by Daniel Starnes on 1/24/26.
//

import SwiftUI

struct Item: Identifiable, Codable {
    var id = UUID()
    let name: String
    let type: String
    let amount: Double
}

@Observable
class Expenses {
    var personalItems = [Item]() {
        didSet {
            if let encoded = try? JSONEncoder().encode(personalItems) {
                UserDefaults.standard.set(encoded, forKey: "personalItems")
            }
        }
    }
    
    var businessItems = [Item]() {
        didSet {
            if let encoded = try? JSONEncoder().encode(businessItems) {
                UserDefaults.standard.set(encoded, forKey: "businessItems")
            }
        }
    }
    
    
    init() {
        if let pItems = UserDefaults.standard.data(forKey: "personalItems") {
            if let decodedItems = try? JSONDecoder().decode([Item].self, from: pItems) {
                personalItems = decodedItems
                return
            }
        }
        if let bItems = UserDefaults.standard.data(forKey: "businessItems") {
            if let decodedItems = try? JSONDecoder().decode([Item].self, from:bItems) {
                 businessItems = decodedItems
                return
            }
        }
        
        personalItems = []
        businessItems = []
    }
}

struct ContentView: View {
    @State private var expenses = Expenses()
    
    @State private var showingAddExpense = false
    
    var body: some View {
        NavigationStack {
            List {
                
                VStack {
                    Text("Personal Expenses")
                        .font(.title2)
                    ForEach(expenses.personalItems) { item in
                        HStack {
                            VStack(alignment: .leading) {
                                Text(item.name)
                                    .font(.headline)
                                
                                Text(item.type)
                            }
                            
                            Spacer()
                            
                            if item.amount < 10 {
                                Text(item.amount, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                                    .bold()
                            }
                            else if item.amount < 100 {
                                Text(item.amount, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                                    .bold()
                                    .foregroundStyle(.orange)
                            }
                            else {
                                Text(item.amount, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                                    .foregroundStyle(.red)
                            }
                        }
                    }
                    .onDelete(perform: removeItems)
                }
                
                VStack {
                    Text("Business Expenses")
                        .font(.title2)
                    ForEach(expenses.businessItems) { item in
                        HStack {
                            VStack(alignment: .leading) {
                                Text(item.name)
                                    .font(.headline)
                                
                                Text(item.type)
                            }
                            
                            Spacer()
                            
                            if item.amount < 10 {
                                Text(item.amount, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                                    .bold()
                            }
                            else if item.amount < 100 {
                                Text(item.amount, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                                    .bold()
                                    .foregroundStyle(.orange)
                            }
                            else {
                                Text(item.amount, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                                    .foregroundStyle(.red)
                            }
                        }
                    }
                    .onDelete(perform: removeItems)
                }
            }
            .navigationTitle("iExpense")
            .toolbar {
                Button("Add Expense", systemImage: "plus") {
                    showingAddExpense = true
                }
            }
            .sheet(isPresented: $showingAddExpense){
                AddView(expenses: expenses)
            }
        }
    }
    
    func removeItems(at offsets: IndexSet) {
    expenses.businessItems.remove(atOffsets: offsets)
    }
}

#Preview {
    ContentView()
}
