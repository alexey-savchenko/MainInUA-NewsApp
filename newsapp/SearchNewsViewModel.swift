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
  
  private let searchService: SearchService
  
  init(searchService: SearchService) {
    
    self.searchService = searchService
    
    self.searchService.querying.asObservable().subscribe { [unowned self] (event) in
      
      self.querying.value = event.element ?? false
      
    }.disposed(by: disposeBag)
    
    self.searchService.searchResponse.asObservable().subscribe { [unowned self] (event) in
      
      if let response = event.element,
        let value = response?.value,
        let json = JSON(value).array {
        
        self.searchResults.value = json.flatMap { ArticlePreview(json: $0) }
        
      }
      
      }.disposed(by: disposeBag)
    
  }
  
  deinit {
    print("\(self) dealloc")
  }
  
}

