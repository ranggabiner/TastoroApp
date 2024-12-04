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
    let tableView = UITableView()
    var presenter: MealPresenterProtocol?
    private var meals: [Meal] = []
    private let toggleButtons: [UIButton] = ["Indian", "Chinese", "Japanese", "French", "Moroccan"].map {
        let button = UIButton(type: .system)
        button.setTitle($0, for: .normal)
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.systemBlue.cgColor
        button.layer.cornerRadius = 8
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(toggleButtonTapped(_:)), for: .touchUpInside)
        return button
    }
    private var selectedAreas: [String] = []
    private let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "Search Meals"
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        return searchBar
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Choose Your Menu"
        view.backgroundColor = .white
        setupSearchBar()
        setupToggleButtons()
        setupTableView()
        presenter?.updateFilterAndKeyword(areas: selectedAreas, keyword: "")
        
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

    private func setupSearchBar() {
        searchBar.delegate = self
        view.addSubview(searchBar)
        
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
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
            scrollView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 8),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            scrollView.heightAnchor.constraint(equalToConstant: 50),

            buttonStack.topAnchor.constraint(equalTo: scrollView.topAnchor),
            buttonStack.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            buttonStack.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            buttonStack.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            buttonStack.heightAnchor.constraint(equalTo: scrollView.heightAnchor)
        ])
    }
    
    private func setupTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(MealTableViewCell.self, forCellReuseIdentifier: "MealCell")
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: toggleButtons.first!.superview!.bottomAnchor, constant: 8),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    @objc private func toggleButtonTapped(_ sender: UIButton) {
        guard let title = sender.title(for: .normal) else { return }

        if selectedAreas.contains(title) {
            selectedAreas.removeAll { $0 == title }
            sender.backgroundColor = .white
            sender.setTitleColor(.systemBlue, for: .normal)
        } else {
            selectedAreas.append(title)
            sender.backgroundColor = .systemBlue
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
            self.tableView.reloadData()
        }
    }
    
    func showError(_ message: String) {
        print("Error: \(message)")
    }
}

extension MealViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return meals.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MealCell", for: indexPath) as? MealTableViewCell else {
            return UITableViewCell()
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
}
