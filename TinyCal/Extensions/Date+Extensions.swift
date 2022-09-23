//
//  Date+Extensions.swift
//  StocksMenuBar
//
//  Created by sandao on 2022/9/2.
//

import Foundation

extension Date {
    var calendar: Calendar {
        Calendar.current
    }

    func startOfMonth() -> Date {
        let components = calendar.dateComponents([.year, .month], from: self)

        return calendar.date(from: components)!
    }

    func endOfMonth() -> Date {
        var components = DateComponents()
        components.month = 1
        components.second = -1
        return calendar.date(byAdding: components, to: startOfMonth())!
    }

    var startOfDay: Date {
        return Calendar.current.startOfDay(for: self)
    }

    func isWeenEnd() -> Bool {
        let c = getWeekDay()
        return c == 1 || c == 7
    }

    func isToday() -> Bool {
        let d = Date()
        return toDate(format: "YYYY-M-d") == d.toDate(format: "YYYY-M-d")
    }

    func isCurrentMouth() -> Bool {
        let d = Date()
        return toDate(format: "YYYY-M") == d.toDate(format: "YYYY-M")
    }

    static func parse(year: Int, month: Int) -> Date {
        let _month = month > 10 ? "\(month)" : "0\(month)"
        let isoDate = "\(year)-\(_month)-14T10:44:00+0000"

        let dateFormatter = ISO8601DateFormatter()
        return dateFormatter.date(from: isoDate)!
    }

    func getWeekDay() -> Int {
        let c = Calendar.current.component(.weekday, from: self)
        return c
    }

    func getMonthDay() -> Int {
        let c = Calendar.current.component(.day, from: self)
        return c
    }

    func getMonth() -> Int {
        let c = Calendar.current.component(.month, from: self)
        return c
    }

    func getYear() -> Int {
        let c = Calendar.current.component(.year, from: self)
        return c
    }

    func getDay() -> Int {
        let c = Calendar.current.component(.day, from: self)
        return c
    }

    func addDate(num: Int) -> Date {
        return Calendar.current.date(byAdding: .day, value: num, to: self)!
    }

    func toDate(format: String?) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "zh_CN")
        formatter.dateFormat = format ?? "YYYY-MM-dd"

        return formatter.string(from: self)
    }

    /// 获取农历, 节假日名
    func getChineseDay() -> String {
        // 初始化农历日历
        let lunarCalendar = Calendar(identifier: .chinese)

        /// 获得农历月
        let lunarMonth = DateFormatter()
        lunarMonth.locale = Locale(identifier: "zh_CN")
        lunarMonth.dateStyle = .medium
        lunarMonth.calendar = lunarCalendar
        lunarMonth.dateFormat = "MMM"

        let month = lunarMonth.string(from: self)

        // 获得农历日
        let lunarDay = DateFormatter()
        lunarDay.locale = Locale(identifier: "zh_CN")
        lunarDay.dateStyle = .medium
        lunarDay.calendar = lunarCalendar
        lunarDay.dateFormat = "d"

        let day = lunarDay.string(from: self)

        // 返回农历月
        if day == "初一" {
            return month
        }

        // 返回农历日期
        return day
    }
}
