//
//  MealViewController.swift
//  Tastoro
//
//  Created by Rangga Biner on 03/12/24.
//

import UIKit

protocol MealViewProtocol: AnyObject {
    func showMeals(_ meals: [Meal])
    func showError(_ message: String)
}

class MealViewController: UIViewController, MealViewProtocol, UISearchBarDelegate {
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 16
        layout.minimumInteritemSpacing = 0
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .white
        return collectionView
    }()
    
    var presenter: MealPresenterProtocol?
    private var meals: [Meal] = []
    private var toggleButtons: [UIButton] = []
    private var selectedAreas: [String] = []
    private let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "Search Meals"
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        return searchBar
    }()
    private let dividerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .lightGray
        return view
    }()
    private let emptyStateView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = true

        let imageView = UIImageView()
        imageView.image = UIImage(named: "emptyLogo")
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false

        let headlineLabel = UILabel()
        headlineLabel.text = "No Dishes Found"
        headlineLabel.textColor = .gray
        headlineLabel.font = UIFont.preferredFont(forTextStyle: .headline)
        headlineLabel.textAlignment = .center
        headlineLabel.translatesAutoresizingMaskIntoConstraints = false

        let subheadlineLabel = UILabel()
        subheadlineLabel.text = "We couldn’t find any dishes matching your search. Try adjusting the filters or using a different keyword."
        subheadlineLabel.textColor = .gray
        subheadlineLabel.font = UIFont.preferredFont(forTextStyle: .subheadline)
        subheadlineLabel.textAlignment = .center
        subheadlineLabel.numberOfLines = 0
        subheadlineLabel.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(imageView)
        view.addSubview(headlineLabel)
        view.addSubview(subheadlineLabel)

        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.topAnchor.constraint(equalTo: view.topAnchor),

            headlineLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            headlineLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 16),

            subheadlineLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            subheadlineLabel.topAnchor.constraint(equalTo: headlineLabel.bottomAnchor, constant: 8),
            subheadlineLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            subheadlineLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            subheadlineLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Choose Your Menu"
        view.backgroundColor = .white
        setupSearchBar()
        setupCollectionView()
        fetchAreas()
        presenter?.updateFilterAndKeyword(areas: selectedAreas, keyword: "")
        setupEmptyStateView()

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }

    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }

    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        dismissKeyboard()
    }

    private func setupEmptyStateView() {
        view.addSubview(emptyStateView)
        NSLayoutConstraint.activate([
            emptyStateView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyStateView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            emptyStateView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            emptyStateView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }
    
    private func fetchAreas() {
        guard let url = URL(string: "https://www.themealdb.com/api/json/v1/1/list.php?a=list") else { return }

        URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            if let error = error {
                DispatchQueue.main.async {
                    self?.showError("Failed to fetch areas: \(error.localizedDescription)")
                }
                return
            }
            
            guard let data = data else {
                DispatchQueue.main.async {
                    self?.showError("No data received")
                }
                return
            }
            
            do {
                let response = try JSONDecoder().decode(AreaResponse.self, from: data)
                let areas = response.meals?.compactMap { $0.strArea } ?? []
                DispatchQueue.main.async {
                    self?.updateToggleButtons(with: areas)
                }
            } catch {
                DispatchQueue.main.async {
                    self?.showError("Failed to parse areas: \(error.localizedDescription)")
                }
            }
        }.resume()
    }

    private func updateToggleButtons(with areas: [String]) {
        toggleButtons.forEach { $0.removeFromSuperview() }
        
        toggleButtons = areas.map { area in
            let button = UIButton(type: .system)
            configureToggleButton(button, withTitle: area)
            return button
        }
        
        setupToggleButtons()
    }

    private func configureToggleButton(_ button: UIButton, withTitle title: String) {
        button.setTitle(title, for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = UIColor(named: "primaryYellow")
        button.layer.cornerRadius = 16
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(toggleButtonTapped(_:)), for: .touchUpInside)
        button.configuration = configureButtonContentInsets()
    }

    private func configureButtonContentInsets() -> UIButton.Configuration {
        var configuration = UIButton.Configuration.plain()
        configuration.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 20, bottom: 5, trailing: 20)
        return configuration
    }

    private func setupSearchBar() {
        searchBar.delegate = self
        view.addSubview(searchBar)
        view.addSubview(dividerView)

        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            dividerView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 0),
            dividerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            dividerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            dividerView.heightAnchor.constraint(equalToConstant: 0.5)
        ])
    }

    private func setupToggleButtons() {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsHorizontalScrollIndicator = false
        view.addSubview(scrollView)
        
        let buttonStack = UIStackView(arrangedSubviews: toggleButtons)
        buttonStack.axis = .horizontal
        buttonStack.distribution = .fill
        buttonStack.spacing = 8
        buttonStack.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(buttonStack)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: dividerView.bottomAnchor, constant: 8),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.heightAnchor.constraint(equalToConstant: 31),

            buttonStack.topAnchor.constraint(equalTo: scrollView.topAnchor),
            buttonStack.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            buttonStack.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16),
            buttonStack.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            buttonStack.heightAnchor.constraint(equalTo: scrollView.heightAnchor)
        ])
    }

    private func setupCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.showsVerticalScrollIndicator = true
        collectionView.register(MealCollectionViewCell.self, forCellWithReuseIdentifier: "MealCell")
        
        // Tambahkan padding untuk konten
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 16)
        
        // Pastikan scroll indicator tidak terpengaruh
        collectionView.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        view.addSubview(collectionView)

        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: dividerView.bottomAnchor, constant: 60),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    @objc private func toggleButtonTapped(_ sender: UIButton) {
        guard let title = sender.title(for: .normal) else { return }

        if selectedAreas.contains(title) {
            selectedAreas.removeAll { $0 == title }
            sender.backgroundColor = .primaryYellow
            sender.setTitleColor(.black, for: .normal)
        } else {
            selectedAreas.append(title)
            sender.backgroundColor = UIColor(named: "secondaryRed")
            sender.setTitleColor(.white, for: .normal)
        }

        presenter?.updateFilterAndKeyword(areas: selectedAreas, keyword: searchBar.text ?? "")
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        presenter?.updateFilterAndKeyword(areas: selectedAreas, keyword: searchText)
    }
    
    func showMeals(_ meals: [Meal]) {
        self.meals = meals
        DispatchQueue.main.async {
            self.collectionView.reloadData()
            self.emptyStateView.isHidden = !self.meals.isEmpty
        }
    }
    
    func showError(_ message: String) {
        print("Error: \(message)")
    }
}

extension MealViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return meals.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MealCell", for: indexPath) as? MealCollectionViewCell else {
            return UICollectionViewCell()
        }
        let meal = meals[indexPath.row]
        cell.mealLabel.text = meal.strMeal
        cell.areaLabel.text = meal.strArea ?? "Unknown Area"
        
        if let imageUrl = URL(string: meal.strMealThumb) {
            URLSession.shared.dataTask(with: imageUrl) { data, _, _ in
                if let data = data, let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        cell.mealImageView.image = image
                    }
                }
            }.resume()
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let padding: CGFloat = 16
        let itemsPerRow: CGFloat = 2
        let totalHorizontalPadding = padding * (itemsPerRow - 1) + collectionView.contentInset.left + collectionView.contentInset.right
        let availableWidth = collectionView.bounds.width - totalHorizontalPadding
        let itemWidth = availableWidth / itemsPerRow

        let itemHeight = itemWidth * 1.5
        return CGSize(width: itemWidth, height: itemHeight)
    }
}
