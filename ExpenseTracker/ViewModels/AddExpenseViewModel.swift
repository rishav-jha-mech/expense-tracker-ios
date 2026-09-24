import Foundation
import SwiftData

@Observable
final class AddExpenseViewModel {
    var title: String = ""
    var amountText: String = ""
    var selectedCategory: Category?

    var titleError: String? {
        title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? "Title is required" : nil
    }

    var amountError: String? {
        guard !amountText.isEmpty else { return "Amount is required" }
        guard let value = Double(amountText), value > 0 else { return "Enter a valid positive amount" }
        return nil
    }

    var isValid: Bool {
        titleError == nil && amountError == nil
    }

    func save(to context: ModelContext) -> Bool {
        guard isValid, let amount = Double(amountText) else { return false }
        let expense = Expense(
            title: title.trimmingCharacters(in: .whitespacesAndNewlines),
            amount: amount,
            category: selectedCategory
        )
        context.insert(expense)
        reset()
        return true
    }

    private func reset() {
        title = ""
        amountText = ""
        selectedCategory = nil
    }
}
