//
//  MealPresenter.swift
//  Tastoro
//
//  Created by Rangga Biner on 04/12/24.
//

import Foundation

protocol MealPresenterProtocol: AnyObject {
    var view: MealViewProtocol? { get set }
    func viewDidLoad()
    func didSelectMeal(at index: Int)
    func filterMeals(by areas: [String])
}

class MealPresenter: MealPresenterProtocol {
    weak var view: MealViewProtocol?
    private let interactor: MealInteractorProtocol
    private let router: MealRouterProtocol
    private var meals: [Meal] = []
    
    init(interactor: MealInteractorProtocol, router: MealRouterProtocol) {
        self.interactor = interactor
        self.router = router
    }
    
    func viewDidLoad() {
        interactor.fetchMeals(areas: []) { [weak self] result in
            switch result {
            case .success(let meals):
                self?.meals = meals
                self?.view?.showMeals(meals)
            case .failure(let error):
                self?.view?.showError(error.localizedDescription)
            }
        }
    }
    
    func didSelectMeal(at index: Int) {
        guard index < meals.count else { return }
        let meal = meals[index]
        router.navigateToMealDetail(meal: meal)
    }
    
    func filterMeals(by areas: [String]) {
        interactor.fetchMeals(areas: areas) { [weak self] result in
            switch result {
            case .success(let meals):
                let uniqueMeals = Array(Set(meals))
                self?.meals = uniqueMeals
                self?.view?.showMeals(uniqueMeals)
            case .failure(let error):
                self?.view?.showError(error.localizedDescription)
            }
        }
    }
}
