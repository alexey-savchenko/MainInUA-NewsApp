//
//  Coordinator.swift
//  newsapp
//
//  Created by Alexey Savchenko on 03.05.2018.
//  Copyright © 2018 Alexey Savchenko. All rights reserved.
//

import Foundation
import UIKit

protocol Coordinator: class {
  var rootViewController: UIViewController { get }
  var childCoordinators: [Coordinator] { get set }
  func start()
}

extension Coordinator {
  func addChildCoordinator(_ coordinator: Coordinator) {
    childCoordinators.append(coordinator)
  }
  func removeChildCoordinator(_ coordinator: Coordinator) {
    self.childCoordinators = self.childCoordinators.filter { $0 !== coordinator }
  }
}

protocol ArticleSelectionDelegate: class {
  func articleSelected(_ article: ArticlePreview)
}

protocol CategorySelectionDelegate: class {
  func categorySelected(_ category: NewsCategory)
}

protocol TagSelectionDelegate: class {
  func tagSelected(_ tag: String)
}
