//
//  PurchaseHelper.swift
//  newsapp
//
//  Created by iosUser on 21.11.2017.
//  Copyright © 2017 Alexey Savchenko. All rights reserved.
//

import Foundation
import StoreKit

class PurchaseHelper: NSObject {
  var products = [SKProduct]()
  let productID = "com.nakitel.maininua.adremoval"
  var productRequest: SKProductsRequest!
  
  
  override init() {
    super.init()
    var productsIDSet = NSSet(objects: productID)
    
    productRequest = SKProductsRequest(productIdentifiers: productsIDSet as! Set<String>)
    productRequest.delegate = self
    SKPaymentQueue.default().add(self)
  }
  
  func startProductRequest(){
    productRequest.start()
  }
  
}

extension PurchaseHelper: SKProductsRequestDelegate {
  
  func request(_ request: SKRequest, didFailWithError error: Error) {
    print(error.localizedDescription)
  }
  
  func productsRequest(_ request: SKProductsRequest,
                       didReceive response: SKProductsResponse) {
    
    print("product request")
    
    let _ = response.products.map {
      
      products.append($0)
      print($0.productIdentifier)
      print($0.localizedTitle)
      print($0.localizedDescription)
      print($0.price)
      
    }

  }
  
}

extension PurchaseHelper: SKPaymentTransactionObserver {
  
  func paymentQueue(_ queue: SKPaymentQueue,
                    updatedTransactions transactions: [SKPaymentTransaction]) {
    
    
    
  }
  
  func paymentQueueRestoreCompletedTransactionsFinished(_ queue: SKPaymentQueue) {
    
  }
  
}
