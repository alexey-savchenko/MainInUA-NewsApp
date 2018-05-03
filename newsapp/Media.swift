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

protocol Media {
  var type: MediaType {get set}
  var content: String {get set}
}

struct CategoryMedia: Media {
  var type: MediaType = .category
  var content: String
}

struct DescriptionMedia: Media {
  var type: MediaType = .description
  var content: String
}

struct TextMedia: Media {
  var type: MediaType = .text
  var content: String
}

struct ImageMedia: Media {
  var type: MediaType = .image
  var content: String
}

struct QuoteMedia: Media {
  var type: MediaType = .quote
  var content: String
}

struct VideoMedia: Media {
  var type: MediaType = .video
  var content: String
}

struct TwitterMedia: Media {
  var type: MediaType = .twitter
  var content: String
}

struct FacebookMedia: Media {
  var type: MediaType = .facebook
  var content: String
}

struct InstagramMedia: Media {
  var type: MediaType = .instagram
  var content: String
}

class MediaFactory {
  class func makeMediaFromJSON(_ json: JSON) -> Media? {
    
    if let mediaType = MediaType(rawValue: json["type"].string!) {

      switch mediaType {
      case .category:
        return CategoryMedia(type: .category, content: json["text"].string!)
      case .description:
        return DescriptionMedia(type: .description, content: json["text"].string!)
      case .image:
        return ImageMedia(type: .image, content: json["text"].string!)
      case .text:
        return TextMedia(type: .text, content: json["text"].string!)
      case .quote:
        return QuoteMedia(type: .quote, content: json["text"].string!)
      case .video:
        return VideoMedia(type: .video, content: json["text"].string!)
      case .twitter:
        return TwitterMedia(type: .twitter, content: json["text"].string!)
      case .facebook:
        return FacebookMedia(type: .facebook, content: json["text"].string!)
      case .instagram:
        return InstagramMedia(type: .instagram, content: json["text"].string!)
      }

    } else {
      return nil
    }
  }
}
