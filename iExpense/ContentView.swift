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
    let expenseType: String
    
    var items = [Item]() {
        didSet {
            if let encoded = try? JSONEncoder().encode(items) {
                UserDefaults.standard.set(encoded, forKey: "\(expenseType)Items")
            }
        }
    }
    
    init(type: String) {
        self.expenseType = type
        if let storedItems = UserDefaults.standard.data(forKey: "\(type)Items") {
            if let decodedItems = try? JSONDecoder().decode([Item].self, from: storedItems) {
                self.items = decodedItems
                return
            }
        }
        self.items = []
    }
}

struct ContentView: View {
    @State private var personalExpenses = Expenses(type: "Personal")
    @State private var businessExpenses = Expenses(type: "Business")
    
    @State private var showingAddExpense = false
    
    var body: some View {
        NavigationStack {
            List {
                
                Section {
                    Text("Personal Expenses")
                        .font(.title2)
                        .bold()
                        .frame(maxWidth: .infinity, alignment: .center)
                    ForEach(personalExpenses.items) { item in
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
                    .onDelete(perform: removePersonalItems)
                }
                
                Section {
                    Text("Business Expenses")
                        .frame(maxWidth: .infinity, alignment: .center)
                        .bold()
                        .font(.title2)
                    ForEach(businessExpenses.items) { item in
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
                    .onDelete(perform: removeBusinessItems)
                }
            }
            .navigationTitle("iExpense")
            .toolbar {
                Button("Add Expense", systemImage: "plus") {
                    showingAddExpense = true
                }
            }
            .sheet(isPresented: $showingAddExpense){
                AddView(personalExpenses: personalExpenses, businessExpenses: businessExpenses)
            }
        }
    }
    
    func removePersonalItems(at offsets: IndexSet) {
        personalExpenses.items.remove(atOffsets: offsets)
    }
    
    func removeBusinessItems(at offsets: IndexSet) {
        businessExpenses.items.remove(atOffsets: offsets)
    }
}

#Preview {
    ContentView()
}
