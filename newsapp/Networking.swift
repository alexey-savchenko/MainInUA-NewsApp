//
//  Networking.swift
//  newsapp
//
//  Created by Alexey Savchenko on 14.08.17.
//  Copyright © 2017 Alexey Savchenko. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class Networking {
  
  enum Status {
    
    case success
    case fail(error: String)
    
  }
  
  static func getYearEvents(completion: @escaping ((Status, [YearEventPreview]?)->())) {
    
    Alamofire.request("https://main.in.ua/wp-json/nakitel/regions",
                      method: .get,
                      parameters: nil,
                      encoding: URLEncoding.default,
                      headers: nil).responseJSON { (dataResponse) in
                        
                        guard dataResponse.response != nil else {
                          print(dataResponse)
                          completion(.fail(error: "No connection to server"), nil)
                          return
                        }
                        
                        guard dataResponse.response?.statusCode == 200 else {
                          print(dataResponse)
                          completion(.fail(error: "Corrupted data"), nil)
                          return
                        }
                        
                        if let jsonArray = JSON(dataResponse.value!).array {
                          
                          let eventPreviews = jsonArray.map { YearEventPreview(json: $0) }
                          
                          completion(.success, eventPreviews)
                          
                        } else {
                          print(dataResponse)
                          completion(.fail(error: "Corrupted data"), nil)
                          return
                        }
                        
    }
    
  }
  
  static func getYearEvent(with id: Int, completion: @escaping ((Status, YearEvent?)->())) {
    
    Alamofire.request("https://main.in.ua/wp-json/nakitel/region/\(id)",
      method: .get,
      parameters: nil,
      encoding: URLEncoding.default,
      headers: nil).responseJSON { (dataResponse) in
        
        guard dataResponse.response != nil && dataResponse.response!.statusCode == 200 else {
          print(dataResponse)
          completion(.fail(error: "No connection to server"), nil)
          return
        }
        
        let json = JSON(dataResponse.value!)
        
        if let event = YearEvent(json: json) {
          completion(.success, event)
        } else {
          completion(.fail(error: "Corrupted data"), nil)
        }
        
    }
    
  }
}
