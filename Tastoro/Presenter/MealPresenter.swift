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
    func filterMeals(by area: String)
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
        interactor.fetchMeals(area: nil) { [weak self] result in
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
    
    func filterMeals(by area: String) {
        interactor.fetchMeals(area: area) { [weak self] result in
            switch result {
            case .success(let meals):
                self?.meals = meals
                self?.view?.showMeals(meals)
            case .failure(let error):
                self?.view?.showError(error.localizedDescription)
            }
        }
    }
}
