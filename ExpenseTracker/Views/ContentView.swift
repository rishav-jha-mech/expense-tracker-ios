import SwiftUI
import SwiftData

enum SortOption: String, CaseIterable, Identifiable {
    case dateDescending = "Newest"
    case amountDescending = "Highest"

    var id: String { rawValue }
}

struct ContentView: View {
    @Environment(\.modelContext) private var context
    @Query private var expenses: [Expense]
    @Query private var categories: [Category]

    @State private var sortOption: SortOption = .dateDescending
    @State private var filterCategory: Category?
    @State private var showingAddExpense = false

    private var filteredAndSorted: [Expense] {
        let filtered = filterCategory == nil
            ? expenses
            : expenses.filter { $0.category?.persistentModelID == filterCategory?.persistentModelID }

        switch sortOption {
        case .dateDescending:
            return filtered.sorted { $0.date > $1.date }
        case .amountDescending:
            return filtered.sorted { $0.amount > $1.amount }
        }
    }

    private var total: Double {
        filteredAndSorted.reduce(0) { $0 + $1.amount }
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                if !expenses.isEmpty {
                    CategoryBreakdownChart(expenses: expenses, categories: categories)
                        .frame(height: 180)
                        .padding()
                }

                List {
                    Section {
                        Text("Total: \(total, format: .currency(code: "USD"))")
                            .font(.headline)
                    }

                    Section {
                        ForEach(filteredAndSorted) { expense in
                            ExpenseRow(expense: expense)
                        }
                        .onDelete(perform: deleteExpenses)
                    }
                }
                .listStyle(.insetGrouped)
            }
            .navigationTitle("Expenses")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showingAddExpense = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    Menu {
                        Picker("Sort", selection: $sortOption) {
                            ForEach(SortOption.allCases) { option in
                                Text(option.rawValue).tag(option)
                            }
                        }
                        Picker("Filter", selection: $filterCategory) {
                            Text("All categories").tag(Category?.none)
                            ForEach(categories) { category in
                                Text(category.name).tag(Category?.some(category))
                            }
                        }
                    } label: {
                        Image(systemName: "line.3.horizontal.decrease.circle")
                    }
                }
            }
            .sheet(isPresented: $showingAddExpense) {
                AddExpenseView(categories: categories)
            }
        }
    }

    private func deleteExpenses(at offsets: IndexSet) {
        for index in offsets {
            context.delete(filteredAndSorted[index])
        }
    }
}

private struct ExpenseRow: View {
    let expense: Expense

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(expense.title)
                if let category = expense.category {
                    Text(category.name)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
            Spacer()
            Text(expense.amount, format: .currency(code: "USD"))
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: [Expense.self, Category.self], inMemory: true)
}
