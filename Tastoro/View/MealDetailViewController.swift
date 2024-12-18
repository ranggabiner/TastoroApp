//
//  MealDetailViewController.swift
//  Tastoro
//
//  Created by Rangga Biner on 04/12/24.
//

import UIKit

class MealDetailViewController: UIViewController {
    var meal: Meal?
    private let scrollView = UIScrollView()
    private let contentView = UIStackView()
    private let mealImageView = UIImageView()
    private let mealNameLabel = UILabel()
    private let areaLabel = UILabel()
    private let ingredientsLabel = UILabel()
    private let instructionsLabel = UILabel()
    private let areaLabelContainer = UIView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
        configureView()
    }

    private func setupUI() {
        // Konfigurasi ScrollView dan ContentView
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsVerticalScrollIndicator = true
        scrollView.showsHorizontalScrollIndicator = false
        
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.axis = .vertical
        contentView.spacing = 16
        contentView.alignment = .center
        contentView.isLayoutMarginsRelativeArrangement = true

        view.addSubview(scrollView)
        scrollView.addSubview(contentView)

        // Konfigurasi elemen UI lainnya
        mealImageView.translatesAutoresizingMaskIntoConstraints = false
        mealImageView.contentMode = .scaleAspectFill
        mealImageView.clipsToBounds = true

        mealNameLabel.translatesAutoresizingMaskIntoConstraints = false
        mealNameLabel.font = UIFont.boldSystemFont(ofSize: 24)
        mealNameLabel.textAlignment = .center
        mealNameLabel.adjustsFontForContentSizeCategory = true

        areaLabel.translatesAutoresizingMaskIntoConstraints = false
        areaLabel.font = UIFont.preferredFont(forTextStyle: .caption2)
        areaLabel.textColor = .white
        areaLabel.textAlignment = .center

        areaLabelContainer.translatesAutoresizingMaskIntoConstraints = false
        areaLabelContainer.backgroundColor = UIColor(named: "secondaryRed")
        areaLabelContainer.layer.cornerRadius = 16
        areaLabelContainer.layer.masksToBounds = true

        ingredientsLabel.translatesAutoresizingMaskIntoConstraints = false
        ingredientsLabel.font = UIFont.systemFont(ofSize: 16)
        ingredientsLabel.textColor = .black
        ingredientsLabel.textAlignment = .natural
        ingredientsLabel.numberOfLines = 0
        ingredientsLabel.adjustsFontForContentSizeCategory = true

        instructionsLabel.translatesAutoresizingMaskIntoConstraints = false
        instructionsLabel.font = UIFont.systemFont(ofSize: 16)
        instructionsLabel.textColor = .black
        instructionsLabel.numberOfLines = 0
        instructionsLabel.adjustsFontForContentSizeCategory = true

        contentView.addArrangedSubview(mealImageView)
        contentView.addArrangedSubview(mealNameLabel)
        areaLabelContainer.addSubview(areaLabel)
        contentView.addArrangedSubview(areaLabelContainer)
        contentView.addArrangedSubview(ingredientsLabel)
        contentView.addArrangedSubview(instructionsLabel)

        // Set constraints
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),

            mealImageView.widthAnchor.constraint(equalTo: contentView.widthAnchor),
            mealImageView.heightAnchor.constraint(equalToConstant: 296),
            mealImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),

            areaLabelContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            areaLabelContainer.heightAnchor.constraint(equalToConstant: 32),
            areaLabelContainer.widthAnchor.constraint(equalTo: areaLabel.widthAnchor, constant: 24),

            areaLabel.leadingAnchor.constraint(equalTo: areaLabelContainer.leadingAnchor, constant: 12),
            areaLabel.trailingAnchor.constraint(equalTo: areaLabelContainer.trailingAnchor, constant: -12),
            areaLabel.topAnchor.constraint(equalTo: areaLabelContainer.topAnchor, constant: 6),
            areaLabel.bottomAnchor.constraint(equalTo: areaLabelContainer.bottomAnchor, constant: -6),

            ingredientsLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            ingredientsLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            instructionsLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            instructionsLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)

        ])
    }

    private func configureView() {
        guard let meal = meal else { return }
        mealNameLabel.text = meal.strMeal
        areaLabel.text = meal.strArea ?? "Unknown"
        ingredientsLabel.text = "Ingredients:\n" + (meal.ingredients?.joined(separator: "\n") ?? "N/A")
        instructionsLabel.text = "Instructions:\n\(meal.instructions ?? "N/A")"

        if let imageUrl = URL(string: meal.strMealThumb) {
            URLSession.shared.dataTask(with: imageUrl) { data, _, _ in
                if let data = data, let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self.mealImageView.image = image
                    }
                }
            }.resume()
        }
    }
}
