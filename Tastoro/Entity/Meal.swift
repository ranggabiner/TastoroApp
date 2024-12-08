//
//  Meal.swift
//  Tastoro
//
//  Created by Rangga Biner on 04/12/24.
//

import Foundation

struct Meal: Codable, Hashable {
    let idMeal: String
    let strMeal: String
    let strMealThumb: String
    let strArea: String?
    let ingredients: [String]?
    let instructions: String?
}
