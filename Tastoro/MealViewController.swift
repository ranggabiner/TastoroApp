//
//  MealViewController.swift
//  Tastoro
//
//  Created by Rangga Biner on 03/12/24.
//

import UIKit

class MealViewController: UIViewController {
    
    let tableView = UITableView()
    var meals: [Meal] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Meals"
        view.backgroundColor = .white
        
        setupTableView()
        fetchMeals()
    }
    
    private func setupTableView() {
        tableView.frame = view.bounds
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "MealCell")
        view.addSubview(tableView)
    }
    
    private func fetchMeals() {
        guard let url = URL(string: "http://www.themealdb.com/api/json/v1/1/search.php?s=chicken") else { return }
        
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let self = self, let data = data, error == nil else {
                print("Failed to fetch data:", error?.localizedDescription ?? "Unknown error")
                return
            }
            
            do {
                let decodedResponse = try JSONDecoder().decode(MealResponse.self, from: data)
                DispatchQueue.main.async {
                    self.meals = decodedResponse.meals ?? []
                    self.tableView.reloadData()
                }
            } catch {
                print("Failed to decode JSON:", error.localizedDescription)
            }
        }.resume()
    }
}

extension MealViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return meals.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MealCell", for: indexPath)
        let meal = meals[indexPath.row]
        cell.textLabel?.text = meal.strMeal
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let meal = meals[indexPath.row]
        print("Selected meal:", meal.strMeal)
    }
}
