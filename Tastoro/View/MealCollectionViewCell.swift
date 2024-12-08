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
    private let areaLabelContainer = UIView()

    override init(frame: CGRect) {
        super.init(frame: frame)

        contentView.layer.cornerRadius = 12
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor.lightGray.cgColor
        contentView.layer.masksToBounds = true

        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.1
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowRadius = 4
        layer.masksToBounds = false

        mealImageView.translatesAutoresizingMaskIntoConstraints = false
        mealLabel.translatesAutoresizingMaskIntoConstraints = false
        areaLabel.translatesAutoresizingMaskIntoConstraints = false
        areaLabelContainer.translatesAutoresizingMaskIntoConstraints = false

        mealLabel.font = UIFont.systemFont(ofSize: UIFont.preferredFont(forTextStyle: .subheadline).pointSize, weight: .semibold)
        mealLabel.textAlignment = .left
        mealLabel.numberOfLines = 2

        areaLabel.font = UIFont.preferredFont(forTextStyle: .caption2)
        areaLabel.textColor = .white
        areaLabel.textAlignment = .center

        areaLabelContainer.backgroundColor = UIColor(named: "secondaryRed")
        areaLabelContainer.layer.cornerRadius = 12
        areaLabelContainer.layer.masksToBounds = true

        contentView.addSubview(mealImageView)
        contentView.addSubview(mealLabel)
        contentView.addSubview(areaLabelContainer)
        areaLabelContainer.addSubview(areaLabel)

        NSLayoutConstraint.activate([
            mealImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            mealImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            mealImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            mealImageView.heightAnchor.constraint(equalTo: mealImageView.widthAnchor),

            mealLabel.topAnchor.constraint(equalTo: mealImageView.bottomAnchor),
            mealLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            mealLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),

            areaLabelContainer.topAnchor.constraint(equalTo: mealLabel.bottomAnchor),
            areaLabelContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            areaLabelContainer.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),

            areaLabel.leadingAnchor.constraint(equalTo: areaLabelContainer.leadingAnchor, constant: 12),
            areaLabel.trailingAnchor.constraint(equalTo: areaLabelContainer.trailingAnchor, constant: -12),
            areaLabel.topAnchor.constraint(equalTo: areaLabelContainer.topAnchor, constant: 6),
            areaLabel.bottomAnchor.constraint(equalTo: areaLabelContainer.bottomAnchor, constant: -6)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
