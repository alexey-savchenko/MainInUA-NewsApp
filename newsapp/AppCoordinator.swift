//
//  AppCoordinator.swift
//  newsapp
//
//  Created by Alexey Savchenko on 03.05.2018.
//  Copyright © 2018 Alexey Savchenko. All rights reserved.
//

import UIKit
import RxSwift

class AppCoordinator: Coordinator {

  init(_ window: UIWindow) {
    window.rootViewController = navigationController
    window.makeKeyAndVisible()
  }

  private let navigationController = UINavigationController()
  var rootViewController: UIViewController {
    return navigationController
  }
  var childCoordinators = [Coordinator]()

  func start() {
    let viewModel = ArticleListViewModel(with: NewWebContentLoader(),
                                            contentBuilder: ContentBuilder(api: .timeline(page: 1)),
                                            delegate: self)
    let rootArticleListController = FeedVC(viewModel)
    navigationController.setViewControllers([rootArticleListController], animated: false)
  }
}

extension AppCoordinator: ArticleSelectionDelegate, TagSelectionDelegate, CategorySelectionDelegate {
  func tagSelected(_ tag: String) {
    print(tag)
    // TODO: Implement
  }

  func categorySelected(_ category: NewsCategory) {
    print(category)
    // TODO: Implement
  }

  func articleSelected(_ article: ArticlePreview) {
    print(article)
    // TODO: Implement
  }
}
