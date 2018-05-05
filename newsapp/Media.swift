//
//  Media.swift
//  newsapp
//
//  Created by Alexey Savchenko on 20.09.17.
//  Copyright © 2017 Alexey Savchenko. All rights reserved.
//

import Foundation
import SwiftyJSON

enum MediaType: String {
  case category = "category"
  case description = "description"
  case text = "text"
  case image = "image"
  case quote = "quote"
  case video = "video"
  case twitter = "twitter"
  case facebook = "facebook"
  case instagram = "instagram"
}

struct Media {
  let type: MediaType
  let content: String
}

extension Media {
  init?(_ json: JSON) {
    if let rawType = json["type"].string,
      let mediaType = MediaType(rawValue: rawType),
      let content = json["text"].string {
      
      self.type = mediaType
      self.content = content
      
    } else {
      return nil
    }
  }
}
