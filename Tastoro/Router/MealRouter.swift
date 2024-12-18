//
//  MealRouter.swift
//  Tastoro
//
//  Created by Rangga Biner on 04/12/24.
//

import UIKit

protocol MealRouterProtocol: AnyObject {
    func navigateToMealDetail(meal: Meal)
}

class MealRouter: MealRouterProtocol {
    weak var viewController: UIViewController?
    private let interactor: MealInteractorProtocol

    init(interactor: MealInteractorProtocol) {
        self.interactor = interactor
    }

    static func createModule() -> UIViewController {
        let interactor = MealInteractor()
        let router = MealRouter(interactor: interactor)
        let presenter = MealPresenter(interactor: interactor, router: router)
        let view = MealViewController()

        view.presenter = presenter
        presenter.view = view
        router.viewController = view

        return view
    }

    func navigateToMealDetail(meal: Meal) {
        interactor.fetchMealDetails(mealID: meal.idMeal) { [weak self] (result: Result<Meal, Error>) in
            switch result {
            case .success(let detailedMeal):
                DispatchQueue.main.async {
                    let detailViewController = MealDetailViewController()
                    detailViewController.meal = detailedMeal
                    self?.viewController?.navigationController?.pushViewController(detailViewController, animated: true)
                }
            case .failure(let error):
                DispatchQueue.main.async {
//                    self?.viewController?.showError(error.localizedDescription)
                }
            }
        }
    }
}
