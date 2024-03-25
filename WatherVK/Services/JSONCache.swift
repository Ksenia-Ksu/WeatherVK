//
//  JSONCache.swift
//  WatherVK
//
//  Created by Ксения Кобак on 25.03.2024.
//

import Foundation

protocol FileCaching {
    var items: [String: [WeatherModel]] { get }
    func add(city: String, models: [WeatherModel])
    func delete(city: String)
    func loadItems(named: String, completion: @escaping (Result<[String: [WeatherModel]], Error>) -> Void)
    func saveAllTasksToJSONFile(named: String)
}

final class FileCache: FileCaching {
    
    private static var uniqueIService: FileCache?

      private init() {}

      static func shared() -> FileCache {
          if uniqueIService == nil {
              uniqueIService = FileCache()
          }
          return uniqueIService!
      }
    
    private let fileManager = FileManager.default
    private let queue = DispatchQueue(label: "Queue")
    
    private(set) var items: [String: [WeatherModel]] = [:]
    // MARK: - add
    func add(city: String, models: [WeatherModel]) {
        if items[city] != nil {
            items[city] = models
        } else {
            items[city] = models
        }
    }
    // MARK: - delete
    func delete(city: String)  {
        if items[city] != nil {
            items[city] = nil
        }
    }
    // MARK: - save
    func saveAllTasksToJSONFile(named: String) {
        guard let url = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        
        let documentsDirectoryPath = URL(fileURLWithPath: url.path)
        let pathSearch = documentsDirectoryPath.appendingPathComponent("\(named).json")
        if !fileManager.fileExists(atPath: pathSearch.path) {
            fileManager.createFile(atPath: pathSearch.path, contents: nil)
        }
        writeToJSONFileAt(fileUrl: pathSearch)
    }
    // MARK:
    func loadItems(named: String, completion: @escaping (Result<[String: [WeatherModel]], Error>) -> Void) {
        queue.async {
            var loadedItems: [String: [WeatherModel]] = [:]
            guard let url = self.fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else { return}
            
            let documentsDirectoryPath = URL(fileURLWithPath: url.path)
            let pathSearch = documentsDirectoryPath.appendingPathComponent("\(named).json")
            do {
                let data = try Data(contentsOf: pathSearch)
                guard let jsonObject =  try JSONSerialization.jsonObject(with: data, options: []) as? [String: [[String: Any]]] else { return }
                for json in jsonObject {
                    for item in json.value {
                        if let newItem = WeatherModel.parseFrom(json: item) {
                            if  loadedItems[newItem.cityName] != nil {
                                loadedItems[newItem.cityName]?.append(newItem)
                             
                            } else {
                                loadedItems[newItem.cityName] = [newItem]
                            }
                        }
                    }
                }
                self.items = loadedItems
                DispatchQueue.main.async {
                    completion(.success(loadedItems))
                }
            } catch let error {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                print("Error if loading json file: \(error.localizedDescription)")
            }
        }
    }
    
    private func writeToJSONFileAt(fileUrl: URL) {
        var dict: [String: [[String: Any]]] = [:]
        for item in items {
            let value = item.value
            let key = item.key
            for model in value {
                if let newModel = model.json as? [String: Any] {
                    if dict[key] != nil {
                        dict[key]?.append(newModel)
                    } else {
                        dict[key] = [newModel]
                    }
                }
            }
        }
        do {
            let data = try JSONSerialization.data(withJSONObject: dict)
            try data.write(to: fileUrl, options: [])
        } catch {
            print("Error of savingData to JSON file \(error.localizedDescription)")
        }
    }
}
