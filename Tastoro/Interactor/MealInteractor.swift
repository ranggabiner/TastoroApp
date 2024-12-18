//
//  MealInteractor.swift
//  Tastoro
//
//  Created by Rangga Biner on 04/12/24.
//

import Foundation

protocol MealInteractorProtocol: AnyObject {
    func fetchMeals(areas: [String], keyword: String, completion: @escaping (Result<[Meal], Error>) -> Void)
    func fetchMealDetails(mealID: String, completion: @escaping (Result<Meal, Error>) -> Void)
}

class MealInteractor: MealInteractorProtocol {
    func fetchMeals(areas: [String], keyword: String, completion: @escaping (Result<[Meal], Error>) -> Void) {
        var allMeals: [Meal] = []
        let dispatchGroup = DispatchGroup()
        var fetchError: Error?
        
        for area in areas.isEmpty ? [""] : areas {
            let urlString = area.isEmpty
                ? "http://www.themealdb.com/api/json/v1/1/search.php?s=\(keyword)"
                : "http://www.themealdb.com/api/json/v1/1/filter.php?a=\(area)"
            dispatchGroup.enter()
            fetchMealsFromAPI(urlString: urlString, area: area.isEmpty ? nil : area) { result in
                switch result {
                case .success(let meals):
                    allMeals.append(contentsOf: meals)
                case .failure(let error):
                    fetchError = error
                }
                dispatchGroup.leave()
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            if let error = fetchError {
                completion(.failure(error))
            } else {
                let filteredMeals = allMeals.filter { $0.strMeal.lowercased().contains(keyword.lowercased()) }
                completion(.success(filteredMeals))
            }
        }
    }

    
    private func fetchMealsFromAPI(urlString: String, area: String?, completion: @escaping (Result<[Meal], Error>) -> Void) {
        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data"])))
                return
            }
            
            do {
                let response = try JSONDecoder().decode(MealResponse.self, from: data)
                var meals = response.meals ?? []
                if let area = area {
                    meals = meals.map { meal in
                        Meal(
                            idMeal: meal.idMeal,
                            strMeal: meal.strMeal,
                            strMealThumb: meal.strMealThumb,
                            strArea: area,
                            ingredients: nil, // Ingredients and instructions will be fetched separately
                            instructions: nil
                        )
                    }
                }
                completion(.success(meals))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    func fetchMealDetails(mealID: String, completion: @escaping (Result<Meal, Error>) -> Void) {
        let urlString = "https://www.themealdb.com/api/json/v1/1/lookup.php?i=\(mealID)"
        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
            return
        }

        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else {
                completion(.failure(NSError(domain: "", code: -2, userInfo: [NSLocalizedDescriptionKey: "No data received"])))
                return
            }

            do {
                // Decode JSON to Dictionary to handle dynamic keys
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                   let mealsArray = json["meals"] as? [[String: Any]],
                   let mealData = mealsArray.first {
                    
                    // Extract ingredients and instructions
                    var ingredients: [String] = []
                    for i in 1...20 {
                        if let ingredient = mealData["strIngredient\(i)"] as? String,
                           !ingredient.trimmingCharacters(in: .whitespaces).isEmpty {
                            ingredients.append(ingredient)
                        }
                    }
                    
                    // Create Meal object
                    let detailedMeal = Meal(
                        idMeal: mealData["idMeal"] as? String ?? "",
                        strMeal: mealData["strMeal"] as? String ?? "",
                        strMealThumb: mealData["strMealThumb"] as? String ?? "",
                        strArea: mealData["strArea"] as? String,
                        ingredients: ingredients,
                        instructions: mealData["strInstructions"] as? String
                    )
                    completion(.success(detailedMeal))
                } else {
                    completion(.failure(NSError(domain: "", code: -3, userInfo: [NSLocalizedDescriptionKey: "Invalid JSON structure"])))
                }
            } catch {
                completion(.failure(NSError(domain: "", code: -4, userInfo: [NSLocalizedDescriptionKey: "Decoding error: \(error.localizedDescription)"])))
            }
        }.resume()
    }

}
