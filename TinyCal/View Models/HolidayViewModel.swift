import Foundation

@MainActor
class HolidayViewModel: ObservableObject {
    @Published var stocks = [String: [String: Holiday]]()

    func populateStocks(year: String) async {
        do {
            if self.stocks[year] != nil {
                return
            }
            let f = File()
            if let d = f.readField(fileName: year) {
                print("get data from file")
                let stocks = try JSONDecoder().decode(Response.self, from: d)
                self.stocks[year] = stocks.holiday
                return
            }

            let stocks = try await Webservice().getStocks(url: URL(string: "http://timor.tech/api/holiday/year/" + year)!)
            if stocks.holiday.count > 0 {
                self.stocks[year] = stocks.holiday
                let jsonData = try JSONEncoder().encode(stocks)
                let jsonString = String(data: jsonData, encoding: .utf8)!
                f.createFile(fileName: year, data: jsonString)
            }

        } catch {
            print("populateStocks", error)
        }
    }
}
