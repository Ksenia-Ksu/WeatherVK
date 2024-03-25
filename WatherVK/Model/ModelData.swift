//
//  ModelData.swift
//  WatherVK
//
//  Created by Ксения Кобак on 21.03.2024.
//

import Foundation

struct WeatherWeek: Codable {
    let list: [List]
    let city: City
}
// MARK: - City
struct City: Codable {
    let name: String
    let coord: Coord
    let country: String
}
// MARK: - Coord
struct Coord: Codable {
    let lat, lon: Double
}
// MARK: - List
struct List: Codable {
    let main: MainClass
    let weather: [Weather]
    let wind: Wind
    let dtTxt: String

    enum CodingKeys: String, CodingKey {
        case main, weather, wind
        case dtTxt = "dt_txt"
    }
}
// MARK: - MainClass
struct MainClass: Codable {
    let temp, tempMin, tempMax: Double
    let pressure: Int

    enum CodingKeys: String, CodingKey {
        case temp
        case tempMin = "temp_min"
        case tempMax = "temp_max"
        case pressure
    }
}

// MARK: - Weather
struct Weather: Codable {
    let id: Int
    let description: String
 
}
// MARK: - Wind
struct Wind: Codable {
    let speed: Double
}
