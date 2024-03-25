//
//  Constants.swift
//  WatherVK
//
//  Created by Ксения Кобак on 22.03.2024.
//

import UIKit

struct Colors {
    static let background = UIColor(named: "BackgroundColor")
    static let text = UIColor(named: "TextColor")
}

struct SFSymbols {
    static let geoPoint = "location.circle.fill"
    static let search = "magnifyingglass"
}

struct Formatter {
    static func dateFormatter(string: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.locale = Locale(identifier: "ru_RU")
        let date = dateFormatter.date(from: string)
        dateFormatter.setLocalizedDateFormatFromTemplate("MMMMd")
        return(dateFormatter.string(from: date!))
    }
}

extension String {
    func firstCharUpperCased() -> String {
        return prefix(1).uppercased() + self.dropFirst()
    }
}

