//
//  YearEvent.swift
//  newsapp
//
//  Created by iosUser on 18.12.2017.
//  Copyright © 2017 Alexey Savchenko. All rights reserved.
//

import Foundation
import SwiftyJSON

struct YearEvent: YearEventType {
  var name: String
  var ID: Int
  var imageURLString: String
  var logoURLString: String
  let media: [Media]
}

extension YearEvent {
  init?(json: JSON) {
    if let jsonMedia = json["content"].array {
      self.media = jsonMedia.compactMap(Media.init)
    } else {
      return nil
    }
    name = json["region_name"].stringValue
    ID = json["region_id"].intValue
    imageURLString = json["region_image"].stringValue
    logoURLString = json["region_logo"].stringValue
  }
}
