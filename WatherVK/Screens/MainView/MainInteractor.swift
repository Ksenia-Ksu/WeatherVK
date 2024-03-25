//
//  MainInteractor.swift
//  WatherVK
//
//  Created by Ксения Кобак on 22.03.2024.
//

import Foundation
import CoreLocation

protocol WeatherInteractorProtocol {
    func fetchWeatherWithCity(name: String)
    func fetchWeatherWithCoordinates(lat: CLLocationDegrees, lon: CLLocationDegrees)
    func loadLocation()
}

final class MainInteractor: NSObject, WeatherInteractorProtocol {
   
    private let presenter: WeatherPresentationProtocol
    private let networkManager: NetworkServiceProtocol
    private let JSONCache: FileCaching
    private let locationManager = CLLocationManager()
    
    init(presenter: WeatherPresentationProtocol, networkingManager: NetworkServiceProtocol, JSONCache: FileCaching ) {
        self.presenter = presenter
        self.networkManager = networkingManager
        self.JSONCache = JSONCache
        super.init()
        locationManager.delegate = self
    }
    
    func fetchWeatherWithCity(name: String) {
        self.networkManager.getCityWheatherWith(name: name) { response in
            switch response {
            case let .success(items):
                if !items.isEmpty {
                    self.JSONCache.add(city: name, models: items)
                    self.JSONCache.saveAllTasksToJSONFile(named: "Weather")
                    self.presenter.presentData(items)
                } else {
                    self.presenter.presentError()
                }
            case let .failure(error):
                self.presenter.presentError()
            }
        }
    }
    
    func fetchWeatherWithCoordinates(lat: CLLocationDegrees, lon: CLLocationDegrees ) {
        self.networkManager.getCityWheatherWithCoord(
            lat: lat,
            lon: lon) { response in
                switch response {
                case let .success(items):
                    self.presenter.presentData(items)
                    if !items.isEmpty {
                        self.JSONCache.loadItems(named: "Weather") { response in
                            switch response {
                            case .success(_):
                                print("success")
                            case let .failure(error):
                              print(error.localizedDescription)
                            }
                        }
                        self.JSONCache.add(city: items[0].cityName, models: items)
                        self.JSONCache.saveAllTasksToJSONFile(named: "Weather")
                    }
                case let .failure(error):
                    self.presenter.presentError()
                }
            }
    }
    
    func loadLocation() {
        switch locationManager.authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse:
            locationManager.requestLocation()
        case .notDetermined:
            locationManager.requestAlwaysAuthorization()
            locationManager.requestWhenInUseAuthorization()
        case .restricted, .denied:
            presenter.presentError()
        @unknown default:
            print("no auth")
        }
    }
    
}

// MARK: - CLLocationManagerDelegate
extension MainInteractor: CLLocationManagerDelegate {
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
//        locationManager.requestLocation()
//        locationManager.startUpdatingLocation()
//        locationManager.stopUpdatingLocation()
        //self.fetchWeatherWithCoordinates(
        //    lat:  locationManager.location?.coordinate.latitude ??  55.755786 ,
        //    lon: locationManager.location?.coordinate.longitude ?? 37.617633)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print(locations)
        locationManager.stopUpdatingLocation()
        if let location = locations.last {
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            self.fetchWeatherWithCoordinates(lat: lat, lon: lon)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: any Error) {
        print(error)
    }
}

