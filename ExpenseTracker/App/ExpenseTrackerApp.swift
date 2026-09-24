import SwiftUI
import SwiftData

@main
struct ExpenseTrackerApp: App {
    let container: ModelContainer

    init() {
        container = try! ModelContainer(for: Expense.self, Category.self)
        seedCategoriesIfNeeded()
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(container)
    }

    private func seedCategoriesIfNeeded() {
        let context = container.mainContext
        let existing = try? context.fetch(FetchDescriptor<Category>())
        guard existing?.isEmpty ?? true else { return }

        for (name, colorHex) in Category.defaults {
            context.insert(Category(name: name, colorHex: colorHex))
        }
        try? context.save()
    }
}
