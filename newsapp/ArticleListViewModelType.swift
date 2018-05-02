//
//  TimelineViewmodelType.swift
//  newsapp
//
//  Created by Alexey Savchenko on 25.12.2017.
//  Copyright © 2017 Alexey Savchenko. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol ArticleListViewModelType {
  
  init(with loadService: ContentLoaderService, contentBuilder: NewsContentBuider)
  
  var didLoadNews: (() -> ())? { get set }
  var didFailLoading: ((String) -> ())? { get set }
  
  var shouldMoveToNextPage: Bool { get }
  
  func loadArticles()
  func articleForItemAt(_ indexPath: IndexPath) -> ArticlePreview
  func numberOfArticles() -> Int
  func moveToNextPage()
  func moveToFirstPage()
  
  func markAsReadArticleWithID(_ ID: Int)
}

protocol NewArticleListViewModelType {
  var articlesDriver: Driver<[ArticlePreview]> { get }
  func moveToNextPageIfNeeded()
}
