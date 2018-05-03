//
//  SearchNewsViewModel.swift
//  newsapp
//
//  Created by iosUser on 19.12.2017.
//  Copyright © 2017 Alexey Savchenko. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import SwiftyJSON

class SearchNewsViewModel {
  private let disposeBag = DisposeBag()
  
  var searchResultsDriver: SharedSequence<DriverSharingStrategy, [ArticlePreview]> {
    return searchResults.asDriver()
  }
  
  var querying = Variable<Bool>(false)
  
  private var searchResults = Variable<[ArticlePreview]>([])

  init(searchService: SearchService) {
    searchService.querying.asObservable()
      .subscribe { [unowned self] (event) in
        self.querying.value = event.element ?? false
      }.disposed(by: disposeBag)
    
    searchService.searchResponse
      .asObservable()
      .subscribe({ [weak self] (event) in
        if let dataResponse = event.element?.flatMap({ $0 }),
          let value = dataResponse.value {
          let json = JSON(value).arrayValue
          self?.searchResults.value = json.compactMap(ArticlePreview.init)
        }
      })
      .disposed(by: disposeBag)
  }
  
  deinit {
    print("\(self) dealloc")
  }
}
