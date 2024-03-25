//
//  NetworkService.swift
//  WatherVK
//
//  Created by Ксения Кобак on 21.03.2024.
//

import Foundation
import CoreLocation

protocol NetworkServiceProtocol {
    func getCityWheatherWith(name: String, completion: @escaping (Result<[WeatherModel], Error>) -> Void)
    func getCityWheatherWithCoord(lat: CLLocationDegrees, lon: CLLocationDegrees, completion: @escaping (Result<[WeatherModel], Error>) -> Void)
}

final class NetworkService: NetworkServiceProtocol {
    
    private let queue = DispatchQueue(label: "Network queue", attributes: [.concurrent])
    
    private let api = "0f46e9b537dd8ead3545fea77235afad"
    private let weatherURL = "https://api.openweathermap.org/data/2.5/forecast?&exclude=daily&units=metric&lang=ru"
    
    // MARK: - get coord
    func getCityWheatherWithCoord(lat: CLLocationDegrees, lon: CLLocationDegrees, completion: @escaping (Result<[WeatherModel], any Error>) -> Void) {
        queue.async {
            let url = "\(self.weatherURL)&lat=\(lat)&lon=\(lon)&appid=\(self.api)"
            guard let url = URL(string: url)   else { return }
            let session = URLSession(configuration: .default)
            let request = URLRequest(url: url)
            let task = session.dataTask(with: request) { data, _, error in
                if let data = data {
                    
                    let items = self.parseJSONData(data)
                    DispatchQueue.main.async {
                        completion(.success(items))
                    }
                }
                
                if let error = error {
                    DispatchQueue.main.async {
                        completion(.failure(error))
                    }
                    return
                }
            }
            task.resume()
        }
    }
    // MARK: - get name
    func getCityWheatherWith(name: String, completion: @escaping (Result<[WeatherModel], any Error>) -> Void) {
        queue.async {
            let url = "\(self.weatherURL)&q=\(name)&appid=\(self.api)"
            guard let url = URL(string: url)   else { return }
            let session = URLSession(configuration: .default)
            let request = URLRequest(url: url)
            let task = session.dataTask(with: request) { data, _, error in
                if let data = data {
                    let items = self.parseJSONData(data)
                    DispatchQueue.main.async {
                        completion(.success(items))
                    }
                }
                if let error = error {
                    DispatchQueue.main.async {
                        completion(.failure(error))
                    }
                    return
                }
            }
            task.resume()
        }
    }
    
    // MARK: - parse json
    private func parseJSONData(_ weatherData: Data) -> [WeatherModel] {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(WeatherWeek.self, from: weatherData)
            let list = decodedData.list
            
            let filtered = list.filter {$0.dtTxt.contains("21:00:00")}
            var models: [WeatherModel] = []
            filtered.forEach {
                let model = WeatherModel(conditionId: $0.weather[0].id,
                                         cityName: decodedData.city.name,
                                         temperature: String(Int($0.main.temp)),
                                         maxTemp: String(Int($0.main.tempMax)),
                                         minTemp: String(Int($0.main.tempMin)),
                                         wind: String($0.wind.speed),
                                         date: $0.dtTxt,
                                         description: $0.weather[0].description)
                models.append(model)
            }
            return models
        } catch {
            print(error)
            return []
        }
    }
}
