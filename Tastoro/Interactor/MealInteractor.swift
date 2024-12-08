//
//  MealInteractor.swift
//  Tastoro
//
//  Created by Rangga Biner on 04/12/24.
//

import Foundation

protocol MealInteractorProtocol: AnyObject {
    func fetchMeals(areas: [String], keyword: String, completion: @escaping (Result<[Meal], Error>) -> Void)
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
                            strArea: area
                        )
                    }
                }
                completion(.success(meals))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}
