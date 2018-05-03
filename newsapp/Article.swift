//
//  Article.swift
//  newsapp
//
//  Created by Alexey Savchenko on 14.08.17.
//  Copyright © 2017 Alexey Savchenko. All rights reserved.
//

import Foundation
import SwiftyJSON

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


