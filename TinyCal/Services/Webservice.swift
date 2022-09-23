//
//  Webservice.swift
//  StocksMenuBar
//
//  Created by Mohammad Azam on 4/24/22.
//

import Foundation

enum NetworkError: Error {
    case invalidResponse
}

class Webservice {
    func getStocks(url: URL) async throws -> Response {
        let (data, response) = try await URLSession.shared.data(from: url)

        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200
        else {
            throw NetworkError.invalidResponse
        }

        return try JSONDecoder().decode(Response.self, from: data)
    }
}
