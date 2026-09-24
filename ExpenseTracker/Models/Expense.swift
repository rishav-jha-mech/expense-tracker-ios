import Foundation
import SwiftData

@Model
final class Expense {
    var title: String
    var amount: Double
    var date: Date
    var category: Category?

    init(title: String, amount: Double, date: Date = Date(), category: Category? = nil) {
        self.title = title
        self.amount = amount
        self.date = date
        self.category = category
    }
}
