//
//  CityWeatherView.swift
//  WatherVK
//
//  Created by Ксения Кобак on 21.03.2024.
//

import UIKit

protocol DisplaysWeather: UIView {
    func configure(with viewModel: [WeatherModel])
    func displayError()
    func startLoading()
    func stopLoading()
}

final class CityWeatherView: UIView {
    
    var weatherData: [WeatherModel]
    
    private lazy var topView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "light")
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor =  Colors.text?.withAlphaComponent(0.3)
        tableView.layer.cornerRadius = 15
        tableView.isHidden = true
        tableView.register(WeatherCell.self, forCellReuseIdentifier: "Cell")
        return tableView
    }()
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        return activityIndicator
    }()
    
    private lazy var currentLabel: UILabel = {
        let currentLabel = UILabel()
        tableView.isHidden = true
        currentLabel.textColor = Colors.text
        currentLabel.font = UIFont.boldSystemFont(ofSize: 25)
        currentLabel.translatesAutoresizingMaskIntoConstraints = false
        return currentLabel
    }()
    
    private lazy var currentCity: UILabel = {
        let currentCity = UILabel()
        currentCity.textColor = Colors.text
        currentCity.font = UIFont.boldSystemFont(ofSize: 20)
        currentCity.translatesAutoresizingMaskIntoConstraints = false
        return currentCity
    }()
    
    private lazy var hstack: UIStackView = {
        let hstack = UIStackView()
        hstack.axis = .horizontal
        hstack.spacing = 40
        hstack.translatesAutoresizingMaskIntoConstraints = false
        return hstack
    }()
    
    private lazy var currentTemp: UILabel = {
        let currentTemp = UILabel()
        currentTemp.font = UIFont.boldSystemFont(ofSize: 50)
        currentTemp.textColor = Colors.text
        currentTemp.translatesAutoresizingMaskIntoConstraints = false
        return currentTemp
    }()
    
   private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.tintColor = Colors.text
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var currentDescription: UILabel = {
        let currentDescription = UILabel()
        currentDescription.textColor = Colors.text
        currentDescription.font = UIFont.boldSystemFont(ofSize: 20)
        currentDescription.translatesAutoresizingMaskIntoConstraints = false
        return currentDescription
    }()
    
    private lazy var currentWind: UILabel = {
        let currentWind = UILabel()
        currentWind.textColor = Colors.text
        currentWind.font = UIFont.boldSystemFont(ofSize: 15)
        currentWind.translatesAutoresizingMaskIntoConstraints = false
        return currentWind
    }()
    
    private lazy var maxTemp: UILabel = {
        let maxTemp = UILabel()
        maxTemp.textColor = Colors.text
        maxTemp.font = UIFont.boldSystemFont(ofSize: 15)
        maxTemp.translatesAutoresizingMaskIntoConstraints = false
        return maxTemp
    }()
    
    private lazy var minTemp: UILabel = {
        let minTemp = UILabel()
        minTemp.textColor = Colors.text
        minTemp.font = UIFont.boldSystemFont(ofSize: 15)
        minTemp.translatesAutoresizingMaskIntoConstraints = false
        return minTemp
    }()
    
    init(weatherData: [WeatherModel]) {
        self.weatherData = weatherData
        super.init(frame: .zero)
        self.backgroundColor = .white
        self.tableView.delegate = self
        self.tableView.dataSource = self
        setupView()
        setupConstraint()
    }
   
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        self.backgroundColor = Colors.background
        self.addSubview(topView)
        topView.addSubview(currentLabel)
        topView.addSubview(currentCity)
        topView.addSubview(hstack)
        hstack.addArrangedSubview(imageView)
        hstack.addArrangedSubview(currentTemp)
        topView.addSubview(currentDescription)
        topView.addSubview(currentWind)
        topView.addSubview(maxTemp)
        topView.addSubview(minTemp)
        topView.addSubview(tableView)
        topView.addSubview(activityIndicator)
    }

    private func setupConstraint() {
         NSLayoutConstraint.activate([
            
            self.topView.topAnchor.constraint(equalTo: self.topAnchor),
            self.topView.leftAnchor.constraint(equalTo: self.leftAnchor),
            self.topView.rightAnchor.constraint(equalTo: self.rightAnchor),
            self.topView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
           
            self.currentLabel.topAnchor.constraint(equalTo: self.layoutMarginsGuide.topAnchor, constant: Layout.minTop),
            self.currentLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 0),
            
            self.activityIndicator.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            self.activityIndicator.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            
            self.currentCity.topAnchor.constraint(equalTo: currentLabel.bottomAnchor, constant: Layout.minTop),
            self.currentCity.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 0),
            
            self.hstack.topAnchor.constraint(equalTo: currentCity.bottomAnchor, constant: Layout.maxtop),
            self.hstack.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 0),
            
            self.currentDescription.topAnchor.constraint(equalTo: currentTemp.bottomAnchor, constant: Layout.maxtop),
            self.currentDescription.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 0),
            
            self.currentWind.topAnchor.constraint(equalTo: currentDescription.bottomAnchor, constant: Layout.minTop),
            self.currentWind.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 0),
            
            self.maxTemp.topAnchor.constraint(equalTo: currentWind.bottomAnchor, constant: Layout.minTop),
            self.maxTemp.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 0),
            
            self.minTemp.topAnchor.constraint(equalTo: maxTemp.bottomAnchor, constant: Layout.minTop),
            self.minTemp.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 0),
            
            self.tableView.heightAnchor.constraint(equalToConstant: Layout.TableView.height),
            
            self.tableView.bottomAnchor.constraint(equalTo: self.layoutMarginsGuide.bottomAnchor, constant: Layout.TableView.insets.bottom),
            self.tableView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: Layout.TableView.insets.left),
            self.tableView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: Layout.TableView.insets.right),
        ])
    }
}

