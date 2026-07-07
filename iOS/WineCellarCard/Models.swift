import Foundation

struct BottleEntry: Identifiable, Codable, Equatable {
    let id: UUID
    var name: String
    var vintage: String
    var region: String
    var drinkByYear: String
    var createdAt: Date

    init(id: UUID = UUID(), name: String = "", vintage: String = "", region: String = "", drinkByYear: String = "", createdAt: Date = Date()) {
        self.id = id
        self.name = name
        self.vintage = vintage
        self.region = region
        self.drinkByYear = drinkByYear
        self.createdAt = createdAt
    }
}
