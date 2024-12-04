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
        setupToggleButtons()
        setupSearchBar()
        setupTableView()
        presenter?.viewDidLoad()
    }
    
    private func setupToggleButtons() {
        let buttonStack = UIStackView(arrangedSubviews: toggleButtons)
        buttonStack.axis = .horizontal
        buttonStack.distribution = .fillEqually
        buttonStack.spacing = 8
        buttonStack.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(buttonStack)
        
        NSLayoutConstraint.activate([
            buttonStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            buttonStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            buttonStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }
    
    private func setupSearchBar() {
        searchBar.delegate = self
        view.addSubview(searchBar)
        
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: toggleButtons.first!.bottomAnchor, constant: 8),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }
    
    private func setupTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(MealTableViewCell.self, forCellReuseIdentifier: "MealCell")
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 8),
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

        presenter?.filterMeals(by: selectedAreas)
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
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            presenter?.viewDidLoad()
        } else {
            let filteredMeals = meals.filter { $0.strMeal.lowercased().contains(searchText.lowercased()) }
            showMeals(filteredMeals)
        }
    }
}
