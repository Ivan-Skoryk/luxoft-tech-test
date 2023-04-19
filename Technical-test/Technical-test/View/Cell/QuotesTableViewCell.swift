//
//  QuotesTableViewCell.swift
//  Technical-test
//
//  Created by Ivan Skoryk on 19.04.2023.
//

import Foundation
import UIKit

fileprivate enum Constants {
    static let favoriteImage = "favorite"
    static let noFavoriteImage = "no-favorite"
}

fileprivate enum PercentColor: String {
    case red
    case green
    case gray

    var uiColor: UIColor {
        switch self {
        case .red: return .red
        case .green: return .green
        case .gray: return .gray
        }
    }
}

final class QuotesTableViewCell: UITableViewCell {
    @IBOutlet private var nameLabel: UILabel!
    @IBOutlet private var lastLabel: UILabel!
    @IBOutlet private var readableLastChangePercentLabel: UILabel!
    @IBOutlet private var favoriteImageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()

        nameLabel.text = nil
        lastLabel.text = nil
        readableLastChangePercentLabel.text = nil
        readableLastChangePercentLabel.textColor = .black
        favoriteImageView.image = UIImage(named: Constants.noFavoriteImage)
    }

    func setup(with quote: Quote) {
        nameLabel.text = quote.name
        lastLabel.text = quote.last
        readableLastChangePercentLabel.text = quote.readableLastChangePercent
        readableLastChangePercentLabel.textColor = getColor(for: quote.variationColor)
        favoriteImageView.image = UIImage(named: quote.isFavorite ? Constants.favoriteImage : Constants.noFavoriteImage)
    }

    private func getColor(for strColor: String?) -> UIColor {
        if let strColor = strColor,
           let percentColor = PercentColor(rawValue: strColor) {
            return percentColor.uiColor
        }

        return .black
    }
}
