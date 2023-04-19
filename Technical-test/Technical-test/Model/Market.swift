//
//  Market.swift
//  Technical-test
//
//  Created by Patrice MIAKASSISSA on 30.04.21.
//

import Foundation

final class Market {
    private let marketName: String = "SMI"
    private var quotes: [Quote]? = []

    var quotesCount: Int {
        quotes?.count ?? 0
    }

    func getQuote(at idx: Int) -> Quote? {
        return quotes?[idx]
    }

    func addQuotes(_ quotes: [Quote]) {
        self.quotes?.append(contentsOf: quotes)
    }
}
