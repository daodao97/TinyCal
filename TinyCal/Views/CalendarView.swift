import AppKit
import SwiftUI

func monthDates(year: Int, month: Int) -> [[Day]] {
    return MyCalendar().getMonthPart(year: year, month: month)
}

struct CalendarView: View {
    @Environment(\.colorScheme) var colorScheme

    @State var lead: [String] = ["一", "二", "三", "四", "五", "六", "日"]
    @State var year = Date().getYear()
    @State var month = Date().getMonth()
    @State var allDays = monthDates(year: Date().getYear(), month: Date().getMonth())

    @ObservedObject var settings = AppSettings()
    @StateObject private var vm: HolidayViewModel
    @Binding var activeDate: ActiveDay

    init(vm: HolidayViewModel, activeDate: Binding<ActiveDay>) {
        self._vm = StateObject(wrappedValue: vm)
        self._activeDate = activeDate
    }

    func reflush() {
        let d = Date()
        var day = d.getDay()
        if d.toDate(format: "YYYYM") != String(self.year) + String(self.month) {
            day = 1
        }

        self.activeDate = ActiveDay(year: self.year, month: self.month, day: day)
        self.allDays = monthDates(year: self.year, month: self.month)
    }

    var width: CGFloat = 30
    var height: CGFloat = 30
    var leadHeight: CGFloat = 20

    func nextMonth() {
        let month = self.month + 1
        if month == 13 {
            self.year += 1
            self.month = 1
        } else {
            self.month = month
            if month == 12 {
                Task {
                    await self.vm.populateStocks(year: String(self.year + 1))
                }
            }
        }

        self.reflush()
    }

    func preMonth() {
        let month = self.month - 1
        if month == 0 {
            self.year -= 1
            self.month = 12

        } else {
            self.month = month
            if month == 1 {
                Task {
                    await self.vm.populateStocks(year: String(self.year - 1))
                }
            }
        }

        self.reflush()
    }

    func currentMonth() {
        let t = Date()
        let year = t.getYear()
        let month = t.getMonth()
        self.year = year
        self.month = month
        self.reflush()
    }

    func isHoliday(d: Date) -> Holiday? {
        if let y = self.vm.stocks[d.toDate(format: "YYYY")] {
            if let h = y[d.toDate(format: "MM-dd")] {
                if h.isHoliday {
                    return h
                }
            }
        }
        return nil
    }

    func isHolidayWork(d: Date) -> Holiday? {
        if let y = self.vm.stocks[d.toDate(format: "YYYY")] {
            if let h = y[d.toDate(format: "MM-dd")] {
                if !h.isHoliday {
                    return h
                }
            }
        }
        return nil
    }

    func getDayExtr(day: Day) -> String? {
        if self.settings.showHoliday {
            if let h = self.isHoliday(d: day.date) {
                return h.name.replace(target: "节", withString: "")
            }
            if let _ = self.isHolidayWork(d: day.date) {
                return "班"
            }
        }

        if self.settings.showChinese {
            return day.date.getChineseDay()
        }
        return nil
    }

    func getDayExtrColor(day: Day) -> Color? {
        if self.settings.showHoliday {
            if let _ = self.isHoliday(d: day.date) {
                return .purple
            }
            if let _ = self.isHolidayWork(d: day.date) {
                return Color.red
            }
        }
        return self.colorScheme == .dark ? Color.white : Color.black
    }

    func isActive(d: Date) -> Bool {
        return d.toDate(format: "YYYYMd") == self.activeDate.toDate
    }

    @ViewBuilder
    private func cell(day: Day) -> some View {
        VStack {
            Text(day.date.toDate(format: "d"))
            if let ext = self.getDayExtr(day: day) {
                Text(ext)
                    .font(.system(size: 8))
                    .foregroundColor(self.getDayExtrColor(day: day)!)
            }
        }
        .frame(width: self.width, height: self.height)
        .background(self.isActive(d: day.date) ? .yellow.opacity(0.2) : .black.opacity(0))
        .cornerRadius(self.isActive(d: day.date) ? 15 : 0)
        .onTapGesture {
            let d = day.date
            self.activeDate = ActiveDay(year: d.getYear(), month: d.getMonth(), day: d.getDay())
        }
    }

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Button(action: {
                    NSApplication.shared.terminate(nil)
                }) {
                    Image(systemName: "power")
                }.keyboardShortcut("q")
                Button(action: {
                    openSettings()
                }) {
                    Image(systemName: "gear")
                }

                Text("\(String(self.year))/\(self.month)")
                    .fontWeight(.bold)

                Spacer()
                HStack {
                    Button(action: self.preMonth) {
                        Image(systemName: "chevron.left")
                    }
                    Button(action: self.currentMonth) {
                        Image(systemName: "circle")
                    }
                    Button(action: self.nextMonth) {
                        Image(systemName: "chevron.right")
                    }
                }
            }
            HStack {
                ForEach(0 ..< 7) { index in
                    VStack {
                        Text(lead[index]).bold()
                    }
                    .frame(width: width, height: leadHeight)
                }
            }

            ForEach(allDays, id: \.self) { week in
                HStack {
                    ForEach(week, id: \.self) { day in
                        self.cell(day: day)
                    }
                }
            }
        }
    }
}

struct CalendarView_Previews: PreviewProvider {
    @State static var day = ActiveDay(year: Date().getYear(), month: Date().getMonth(), day: Date().getDay())
    static var previews: some View {
        CalendarView(vm: HolidayViewModel(), activeDate: $day)
    }
}
