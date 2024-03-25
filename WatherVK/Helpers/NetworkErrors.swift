//
//  NetworkErrors.swift
//  WatherVK
//
//  Created by Ксения Кобак on 25.03.2024.
//

import Foundation

enum NetworkError: Error {
    case authError
    case messageError(String)
    case serverUnavailable
    case unownedError
    case invalidURL
    case networkError
    case statusCodeError
    case parseError
    case notFound
    
    var describing: String {
        switch self {
        case .authError:
            return "ошибка авторизации"
        case .messageError(let message):
            return message
        case .serverUnavailable:
            return "все упало"
        case .unownedError:
            return "Неизвестная ошибка. До свидания"
        case .invalidURL:
            return "API Error: Неправильно указан URL."
        case .networkError:
            return "Ошибка сети. Попробовать загрузить данные еще раз?"
        case .statusCodeError:
            return "Ошибка получения кода статуса. Обратитесь к разработчику"
        case .parseError:
            return "Ошибка парсинга данных. Обратитесь к разработчику"
        case .notFound:
            return "Неудачный запрос, не найдено на сервере"
        }
    }
}
