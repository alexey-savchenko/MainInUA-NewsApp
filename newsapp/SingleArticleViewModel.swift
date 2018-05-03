//
//  SingleArticleViewModel.swift
//  newsapp
//
//  Created by Alexey Savchenko on 03.05.2018.
//  Copyright © 2018 Alexey Savchenko. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

protocol SingleArticleViewModelType {
  var tagSelectedSubject: PublishSubject<String> { get }
  var categorySelectedSubject: PublishSubject<NewsCategory> { get }
}

class SingleArticleViewModel: SingleArticleViewModelType {

  // MARK: Init and deinit
  init(articleID: Int,
       loadService: ContentLoaderService,
       contentBuilder: NewsContentBuider,
       delegate: TagAndCategorySelectionDelegate) {

    // TODO: Fix
//    loadService
//      .load(WebContent<Article>(resource: NewsAPI.singleArticle(ID: articleID), parse: <#(DataResponse<Any>) -> Article#>))
//      .subscribe(onNext: <#T##((Article) -> Void)?##((Article) -> Void)?##(Article) -> Void#>, onError: <#T##((Error) -> Void)?##((Error) -> Void)?##(Error) -> Void#>, onCompleted: <#T##(() -> Void)?##(() -> Void)?##() -> Void#>, onDisposed: <#T##(() -> Void)?##(() -> Void)?##() -> Void#>)
  }

  deinit {
    print("\(self) dealloc")
  }
  var tagSelectedSubject = PublishSubject<String>()
  var categorySelectedSubject = PublishSubject<NewsCategory>()
}
