//
//  WebResourse+NewsAPI.swift
//  newsapp
//
//  Created by Alexey Savchenko on 25.12.2017.
//  Copyright © 2017 Alexey Savchenko. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

protocol Resource: URLRequestConvertible {
  var parameters: [String: Any] { get }
  var queryURL: URL { get }
  var method: HTTPMethod { get }
}

enum NewsAPI: Resource {
  func asURLRequest() throws -> URLRequest {
    let originalRequest = try URLRequest(url: base.appending(path),
                                         method: method,
                                         headers: nil)
    let encodedRequest = try URLEncoding.default.encode(originalRequest, with: parameters)
    return encodedRequest
  }
  var base: String {
    return "https://main.in.ua/wp-json/nakitel"
  }
  
  case timeline(page: Int)
  case singleArticle(ID: Int)
  case category(category: NewsCategory, page: Int)
  case tagSearch(tag: String, page: Int)
  
  private var path: String {
    
    switch self {
      
    case .timeline(_):
      return base.appending("/posts")
    case let .singleArticle(ID):
      return base.appending("/post/\(ID)")
    case .category(_):
      return base.appending("/posts")
    case .tagSearch(_, _):
      return base.appending("/tag")
    }
    
  }
  
  var parameters: [String: Any] {
    
    switch self {
      
    case let .timeline(page):
      return ["page": page,
              "per-page": 15]
    case .singleArticle(_):
      return [:]
    case let .category(category, page):
      return ["page": page,
              "per-page": 15,
              "category": category.rawName]
    case let .tagSearch(tag, page):
      return ["page": page,
              "per-page": 15,
              "tag": tag]
    }
  }
  
  var queryURL: URL {
    return URL(string: path)!
  }
  
  var method: HTTPMethod {
    return .get
  }
  
  func apiWithPage(_ page: Int) -> NewsAPI {
    switch self {
    case let .category(category, _):
      return NewsAPI.category(category: category, page: page)
    case .timeline(_):
      return NewsAPI.timeline(page: page)
    case let .tagSearch(tag, _):
      return NewsAPI.tagSearch(tag: tag, page: page)
    default:
      return self
    }
  }
  
}

struct WebContent<T> {
  let resource: Resource
  let parse: (DataResponse<Any>) -> T
}

//News package model
struct NewsPackage {
  let news: [ArticlePreview]
  let totalAvailablePages: Int
}
