import Foundation

struct Response: Codable {
    let code: Int
    let holiday: [String: Holiday]
}

struct Holiday: Codable {
    let holiday: Bool
    let name: String
    let wage: Int
    let date: String
    let rest: Int?

    var isHoliday: Bool {
        self.holiday
    }
}

struct Day: Decodable, Hashable {
    let date: Date

    init(d: Date) {
        self.date = d
    }

    var isCruurentMonth: Bool {
        self.date.toDate(format: "MM") == Date().toDate(format: "MM")
    }

    var isToday: Bool {
        self.date.toDate(format: "YYYY-MM-dd") == Date().toDate(format: "YYYY-MM-dd")
    }

    var isWeekend: Bool {
        self.date.isWeenEnd()
    }
}

struct ActiveDay: Equatable {
    var year: Int
    var month: Int
    var day: Int

    var toDate: String {
        String(self.year) + String(self.month) + String(self.day)
    }

    static func == (lhs: ActiveDay, rhs: ActiveDay) -> Bool {
        return lhs.year == rhs.year
            && lhs.month == rhs.month
            && lhs.day == rhs.day
    }
}
