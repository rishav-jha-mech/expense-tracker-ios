import Foundation
import SwiftData

@Model
final class Category {
    var name: String
    var colorHex: String

    @Relationship(deleteRule: .cascade, inverse: \Expense.category)
    var expenses: [Expense] = []

    init(name: String, colorHex: String) {
        self.name = name
        self.colorHex = colorHex
    }

    static let defaults = [
        ("Food", "FF6B6B"),
        ("Transport", "4D96FF"),
        ("Entertainment", "FFD93D"),
        ("Bills", "6BCB77")
    ]
}
