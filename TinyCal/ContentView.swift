
import SwiftUI

struct ContentView: View {
    @StateObject private var vm: HolidayViewModel
    @State private var isVisible = false
    @State var activeDay = ActiveDay(year: Date().getYear(), month: Date().getMonth(), day: Date().getDay())

    init(vm: HolidayViewModel) {
        self._vm = StateObject(wrappedValue: vm)
    }

    func getDate() -> String {
        return self.activeDay.toDate
    }

    var body: some View {
        VStack {
            CalendarView(vm: self.vm, activeDate: $activeDay)
        }
        .frame(width: Constants.Container.width)
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(vm: HolidayViewModel())
    }
}
