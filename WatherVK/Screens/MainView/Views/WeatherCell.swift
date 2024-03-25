//
//  WeatherCell.swift
//  WatherVK
//
//  Created by Ксения Кобак on 22.03.2024.
//

import UIKit

final class WeatherCell: UITableViewCell {
    
    private lazy var date: UILabel = {
        let date = UILabel()
        date.font = UIFont.boldSystemFont(ofSize: 17)
        date.textColor = Colors.text
        date.translatesAutoresizingMaskIntoConstraints = false
        return date
    }()
    
    private lazy var image: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "sun.max", withConfiguration: UIImage.SymbolConfiguration(scale: .medium))
        imageView.contentMode = .scaleAspectFill
        imageView.tintColor = Colors.text
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var temp: UILabel = {
        let temp = UILabel()
        temp.font = UIFont.boldSystemFont(ofSize: 20)
        temp.textColor = Colors.text
        temp.translatesAutoresizingMaskIntoConstraints = false
        return temp
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: "Cell")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        selectionStyle = .none
        backgroundColor = UIColor.clear
        addSubviews()
        makeConstraints()
    }
    
    private func addSubviews() {
        addSubview(date)
        addSubview(image)
        addSubview(temp)
    }
    
    private func makeConstraints() {
        
        NSLayoutConstraint.activate([
            self.date.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Layout.insets.left),
            self.date.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Layout.insets.top),
            self.date.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: Layout.insets.bottom),
            
            self.image.leadingAnchor.constraint(equalTo: date.trailingAnchor, constant: Layout.space),
            self.image.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Layout.insets.top),
            self.image.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: Layout.insets.bottom),
            
            self.temp.leadingAnchor.constraint(equalTo: image.trailingAnchor, constant: Layout.space),
            self.temp.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Layout.insets.top),
            self.temp.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: Layout.insets.bottom),
            
        ])
    }
    
    func configure(text: String, temp: String, image: String) {
        self.date.text = text
        self.temp.text = temp
        self.image.image = UIImage(systemName: image, withConfiguration: UIImage.SymbolConfiguration(scale: .medium))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")

    }
}

extension WeatherCell {
    struct Layout {
        static let insets: UIEdgeInsets = UIEdgeInsets(top: 10, left: 16, bottom: 5, right: -16)
        static let space: CGFloat = 15
    }
}


