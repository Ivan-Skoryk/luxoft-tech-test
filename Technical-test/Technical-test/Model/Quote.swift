//
//  Quote.swift
//  Technical-test
//
//  Created by Patrice MIAKASSISSA on 29.04.21.
//

import Foundation

struct Quote: Codable {
    var symbol: String?
    var name: String?
    var currency: String?
    var readableLastChangePercent: String?
    var last: String?
    var variationColor: String?
    var key: String?
    var myMarket: Market?
    var isFavorite: Bool = false

    enum CodingKeys: String, CodingKey {
        case symbol, name, currency, readableLastChangePercent, last, variationColor, key
    }
}
