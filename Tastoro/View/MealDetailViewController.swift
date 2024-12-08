import UIKit

class MealDetailViewController: UIViewController {
    var meal: Meal?
    private let mealImageView = UIImageView()
    private let mealNameLabel = UILabel()
    private let areaLabel = UILabel()
    private let ingredientsLabel = UILabel()
    private let instructionsLabel = UILabel()

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
        ingredientsLabel.translatesAutoresizingMaskIntoConstraints = false
        instructionsLabel.translatesAutoresizingMaskIntoConstraints = false

        ingredientsLabel.numberOfLines = 0
        instructionsLabel.numberOfLines = 0

        view.addSubview(mealImageView)
        view.addSubview(mealNameLabel)
        view.addSubview(areaLabel)
        view.addSubview(ingredientsLabel)
        view.addSubview(instructionsLabel)

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

            ingredientsLabel.topAnchor.constraint(equalTo: areaLabel.bottomAnchor, constant: 16),
            ingredientsLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            ingredientsLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

            instructionsLabel.topAnchor.constraint(equalTo: ingredientsLabel.bottomAnchor, constant: 16),
            instructionsLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            instructionsLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }

    private func configureView() {
        guard let meal = meal else { return }
        mealNameLabel.text = meal.strMeal
        areaLabel.text = "Area: \(meal.strArea ?? "Unknown")"
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
