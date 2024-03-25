//
//  SearchView.swift
//  WatherVK
//
//  Created by Ксения Кобак on 22.03.2024.
//

import UIKit

protocol CellActionHandleProtocol: AnyObject {
    func deleteCity(city: String)
    func showWheather(city: String)
}

protocol SearcBarHandleProtocol: UIView {
    func searchBarIsTapped(city: String)
    func searchBarIsCanceled()
    func configureView(list: [String])
    func reloadData()
}

final class SearchView: UIView {
    
    var cities: [String]
    weak var delegate: CellActionHandleProtocol? 
    let searchBarDelegate: UISearchBarDelegate
    
    private lazy var search: UISearchBar = {
        let search = UISearchBar()
        search.barTintColor = Colors.background
        search.translatesAutoresizingMaskIntoConstraints = false
        return search
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.keyboardDismissMode = .onDrag
        tableView.isUserInteractionEnabled = true
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.backgroundColor = Colors.background
        return tableView
    }()
    
    init(cities: [String], delegate: CellActionHandleProtocol, searchBarDelegate: UISearchBarDelegate) {
        self.cities = cities
        self.searchBarDelegate = searchBarDelegate
        super.init(frame: .zero)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.search.delegate = searchBarDelegate
        self.delegate = delegate
        setupView()
        setupConstraint()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        self.backgroundColor = Colors.background
        self.addSubview(search)
        self.addSubview(tableView)
    }
    
    private func setupConstraint() {
        NSLayoutConstraint.activate([
            
            self.search.topAnchor.constraint(equalTo: self.layoutMarginsGuide.topAnchor, constant: 0),
            self.search.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0),
            self.search.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 0),
            
            self.tableView.topAnchor.constraint(equalTo: self.search.bottomAnchor, constant: Layout.insets.top),
            self.tableView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: Layout.insets.left),
            self.tableView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: Layout.insets.right),
            self.tableView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: Layout.insets.bottom),
        ])
    }
}
// MARK: - UITableViewDataSource UITableViewDelegate
extension SearchView: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        cities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        var content = cell?.defaultContentConfiguration()
        content?.text = cities[indexPath.row]
        content?.textProperties.color = Colors.text ?? .white
        cell?.contentConfiguration = content
        cell?   .backgroundColor = UIColor.clear
        return cell ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.delegate?.showWheather(city: cities[indexPath.row])
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Удалить") { [weak self] _, _, _ in
            if let city = self?.cities[indexPath.row] {
                self?.delegate?.deleteCity(city: city)
                self?.cities.remove(at: indexPath.row)
            }
            tableView.reloadData()
        }
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}
// MARK: - SearcBarHandleProtocol
extension SearchView: SearcBarHandleProtocol {
    func configureView(list: [String]) {
        self.cities = list
        tableView.reloadData()
    }
    
    func reloadData() {
        tableView.reloadData()
    }
    
    func searchBarIsTapped(city: String) {
        self.delegate?.showWheather(city: city)
    }
    
    func searchBarIsCanceled() {
        search.text = ""
    }
}

extension SearchView {
    enum Layout {
        static let insets: UIEdgeInsets = UIEdgeInsets(top: 20, left: 5, bottom: -20, right: -10)
    }
}
