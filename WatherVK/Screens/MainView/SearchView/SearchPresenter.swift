//
//  SearchPresenter.swift
//  WatherVK
//
//  Created by Ксения Кобак on 25.03.2024.
//

import Foundation

protocol SearchPresenterProtocol {
    func presentList(list:[String: [WeatherModel]])
    func reloadData()
}

final class SearchPresenter: SearchPresenterProtocol {
    
    weak var controller: DisplayList?
    
    func reloadData() {
        self.controller?.reloadData()
    }
    
    func presentList(list: [String : [WeatherModel]])  {
        let cities = list.keys.sorted(by: <)
        self.controller?.displayCachedCities(list: cities)
    }
}
