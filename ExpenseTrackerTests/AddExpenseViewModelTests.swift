import Testing
import SwiftData
@testable import ExpenseTracker

struct AddExpenseViewModelTests {
    private func makeContext() -> ModelContext {
        let container = try! ModelContainer(
            for: Expense.self, Category.self,
            configurations: ModelConfiguration(isStoredInMemoryOnly: true)
        )
        return ModelContext(container)
    }

    @Test func emptyTitleIsInvalid() {
        let viewModel = AddExpenseViewModel()
        viewModel.title = "   "
        viewModel.amountText = "10"
        #expect(viewModel.isValid == false)
        #expect(viewModel.titleError != nil)
    }

    @Test func nonNumericAmountIsInvalid() {
        let viewModel = AddExpenseViewModel()
        viewModel.title = "Coffee"
        viewModel.amountText = "abc"
        #expect(viewModel.isValid == false)
        #expect(viewModel.amountError != nil)
    }

    @Test func negativeAmountIsInvalid() {
        let viewModel = AddExpenseViewModel()
        viewModel.title = "Coffee"
        viewModel.amountText = "-5"
        #expect(viewModel.isValid == false)
    }

    @Test func validInputSavesAndResetsForm() {
        let context = makeContext()
        let viewModel = AddExpenseViewModel()
        viewModel.title = "Coffee"
        viewModel.amountText = "4.50"

        let saved = viewModel.save(to: context)

        #expect(saved == true)
        #expect(viewModel.title.isEmpty)
        #expect(viewModel.amountText.isEmpty)
    }
}
