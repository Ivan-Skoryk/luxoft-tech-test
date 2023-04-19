//
//  DataManager.swift
//  Technical-test
//
//  Created by Patrice MIAKASSISSA on 29.04.21.
//

import Foundation


final class DataManager {
    enum NetworkError: Error {
        case invalidPath
        case networkError(description: String)
        case noData
        case decodeError

        var description: String {
            switch self {
            case .invalidPath: return "Invalid URL for fetching quotes"
            case .networkError(let error): return error
            case .noData: return "No data for provided URL"
            case .decodeError: return "Error while decoding Quotes"
            }
        }
    }

    private static let path = "https://www.swissquote.ch/mobile/iphone/Quote.action?formattedList&formatNumbers=true&listType=SMI&addServices=true&updateCounter=true&&s=smi&s=$smi&lastTime=0&&api=2&framework=6.1.1&format=json&locale=en&mobile=iphone&language=en&version=80200.0&formatNumbers=true&mid=5862297638228606086&wl=sq"

    func fetchQuotes(completionHandler: @escaping (Result<[Quote], NetworkError>) -> Void) {
        guard let url = URL(string: DataManager.path) else {
            completionHandler(.failure(.invalidPath))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        URLSession.shared.dataTask(with: request) { data, response, error in

            if let error = error {
                completionHandler(.failure(.networkError(description: error.localizedDescription)))
                return
            }

            
            guard
                let response = response as? HTTPURLResponse,
                (200..<300).contains(response.statusCode)
            else {
                return
            }

            guard let data = data else {
                completionHandler(.failure(.noData))
                return
            }

            do {
                let decoder = JSONDecoder()
                let quotes = try decoder.decode([Quote].self, from: data)

                completionHandler(.success(quotes))
            } catch {
                completionHandler(.failure(.decodeError))
            }
        }.resume()
    }
}
