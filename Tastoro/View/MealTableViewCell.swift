//
//  MealTableViewCell.swift
//  Tastoro
//
//  Created by Rangga Biner on 04/12/24.
//

import UIKit

class MealTableViewCell: UITableViewCell {
    let mealImageView = UIImageView()
    let mealLabel = UILabel()
    let areaLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        mealImageView.translatesAutoresizingMaskIntoConstraints = false
        mealLabel.translatesAutoresizingMaskIntoConstraints = false
        areaLabel.translatesAutoresizingMaskIntoConstraints = false
        
        areaLabel.font = UIFont.systemFont(ofSize: 14, weight: .light)
        areaLabel.textColor = .gray
        
        contentView.addSubview(mealImageView)
        contentView.addSubview(mealLabel)
        contentView.addSubview(areaLabel)

        NSLayoutConstraint.activate([
            mealImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            mealImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            mealImageView.widthAnchor.constraint(equalToConstant: 60),
            mealImageView.heightAnchor.constraint(equalToConstant: 60),

            mealLabel.leadingAnchor.constraint(equalTo: mealImageView.trailingAnchor, constant: 16),
            mealLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            mealLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),

            areaLabel.leadingAnchor.constraint(equalTo: mealLabel.leadingAnchor),
            areaLabel.trailingAnchor.constraint(equalTo: mealLabel.trailingAnchor),
            areaLabel.topAnchor.constraint(equalTo: mealLabel.bottomAnchor, constant: 4),
            areaLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
