//
//  MealInteractor.swift
//  Tastoro
//
//  Created by Rangga Biner on 04/12/24.
//

import Foundation

protocol MealInteractorProtocol: AnyObject {
    func fetchMeals(areas: [String], completion: @escaping (Result<[Meal], Error>) -> Void)
}

class MealInteractor: MealInteractorProtocol {
    func fetchMeals(areas: [String], completion: @escaping (Result<[Meal], Error>) -> Void) {
        if areas.isEmpty {
            let urlString = "http://www.themealdb.com/api/json/v1/1/search.php?s=chicken"
            fetchMealsFromAPI(urlString: urlString, completion: completion)
            return
        }
        
        var allMeals: [Meal] = []
        let dispatchGroup = DispatchGroup()
        var fetchError: Error?
        
        for area in areas {
            let urlString = "http://www.themealdb.com/api/json/v1/1/filter.php?a=\(area)"
            dispatchGroup.enter()
            fetchMealsFromAPI(urlString: urlString) { result in
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
                let filteredMeals = allMeals.filter { $0.strMeal.lowercased().contains("chicken") }
                completion(.success(filteredMeals))
            }
        }
    }
    
    private func fetchMealsFromAPI(urlString: String, completion: @escaping (Result<[Meal], Error>) -> Void) {
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
                completion(.success(response.meals ?? []))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}
