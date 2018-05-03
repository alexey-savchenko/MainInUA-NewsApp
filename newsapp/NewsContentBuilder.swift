//
//  NewsContentBuilder.swift
//  newsapp
//
//  Created by Alexey Savchenko on 25.12.2017.
//  Copyright © 2017 Alexey Savchenko. All rights reserved.
//

import Foundation
import SwiftyJSON

protocol NewsContentBuider: class {
  init(api: NewsAPI)
  func buildContentFor(_ page: Int) -> WebContent<NewsPackage>
}

class ContentBuilder: NewsContentBuider {
  
  private var api: NewsAPI
  required init(api: NewsAPI) {
    self.api = api
  }
  
  func buildContentFor(_ page: Int) -> WebContent<NewsPackage> {
    return WebContent<NewsPackage>(resource: api.apiWithPage(page),
                                   parse: { dataResponse in

                                    if let value = dataResponse.value,
                                      let jsonArray = JSON(value).array,
                                      let totalPagesHeader = dataResponse.response?.allHeaderFields["x-wp-totalpages"] as? String,
                                      let totalPages = Int(totalPagesHeader) {

                                      let news = jsonArray.compactMap(ArticlePreview.init)
                                      let package = NewsPackage(news: news, totalAvailablePages: totalPages)

                                      return package
                                    } else {
                                      // TODO: Find appropriate way to handle corrupted response
                                      return NewsPackage(news: [], totalAvailablePages: 1)
                                    }
    })
//    return WebContent<NewsPackage>(resource: api.apiWithPage(page),
//                                   parseFunction: { (dataResponse) -> Result<NewsPackage> in
//
//                                    if let value = dataResponse.value,
//                                      let jsonArray = JSON(value).array,
//                                      let totalPagesHeader = dataResponse.response?.allHeaderFields["x-wp-totalpages"] as? String,
//                                      let totalPages = Int(totalPagesHeader) {
//
//                                      let news = jsonArray.compactMap(ArticlePreview.init)
//                                      let package = NewsPackage(news: news, totalAvailablePages: totalPages)
//
//                                      return Result.success(package)
//                                    } else {
//                                      return Result.failure("Corrupted data")
//                                    }
//    })
  }
  deinit {
    print("\(self) dealloc")
  }
}


