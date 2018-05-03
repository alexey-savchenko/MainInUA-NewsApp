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
  init() {

  }

  deinit {
    print("\(self) dealloc")
  }
  var tagSelectedSubject = PublishSubject<String>()
  var categorySelectedSubject = PublishSubject<NewsCategory>()
}
