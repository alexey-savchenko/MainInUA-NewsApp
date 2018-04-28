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
  
  static func getSingleArticle(with id: Int,
                               completion: @escaping ((Status, Article?)->())){
    
    Alamofire.request("https://main.in.ua/wp-json/nakitel/post/\(id)",
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
        
        let json = JSON(dataResponse.value!)
        
        let jsonMedia = json["content"].array!
        
        var processedMedia = [Media]()
        
        for item in jsonMedia {
          if let media = MediaFactory.makeMediaFromJSON(item) {
            processedMedia.append(media)
          }
        }
        
        var tags = [String]()
        
        if let rawTags = json["tags"].array {
          tags = rawTags.flatMap { $0["name"].string }.map { "#\($0)" }
        }
        
        let unixTime = json["created"].int!
        let date = Date(timeIntervalSince1970: TimeInterval(unixTime))
        
        var categories = [NewsCategory]()
        
        if let catArray = json["category"].array {
          categories = catArray.map { NewsCategory(name: $0["name"].string!, rawName: $0["slug"].string!) }
        }
        
        let article = Article(coverImageURL: URL(string: json["thumbnail_url_medium"]["large"].string!)!,
                              title: json["title"].string!,
                              timestamp: date.toStringNotation(),
                              id: json["id"].int!,
                              webURL: URL(string: json["web_link"].string!)!,
                              mediaArray: processedMedia,
                              tagArray: tags,
                              copyrightImage: json["thumbnail_url_medium"]["credits"].string!,
                              categories: categories)
        
        completion(.success, article)
    }
    
  }
  
}
