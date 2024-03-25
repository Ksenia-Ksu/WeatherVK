//
//  SearchModuleBuilder.swift
//  WatherVK
//
//  Created by Ксения Кобак on 25.03.2024.
//

import UIKit

struct SearchModuleBuilder {
    func build() -> UIViewController {
        let JSONCache = FileCache.shared()
        let presenter = SearchPresenter()
        let interactor = SearchInteractor(presenter: presenter, JSONCache: JSONCache)
        let vc = SearchViewController(interactor: interactor)
        presenter.controller = vc
        return vc
    }
}
