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
        self.quotes = quotes

        let favs = UserDefaultsManager.shared.favoriteQuotes
        guard quotesCount > 0 else { return }
        for i in 0..<quotesCount {
            if favs.contains(self.quotes![i].key) {
                self.quotes![i].setFavorite(true)
            }
        }
    }

    func updateFavoriteForQuote(_ quote: Quote?) {
        guard let quote = quote,
              let idx = self.quotes!.firstIndex(where: { $0.key == quote.key }) else {
            return
        }

        self.quotes![idx].toggleFavorite()
    }
}
