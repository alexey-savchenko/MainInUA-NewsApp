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
  var articleSelectedSubject: PublishSubject<ArticlePreview> { get }
  var moveToNextPageIfNeededSubject: PublishSubject<Void> { get }
}

protocol ArticleSelectionDelegate: class {
  func articleSelected(_ article: ArticlePreview)
}

class NewArticleListViewModel: NewArticleListViewModelType {

  // MARK: Init and deinit
  init(with loadService: ContentLoaderService,
       contentBuilder: NewsContentBuider,
       delegate: ArticleSelectionDelegate) {

    self.contentBuilder = contentBuilder
    self.service = loadService

    service
      .load(contentBuilder.buildContentFor(currentPage))
      .subscribe(onNext: { [weak self] (package) in
        guard let `self` = self else { return }
        self.totalAvailablePages = package.totalAvailablePages
        var items = (try? self.articlesSubject.value()) ?? []
        items.append(contentsOf: package.news)
        self.articlesSubject.onNext(items)
      })
      .disposed(by: disposeBag)

    moveToNextPageIfNeededSubject
      .subscribe(onNext: moveToNextPageIfNeeded)
      .disposed(by: disposeBag)

    articleSelectedSubject
      .do(onNext: markAsReadArticle)
      .subscribe(onNext: delegate.articleSelected)
      .disposed(by: disposeBag)
  }

  deinit {
    print("\(self) dealloc")
  }

  // MARK: Private properties
  private var currentPage = 1
  private var totalAvailablePages = 1

  private let contentBuilder: NewsContentBuider
  private let service: ContentLoaderService
  private let disposeBag = DisposeBag()
  private let articlesSubject = BehaviorSubject<[ArticlePreview]>(value: [])

  // MARK: Public properties
  var articlesDriver: Driver<[ArticlePreview]> {
    return articlesSubject.asDriver(onErrorJustReturn: [])
  }

  var articleSelectedSubject = PublishSubject<ArticlePreview>()
  var moveToNextPageIfNeededSubject = PublishSubject<Void>()

  // MARK: Functions
  private func markAsReadArticle(_ article: ArticlePreview) {
    let targetArticleID = article.id
    let articleReadIDArray = UserDefaults.standard.readIDArray

    if !articleReadIDArray.contains(targetArticleID) {
      var newArticleReadIDArray = articleReadIDArray
      newArticleReadIDArray.append(targetArticleID)
      UserDefaults.standard.readIDArray = newArticleReadIDArray
      
      if let currentArticles = try? articlesSubject.value(),
        let targetArticleIndex = currentArticles.index(where: { $0.id == targetArticleID }) {

        var copyOfCurrentArticles = currentArticles
        var articlePreview = copyOfCurrentArticles[targetArticleIndex]
        articlePreview.isRead = true
        copyOfCurrentArticles.replace(with: articlePreview, at: targetArticleIndex)
        articlesSubject.onNext(copyOfCurrentArticles)
      }
    }
  }

  private func moveToNextPageIfNeeded() {
    guard currentPage < totalAvailablePages else { return }
    currentPage += 1

    service
      .load(contentBuilder.buildContentFor(currentPage))
      .subscribe(onNext: { [weak self] (package) in
        guard let `self` = self else { return }
        self.totalAvailablePages = package.totalAvailablePages
        var items = (try? self.articlesSubject.value()) ?? []
        items.append(contentsOf: package.news)
        self.articlesSubject.onNext(items)
      })
      .disposed(by: disposeBag)
  }
}
