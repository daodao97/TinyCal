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

            guard let url = URL(string: "http://timor.tech/api/holiday/year/" + year) else {
                print("populateStocks: invalid url for year", year)
                return
            }
            let stocks = try await Webservice().getStocks(url: url)
            if stocks.holiday.count > 0 {
                self.stocks[year] = stocks.holiday
                let jsonData = try JSONEncoder().encode(stocks)
                guard let jsonString = String(data: jsonData, encoding: .utf8) else {
                    print("populateStocks: failed to encode cache as utf8 for year", year)
                    return
                }
                f.createFile(fileName: year, data: jsonString)
            }

        } catch {
            print("populateStocks", error)
        }
    }
}
