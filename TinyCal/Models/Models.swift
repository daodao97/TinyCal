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
        self.date.toDate(format: "yyyy-MM") == Date().toDate(format: "yyyy-MM")
    }

    var isToday: Bool {
        self.date.toDate(format: "yyyy-MM-dd") == Date().toDate(format: "yyyy-MM-dd")
    }

    var isWeekend: Bool {
        self.date.isWeenEnd()
    }
}

struct ActiveDay: Equatable {
    var year: Int
    var month: Int
    var day: Int

    /// 由 year/month/day 构造出的 `Date`，供需要按天比较的场景使用，
    /// 避免依赖无分隔符的字符串拼接（历史上曾导致选中日期高亮碰撞）。
    var date: Date {
        var components = DateComponents()
        components.year = self.year
        components.month = self.month
        components.day = self.day
        return Calendar.current.date(from: components) ?? Date()
    }

    static func == (lhs: ActiveDay, rhs: ActiveDay) -> Bool {
        return lhs.year == rhs.year
            && lhs.month == rhs.month
            && lhs.day == rhs.day
    }
}
