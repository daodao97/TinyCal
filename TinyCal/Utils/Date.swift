import Combine
import Foundation

class MyCalendar {
    func getMonthDays(year: Int, month: Int) -> [Date] {
        let m = Date.parse(year: year, month: month)
        let startDate: Date = m.startOfMonth()
        let index = startDate.getWeekDay()
        var days: [Date] = []

        if index > 1 {
            let tmp = [Int](1 ..< index - 1)
            for i in tmp.indices {
                days.append(startDate.addDate(num: -tmp.reversed()[i]))
            }
        } else {
            let tmp = [Int](1 ..< 7)
            for i in tmp.indices {
                days.append(startDate.addDate(num: -tmp.reversed()[i]))
            }
        }
        let endDate: Date = m.endOfMonth()
        var tmp = startDate
        while tmp.getMonthDay() < endDate.getMonthDay() {
            days.append(tmp)
            tmp = tmp.addDate(num: 1)
        }
        days.append(endDate)

        let _index = endDate.getWeekDay() - 1
        if _index < 7 {
            for i in [Int](_index + 1 ..< 8) {
                days.append(endDate.addDate(num: i - _index))
            }
        }

        return days
    }

    func dateToDay(d: Date) -> Day {
        return Day(d: d)
    }

    func getMonthPart(year: Int, month: Int) -> [[Day]] {
        let days: [Date] = getMonthDays(year: year, month: month)
        var parts: [[Day]] = []

        for i in days.indices {
            if ((i + 1) % 7) == 0 {
                let tmp: [Day] = days[i - 6 ... i].map { i -> Day in dateToDay(d: i) }
                parts.append(tmp)
            }
        }

        return parts
    }
}
