//
//  UserDefaultsManager.swift
//  Technical-test
//
//  Created by Vladislav Kliutko on 19.04.2023.
//

import Foundation

fileprivate enum Constants {
    static let favouriteQuotes = "favoriteQuotes"
}

final class UserDefaultsManager {
    static let shared = UserDefaultsManager()

    private var defaults = UserDefaults.standard

    var favoriteQuotes: Set<String> {
        get {
            guard let data = defaults.value(forKey: Constants.favouriteQuotes) as? Data else { return [] }
            let set = try? JSONDecoder().decode(Set<String>.self, from: data)
            return set ?? []
        }
        set {
            let data = try? JSONEncoder().encode(newValue)
            defaults.setValue(data, forKey: Constants.favouriteQuotes)
            defaults.synchronize()
        }
    }
}
