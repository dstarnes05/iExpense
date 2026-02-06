//
//  AddView.swift
//  iExpense
//
//  Created by Daniel Starnes on 1/25/26.
//

import SwiftUI

struct AddView: View {
    @Environment(\.dismiss) var dismiss
    
    @State private var name = ""
    @State private var type = "Personal"
    @State private var amount = 0.0
    
    var personalExpenses: Expenses
    var businessExpenses: Expenses
    
    let types = ["Business", "Personal"]
    
    var body: some View {
        NavigationStack {
            Form {
                TextField("Name", text: $name)
                
                Picker("Type", selection: $type) {
                    ForEach(types, id: \.self) {
                        Text($0)
                    }
                }
                
                TextField("Amount", value: $amount, format: .currency(code: "USD"))
                    .keyboardType(.decimalPad)
            }
            .navigationTitle("Add new expense")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        if type == "Personal" {
                            let item = Item(name: name, type: type, amount: amount)
                            personalExpenses.items.append(item)
                            dismiss()
                        } else {
                            let item = Item(name: name, type: type, amount: amount)
                            businessExpenses.items.append(item)
                            dismiss()
                        }
                    }
                }
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    AddView(personalExpenses: Expenses(type: "Personal"), businessExpenses: Expenses(type: "Business"))
}
