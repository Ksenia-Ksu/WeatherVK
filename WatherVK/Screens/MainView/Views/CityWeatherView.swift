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
        currentLabel.text = "Тeкущее место"
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
           
            self.currentLabel.topAnchor.constraint(equalTo: self.layoutMarginsGuide.topAnchor, constant: 5),
            self.currentLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 0),
            
            self.activityIndicator.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            self.activityIndicator.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            
            self.currentCity.topAnchor.constraint(equalTo: currentLabel.bottomAnchor, constant: 10),
            self.currentCity.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 0),
            
            self.hstack.topAnchor.constraint(equalTo: currentCity.bottomAnchor, constant: 10),
            self.hstack.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 0),
            
            self.currentDescription.topAnchor.constraint(equalTo: currentTemp.bottomAnchor, constant: 10),
            self.currentDescription.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 0),
            
            self.currentWind.topAnchor.constraint(equalTo: currentDescription.bottomAnchor, constant: 5),
            self.currentWind.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 0),
            
            self.maxTemp.topAnchor.constraint(equalTo: currentWind.bottomAnchor, constant: 5),
            self.maxTemp.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 0),
            
            self.minTemp.topAnchor.constraint(equalTo: maxTemp.bottomAnchor, constant: 5),
            self.minTemp.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 0),
            
            self.tableView.heightAnchor.constraint(equalToConstant: 300),
            
            self.tableView.bottomAnchor.constraint(equalTo: self.layoutMarginsGuide.bottomAnchor, constant: 0),
            self.tableView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10),
            self.tableView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -10),
        ])
    }
}

// MARK: - DisplaysWeather
extension CityWeatherView: DisplaysWeather {
    
    func displayError() {
        stopLoading()
        self.tableView.isHidden = true
        self.currentLabel.text = "Город не найден"
    }
    
    func configure(with viewModel: [WeatherModel]) {
        self.weatherData = viewModel
        if !viewModel.isEmpty {
            currentLabel.text = "Тeкущее место"
            currentCity.text = viewModel[0].cityName
            currentTemp.text = viewModel[0].temperature
            imageView.image = UIImage(systemName: viewModel[0].conditionName)
            currentDescription.text = viewModel[0].description
            currentWind.text = "Cкорость ветра: " + viewModel[0].wind
            maxTemp.text = "Maкс.темп: " + viewModel[0].maxTemp
            minTemp.text = "Mин.темп: " + viewModel[0].minTemp
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
        "Погода на 5 дней"
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as? WeatherCell
       
        cell?.configure(text: weatherData[indexPath.row].date,
                        temp: weatherData[indexPath.row].temperature + "",
                        image: weatherData[indexPath.row].conditionName)
        return cell ?? UITableViewCell()
    }
}
