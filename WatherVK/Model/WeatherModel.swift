//
//  WeatherModel.swift
//  WatherVK
//
//  Created by Ксения Кобак on 21.03.2024.
//

struct WeatherModel {
    
    let conditionId: Int
    let cityName: String
    let temperature: String
    let maxTemp: String
    let minTemp: String
    let wind: String
    let date: String
    let description: String
    
    var conditionName: String {
        switch conditionId {
        case 200...232:
            return "cloud.bolt"
        case 300...321:
            return "cloud.drizzle"
        case 500...531:
            return "cloud.rain"
        case 600...622:
            return "cloud.snow"
        case 701...781:
            return "cloud.fog"
        case 800:
            return "sun.max"
        case 801...804:
            return "cloud"
        default:
            return "cloud"
        }
    }
}

extension WeatherModel {
    private enum Keys {
        static let conditionId = "conditionId"
        static let cityName = "cityName"
        static let temperature = "temperature"
        static let maxTemp = "maxTemp"
        static let minTemp = "minTemp"
        static let wind = "wind"
        static let date = "date"
        static let description = "description"
    }
}

extension WeatherModel {
    
    var json: Any {
        var json: [String: Any] = [
            Keys.conditionId: conditionId,
            Keys.cityName: cityName,
            Keys.temperature: temperature,
            Keys.maxTemp: maxTemp,
            Keys.minTemp: minTemp,
            Keys.wind: wind,
            Keys.date: date,
            Keys.description: description,
        ]
        return json
    }
    
    static func parseFrom(json: Any) -> WeatherModel? {
        guard let json = json as? [String: Any] else { return nil }
        
        guard let conditionId = json[Keys.conditionId] as? Int,
              let cityName = json[Keys.cityName] as? String,
              let temperature = json[Keys.temperature] as? String,
              let maxTemp = json[Keys.maxTemp] as? String,
              let minTemp = json[Keys.minTemp] as? String,
              let wind = json[Keys.wind] as? String,
              let date = json[Keys.date] as? String,
              let description = json[Keys.description] as? String
        else { return nil }
        
        let item = WeatherModel(conditionId: conditionId,
                                cityName: cityName,
                                temperature: temperature,
                                maxTemp: maxTemp,
                                minTemp: minTemp,
                                wind: wind,
                                date: date,
                                description: description)
        
        return item
    }
}

