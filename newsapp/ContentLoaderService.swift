//
//  Services.swift
//  newsapp
//
//  Created by Alexey Savchenko on 25.12.2017.
//  Copyright © 2017 Alexey Savchenko. All rights reserved.
//

import Foundation
import Alamofire
import RxSwift
import SwiftyJSON

//Loader service protocol
protocol ContentLoaderService {
  //  func load<T>(content: WebContent<T>, completion: @escaping (Result<T>) -> ()) -> DataRequest?
  func load<T>(_ content: WebContent<T>) -> Observable<T>
}

class NewWebContentLoader: ContentLoaderService {
  func load<T>(_ content: WebContent<T>) -> Observable<T> {
    return Observable.create { observer in

      Alamofire
        .request(content.resource)
        .responseJSON { dataResponse in
          switch dataResponse.result {
          case .success:
            observer.onNext(content.parse(dataResponse))
          case .failure(let error):
            observer.onError(error)
          }
      }
      return Disposables.create()
    }
  }
}

//class MockContentLoader {
//
//  struct FailureLoader: ContentLoaderService {
//    func load<T>(content: WebContent<T>, completion: @escaping (Result<T>) -> ()) -> DataRequest? {
//      completion(Result.failure(nil))
//      return nil
//    }
//  }
//  deinit {
//    print("\(self) dealloc")
//  }
//}

//class WebContentLoader: ContentLoaderService {
//  func load<T>(content: WebContent<T>, completion: @escaping (Result<T>) -> ()) -> DataRequest? {
//    return Alamofire.request(content.resource.queryURL,
//                             method: content.resource.method,
//                             parameters: content.resource.parameters,
//                             encoding: URLEncoding.default,
//                             headers: nil).responseJSON {
//                              completion(content.parseFunction($0))
//    }
//  }
//  deinit {
//    print("\(self) dealloc")
//  }
//}