// MARK: - DisplaysWeather
extension CityWeatherView: DisplaysWeather {
    
    func displayError() {
        stopLoading()
        self.tableView.isHidden = true
        self.currentLabel.text = Text.cityError
    }
    
    func configure(with viewModel: [WeatherModel]) {
        self.weatherData = viewModel
        if !viewModel.isEmpty {
            currentLabel.text = Text.currentLocation
            currentCity.text = viewModel[0].cityName
            currentTemp.text = viewModel[0].temperature
            imageView.image = UIImage(systemName: viewModel[0].conditionName)
            currentDescription.text = viewModel[0].description
            currentWind.text = Text.wind + viewModel[0].wind
            maxTemp.text = Text.max + viewModel[0].maxTemp
            minTemp.text = Text.min + viewModel[0].minTemp
        }
        tableView.reloadData()
    }
    
    func startLoading() {
        activityIndicator.startAnimating()
        currentLabel.isHidden = true
        currentCity.isHidden = true
        hstack.isHidden = true
        currentDescription.isHidden = true
        currentWind.isHidden = true
        maxTemp.isHidden = true
        minTemp.isHidden = true
        tableView.isHidden = true
    }
    
    func stopLoading() {
        activityIndicator.stopAnimating()
        tableView.isHidden = false
        currentLabel.isHidden = false
        currentCity.isHidden = false
        hstack.isHidden = false
        currentDescription.isHidden = false
        currentWind.isHidden = false
        maxTemp.isHidden = false
        minTemp.isHidden = false
        tableView.isHidden = false
    }
}

// MARK: - UITableViewDelegate UITableViewDataSource
extension CityWeatherView: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        weatherData.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        Text.headerText
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        Layout.heightRow
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as? WeatherCell
       
        cell?.configure(text: weatherData[indexPath.row].date,
                        temp: weatherData[indexPath.row].temperature + "",
                        image: weatherData[indexPath.row].conditionName)
        return cell ?? UITableViewCell()
    }
}

extension CityWeatherView {
    enum Layout {
        static let heightRow: CGFloat = 50
        static let minTop: CGFloat = 5
        static let maxtop: CGFloat = 10
        
        enum TableView {
            static let height: CGFloat = 300
            static let insets: UIEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: -10)
        }
        
        static let insets: UIEdgeInsets = UIEdgeInsets(top: 20, left: 5, bottom: -20, right: -10)
    }
    
    enum Text {
        static let headerText = "Погода на 5 дней"
        static let cityError =  "Город не найден"
        static let currentLocation = "Тeкущее место"
        static let wind = "Cкорость ветра: "
        static let max = "Maкс.темп: "
        static let min = "Mин.темп: "
    }
    
    
}
