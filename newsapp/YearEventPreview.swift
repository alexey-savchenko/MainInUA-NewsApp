//
//  YearEventPreview.swift
//  newsapp
//
//  Created by iosUser on 18.12.2017.
//  Copyright © 2017 Alexey Savchenko. All rights reserved.
//

import Foundation
import SwiftyJSON

protocol YearEventType {
  var name: String { get set }
  var ID: Int { get set }
  var imageURLString: String { get set }
  var logoURLString: String { get set }
}

struct YearEventPreview: YearEventType {
  var name: String
  var ID: Int
  var imageURLString: String
  var logoURLString: String
}

extension YearEventPreview {
  init(json: JSON) {
    
    name = json["name"].string!
    ID = json["id"].int!
    imageURLString = json["image"].string!
    logoURLString = json["logo"].string!
    
  }
}
