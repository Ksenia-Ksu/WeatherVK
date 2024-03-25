//
//  MainModuleBuilder.swift
//  WatherVK
//
//  Created by Ксения Кобак on 22.03.2024.
//

import UIKit

struct MainModuleBuilder {
    func build(context: String?) -> UIViewController {
        let networkServise = NetworkService()
        let JSONCache = FileCache.shared()
        let presenter = MainPresenter()
        let interactor = MainInteractor(presenter: presenter, networkingManager: networkServise, JSONCache: JSONCache)
        if let city = context {
            let vc = MainViewController(interactor: interactor, openWithCity: city)
            presenter.controller = vc
            return vc
        } else {
            let vc = MainViewController(interactor: interactor, openWithCity: nil)
            presenter.controller = vc
            return vc
        }
    }
}
