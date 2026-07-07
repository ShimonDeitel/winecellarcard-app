import SwiftUI

/// deep bordeaux with a muted gold accent
enum Theme {
    static let primary = Color(red: 0.357, green: 0.102, blue: 0.180)
    static let accent = Color(red: 0.831, green: 0.686, blue: 0.416)
    static let background = Color(.systemBackground)
    static let cardBackground = Color(.secondarySystemBackground)
    static let titleFont = Font.system(.largeTitle, design: .rounded).weight(.bold)
    static let headingFont = Font.system(.headline, design: .rounded).weight(.semibold)
    static let bodyFont = Font.system(.body, design: .rounded)
}
