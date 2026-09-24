import SwiftUI
import Charts

struct CategoryBreakdownChart: View {
    let expenses: [Expense]
    let categories: [Category]

    private struct Slice: Identifiable {
        let id: String
        let name: String
        let total: Double
        let colorHex: String
    }

    private var slices: [Slice] {
        categories.compactMap { category in
            let total = category.expenses.reduce(0) { $0 + $1.amount }
            guard total > 0 else { return nil }
            return Slice(id: category.name, name: category.name, total: total, colorHex: category.colorHex)
        }
    }

    var body: some View {
        if slices.isEmpty {
            ContentUnavailableView("No expenses yet", systemImage: "chart.pie")
        } else {
            Chart(slices) { slice in
                SectorMark(
                    angle: .value("Total", slice.total),
                    innerRadius: .ratio(0.5)
                )
                .foregroundStyle(by: .value("Category", slice.name))
            }
        }
    }
}
