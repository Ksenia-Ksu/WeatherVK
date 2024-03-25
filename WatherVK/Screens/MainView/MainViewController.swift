//
//  ViewController.swift
//  WatherVK
//
//  Created by Ксения Кобак on 21.03.2024.
//

import UIKit

protocol DisplayModels: AnyObject {
    func displayFetchedModels(_ viewModel: [WeatherModel])
    func displayError()
    func displayCachedModels(_ viewModel: [WeatherModel])
}

final class MainViewController: UIViewController {
    
    private lazy var contentView: DisplaysWeather = CityWeatherView(weatherData: [])
    private var interactor: WeatherInteractorProtocol
    private var openWithCity: String?
    
    init (interactor: WeatherInteractorProtocol, openWithCity: String?) {
        self.interactor = interactor
        self.openWithCity = openWithCity
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        self.view = contentView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let city = openWithCity {
            contentView.startLoading()
            self.interactor.fetchWeatherWithCity(name: city)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        contentView.startLoading()
        if let city = openWithCity {
            contentView.startLoading()
            self.interactor.fetchWeatherWithCity(name: city)
        } else {
            self.interactor.loadLocation()
        }
        navBarSetup()
    }
    // MARK: - navBarSetup
    private func navBarSetup() {
        let rightButton = UIBarButtonItem(image: UIImage(systemName: SFSymbols.search ), style: .plain, target: self, action: #selector(openSearch(sender:)))
        rightButton.tintColor = Colors.text
        navigationItem.rightBarButtonItem = rightButton
        
        let left = UIBarButtonItem(image: UIImage(systemName: SFSymbols.geoPoint ), style: .plain, target: self, action: #selector(checkLocation(sender:)))
        left.tintColor = Colors.text
        navigationItem.leftBarButtonItem = left
    }
    
    @objc func openSearch(sender: UIBarButtonItem) {
        let vc = SearchModuleBuilder().build()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func checkLocation(sender: UIBarButtonItem) {
        interactor.loadLocation()
    }
}
// MARK: - DisplayModels
extension MainViewController: DisplayModels {
    func displayError() {
        self.contentView.displayError()
    }
    
    func displayCachedModels(_ viewModel: [WeatherModel]) {
        self.contentView.configure(with: viewModel)
    }
    
    func displayFetchedModels(_ viewModel: [WeatherModel]) {
        self.contentView.configure(with: viewModel)
        self.contentView.stopLoading()
    }
}


