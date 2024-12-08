import UIKit

class MealDetailViewController: UIViewController {
    var meal: Meal?

    private let mealImageView = UIImageView()
    private let mealNameLabel = UILabel()
    private let areaLabel = UILabel()
    private let descriptionLabel = UILabel() // Assuming meal has a description.

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
        configureView()
    }

    private func setupUI() {
        mealImageView.translatesAutoresizingMaskIntoConstraints = false
        mealNameLabel.translatesAutoresizingMaskIntoConstraints = false
        areaLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false

        mealNameLabel.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        areaLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        descriptionLabel.font = UIFont.systemFont(ofSize: 14)
        descriptionLabel.numberOfLines = 0

        view.addSubview(mealImageView)
        view.addSubview(mealNameLabel)
        view.addSubview(areaLabel)
        view.addSubview(descriptionLabel)

        NSLayoutConstraint.activate([
            mealImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            mealImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            mealImageView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
            mealImageView.heightAnchor.constraint(equalTo: mealImageView.widthAnchor),

            mealNameLabel.topAnchor.constraint(equalTo: mealImageView.bottomAnchor, constant: 16),
            mealNameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            mealNameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

            areaLabel.topAnchor.constraint(equalTo: mealNameLabel.bottomAnchor, constant: 8),
            areaLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            areaLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

            descriptionLabel.topAnchor.constraint(equalTo: areaLabel.bottomAnchor, constant: 16),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }

    private func configureView() {
        guard let meal = meal else { return }
        mealNameLabel.text = meal.strMeal
        areaLabel.text = meal.strArea ?? "Unknown Area"
        descriptionLabel.text = "This is a detailed description for \(meal.strMeal)." // Replace with real data if available.

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
