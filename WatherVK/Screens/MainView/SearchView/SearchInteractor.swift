//
//  File.swift
//  WatherVK
//
//  Created by Ксения Кобак on 25.03.2024.
//

import Foundation

protocol SearchInteractorProtocol: AnyObject {
    func loadItems()
    func deleteItem(city: String)
}

final class SearchInteractor: SearchInteractorProtocol {
   
    private let presenter: SearchPresenterProtocol
    private let JSONCache: FileCaching
    
    init(presenter: SearchPresenterProtocol, JSONCache: FileCaching ) {
        self.presenter = presenter
        self.JSONCache = JSONCache
    }
    
    func loadItems() {
        JSONCache.loadItems(named: "Weather") { response in
            switch response {
            case let .success(items):
                self.presenter.presentList(list: items)
            case let .failure(error):
                self.presenter.presentList(list: [:])
                print(error.localizedDescription)
            }
        }
    }
    
    func deleteItem(city: String) {
        JSONCache.delete(city: city)
        presenter.reloadData()
    }
    
}
