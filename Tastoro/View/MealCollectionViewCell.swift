//
//  MealCollectionViewCell.swift
//  Tastoro
//
//  Created by Rangga Biner on 04/12/24.
//

import UIKit

class MealCollectionViewCell: UICollectionViewCell {
    let mealImageView = UIImageView()
    let mealLabel = UILabel()
    let areaLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        mealImageView.translatesAutoresizingMaskIntoConstraints = false
        mealLabel.translatesAutoresizingMaskIntoConstraints = false
        areaLabel.translatesAutoresizingMaskIntoConstraints = false
        
        mealLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        mealLabel.textAlignment = .left
        mealLabel.numberOfLines = 2

        areaLabel.font = UIFont.systemFont(ofSize: 14, weight: .light)
        areaLabel.textColor = .gray
        areaLabel.textAlignment = .left

        contentView.addSubview(mealImageView)
        contentView.addSubview(mealLabel)
        contentView.addSubview(areaLabel)

        NSLayoutConstraint.activate([
            mealImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            mealImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            mealImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            mealImageView.heightAnchor.constraint(equalTo: mealImageView.widthAnchor),

            mealLabel.topAnchor.constraint(equalTo: mealImageView.bottomAnchor, constant: 8),
            mealLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 4),
            mealLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -4),

            areaLabel.topAnchor.constraint(equalTo: mealLabel.bottomAnchor, constant: 4),
            areaLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 4),
            areaLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -4),
            areaLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
