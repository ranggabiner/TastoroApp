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
    
    static func createModule() -> UIViewController {
        let interactor = MealInteractor()
        let router = MealRouter()
        let presenter = MealPresenter(interactor: interactor, router: router)
        let view = MealViewController()
        
        view.presenter = presenter
        presenter.view = view
        router.viewController = view
        
        return view
    }
    
    func navigateToMealDetail(meal: Meal) {
        let detailViewController = MealDetailViewController()
        detailViewController.meal = meal
        viewController?.navigationController?.pushViewController(detailViewController, animated: true)
    }
    
}
