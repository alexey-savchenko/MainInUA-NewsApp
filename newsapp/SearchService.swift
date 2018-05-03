//
//  SearchService.swift
//  newsapp
//
//  Created by iosUser on 19.12.2017.
//  Copyright © 2017 Alexey Savchenko. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import RxCocoa
import RxSwift

protocol SearchService: class {
  var querying: Variable<Bool> { get set }
  var searchResponse: Variable<DataResponse<Any>?> { get set }
}

class NewsSearchService: SearchService {
  var querying = Variable<Bool>(false)
  let disposeBag = DisposeBag()
  
  init(query: Driver<String>) {
    query
      .debug()
      .filter { $0 != "" }
      .debounce(0.5)
      .debug()
      .drive(onNext: { [unowned self] (queryString) in
        self.querying.value = true
        self.searchNewsWithTitle(queryString)
      }).disposed(by: disposeBag)
  }
  
  var searchResponse = Variable<DataResponse<Any>?>(nil)
  
  private var request: DataRequest?
  
  private func searchNewsWithTitle(_ query: String) {
    request?.cancel()
    request = Alamofire.request("https://main.in.ua/wp-json/nakitel/search",
                                method: .get,
                                parameters: ["q": query,
                                             "per-page": 50,
                                             "page": 1],
                                encoding: URLEncoding.default,
                                headers: nil).responseJSON { [weak self] in
                                  self?.searchResponse.value = $0
                                  self?.querying.value = false
    }
  }
  
  deinit {
    print("\(self) dealloc")
  }
  
}
