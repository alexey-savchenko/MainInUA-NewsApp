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
    
    name = json["region_name"].string!
    ID = json["region_id"].int!
    imageURLString = json["region_image"].string!
    logoURLString = json["region_logo"].string!
    
    if let jsonMedia = json["content"].array {
      self.media = jsonMedia.flatMap { MediaFactory.makeMediaFromJSON($0) }
    } else {
      return nil
    }
    
  }
  
}
