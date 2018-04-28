//
//  ReceiptManager.swift
//  newsapp
//
//  Created by iosUser on 21.11.2017.
//  Copyright © 2017 Alexey Savchenko. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class ReceiptManager: NSObject {
  
  let sharedSecret = "2ec3d97815204b36a3836ec3e79f7a81"
  let validationEndPoint = "https://sandbox.itunes.apple.com/verifyReceipt"
  
  
  func validateReceipt(){
    do {
      
      if let receiptURL = Bundle.main.appStoreReceiptURL {
        if try receiptURL.checkResourceIsReachable() {
          
          let receiptData = try Data(contentsOf: receiptURL)
          let base64 = receiptData.base64EncodedString(options: [])
          
          let payload: [String: Any] = ["receipt-data": base64,
                                        "password": sharedSecret]
          
          let jsonPayload = try JSONSerialization.data(withJSONObject: payload, options: [])
          
          var urlRequest = URLRequest(url: URL(string: validationEndPoint)!)
          urlRequest.httpBody = jsonPayload
          urlRequest.httpMethod = "POST"
          
          let task = URLSession.shared.dataTask(with: urlRequest, completionHandler: { (data, response, error) in
            
            guard error != nil else {
              print(error?.localizedDescription)
              return
            }
            
            
            print(data)
            
            
          })
          
          task.resume()
          
        }
      }
      
    } catch {
      print(error.localizedDescription)
    }
  }
  
  
}
