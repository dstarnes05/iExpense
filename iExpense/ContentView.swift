//
//  ContentView.swift
//  iExpense
//
//  Created by Daniel Starnes on 1/24/26.
//

import SwiftData
import SwiftUI


struct ContentView: View {
    @Environment(\.modelContext) var modelContext
    
    @State private var personalExpenses = Expenses(type: "Personal")
    @State private var businessExpenses = Expenses(type: "Business")
    @State private var sortOrder = [
        SortDescriptor(\Item.amount),
        SortDescriptor(\Item.name)
    ]
    
    @State private var showingAddExpense = false
    @State private var showingExpenses = [true, true]
    
    
    var body: some View {
        NavigationStack {
            List {
                
                if showingExpenses[0] {
                    Section {
                        Text("Personal Expenses")
                            .font(.title2)
                            .bold()
                            .frame(maxWidth: .infinity, alignment: .center)
                        let sortedPersonalItems = personalExpenses.items.sorted(using: sortOrder)
                        ForEach(sortedPersonalItems) { item in
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
                }
                
                if showingExpenses[1] {
                    Section {
                        Text("Business Expenses")
                            .frame(maxWidth: .infinity, alignment: .center)
                            .bold()
                            .font(.title2)
                        let sortedBusinessItems = businessExpenses.items.sorted(using: sortOrder)
                        ForEach(sortedBusinessItems) { item in
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
            }
            .navigationTitle("iExpense")
            .toolbar {
                NavigationLink("Add Expense"){
                    AddView(personalExpenses: personalExpenses, businessExpenses: businessExpenses)
                        .navigationBarBackButtonHidden()
                }
                
                Menu("Sort", systemImage: "arrow.up.arrow.down") {
                    Picker("Sort", selection: $sortOrder) {
                        Text("Sort by Name")
                            .tag([
                                SortDescriptor(\Item.name),
                                SortDescriptor(\Item.amount)
                            ])
                        
                        Text("Sort by Amount")
                            .tag([
                                SortDescriptor(\Item.amount),
                                SortDescriptor(\Item.name)
                            ])
                    }
                }
                
                Menu("Filter", systemImage: "line.horizontal.3.decrease.circle") {
                    Picker("Filter", selection: $showingExpenses) {
                        Text("All Expenses")
                            .tag([true, true])
                        Text("Business Expenses Only")
                            .tag([false, true])
                        Text("Personal Expenses Only")
                            .tag([true, false])
                    }
                }
            }
        }
    }
    
    func removePersonalItems(at offsets: IndexSet) {
        let sorted = personalExpenses.items.sorted(using: sortOrder)
        
        for index in offsets {
            let item = sorted[index]
            personalExpenses.items.removeAll { $0.id == item.id }
        }
    }
    
    func removeBusinessItems(at offsets: IndexSet) {
        let sorted = businessExpenses.items.sorted(using: sortOrder)
        
        for index in offsets {
            let item = sorted[index]
            businessExpenses.items.removeAll { $0.id == item.id }
        }
    }
}

#Preview {
    ContentView()
}
