//
//  MealInteractor.swift
//  Tastoro
//
//  Created by Rangga Biner on 04/12/24.
//

import Foundation

protocol MealInteractorProtocol: AnyObject {
    func fetchMeals(completion: @escaping (Result<[Meal], Error>) -> Void)
}

class MealInteractor: MealInteractorProtocol {
    func fetchMeals(completion: @escaping (Result<[Meal], Error>) -> Void) {
        guard let url = URL(string: "http://www.themealdb.com/api/json/v1/1/search.php?s=chicken") else { return }
        
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
