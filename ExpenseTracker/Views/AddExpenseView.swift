import SwiftUI
import SwiftData

struct AddExpenseView: View {
    let categories: [Category]

    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss
    @State private var viewModel = AddExpenseViewModel()
    @State private var didAttemptSave = false

    var body: some View {
        NavigationStack {
            Form {
                Section("Details") {
                    TextField("Title", text: $viewModel.title)
                    if didAttemptSave, let error = viewModel.titleError {
                        Text(error).font(.caption).foregroundStyle(.red)
                    }

                    TextField("Amount", text: $viewModel.amountText)
                        .keyboardType(.decimalPad)
                    if didAttemptSave, let error = viewModel.amountError {
                        Text(error).font(.caption).foregroundStyle(.red)
                    }
                }

                Section("Category") {
                    Picker("Category", selection: $viewModel.selectedCategory) {
                        Text("None").tag(Category?.none)
                        ForEach(categories) { category in
                            Text(category.name).tag(Category?.some(category))
                        }
                    }
                }
            }
            .navigationTitle("New Expense")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        didAttemptSave = true
                        if viewModel.save(to: context) {
                            dismiss()
                        }
                    }
                }
            }
        }
    }
}
