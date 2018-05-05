//
//  Article.swift
//  newsapp
//
//  Created by Alexey Savchenko on 14.08.17.
//  Copyright © 2017 Alexey Savchenko. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire

protocol Post {
  var id: Int { get set }
  var timestamp: String { get set }
  var title: String  { get set }
  var coverImageURL: URL { get set }
}

struct Article: Post {
  var coverImageURL: URL
  var title: String
  var timestamp: String
  var id: Int
  var webURL: URL
  var mediaArray: [Media]
  var tagArray: [String]
  var copyrightImage: String
  var categories: [NewsCategory]
}

extension Article {
  init?(_ dataResponse: DataResponse<Any>) {
    guard dataResponse.response != nil && dataResponse.response?.statusCode == 200,
      let value = dataResponse.value else {
      return nil
    }

    let json = JSON(value)

    let mediaArray = json["content"].arrayValue.compactMap(Media.init)
    let tags = json["tags"].arrayValue.compactMap { $0["name"].string }.map { "#\($0)" }
    let date = Date(timeIntervalSince1970: TimeInterval(json["created"].intValue))
    let categories = json["category"].arrayValue.map { NewsCategory(name: $0["name"].string!, rawName: $0["slug"].string!) }

    self.coverImageURL = URL(string: json["thumbnail_url_medium"]["large"].stringValue)!
    self.title = json["title"].stringValue
    self.timestamp = date.toStringNotation()
    self.id = json["id"].int!
    self.webURL = URL(string: json["web_link"].stringValue)!
    self.mediaArray = mediaArray
    self.tagArray = tags
    self.copyrightImage = json["thumbnail_url_medium"]["credits"].stringValue
    self.categories = categories
  }
}

struct ArticlePreview: Post {
  var coverImageURL: URL
  var title: String
  var timestamp: String
  var id: Int
  var isHot: Bool
  var isRead: Bool
  var category: NewsCategory
}

extension ArticlePreview {
  init?(json: JSON) {

    guard let previewThumbnail = json["thumbnail_url_medium"]["medium"].string else {
      return nil
    }
    
    id = json["id"].int!
    coverImageURL = URL(string: previewThumbnail)!
    timestamp = Date(timeIntervalSince1970: TimeInterval(json["created"].double!)).toStringNotation()
    title = json["title"].string!
    isHot = json["is_hot"].bool!
    isRead = UserDefaults.standard.readIDArray.contains(json["id"].int!)
    category = NewsCategory(name: json["cat_name"].stringValue,
                            rawName: json["category_nicename"].stringValue)
  }
}


