
//
//  PurchaseVC.swift
//  newsapp
//
//  Created by iosUser on 21.11.2017.
//  Copyright © 2017 Alexey Savchenko. All rights reserved.
//

import UIKit
import StoreKit

class PurchaseVC: UIViewController {
  
  
  
  let table = UITableView()
  var products = [SKProduct]()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
    
    view.addSubview(table)
    table.register(UINib.init(nibName: "PurchaseCell", bundle: nil), forCellReuseIdentifier: "PurchaseCell")
    table.translatesAutoresizingMaskIntoConstraints = false
    
    NSLayoutConstraint.activate([    table.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                                     table.topAnchor.constraint(equalTo: view.topAnchor),
                                     table.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                                     table.bottomAnchor.constraint(equalTo: view.bottomAnchor)])
    
    table.delegate = self
    table.dataSource = self
    table.rowHeight = UITableViewAutomaticDimension
    table.estimatedRowHeight = 100
    SKPaymentQueue.default().add(self)
    
    let productsRequest = SKProductsRequest(productIdentifiers: Set(["com.nakitel.maininua.adremoval"]))
    
    // Keep a strong reference to the request.
    
    productsRequest.delegate = self
    productsRequest.start()
    
    let barItem = UIBarButtonItem(title: "Восстановить", style: .plain, target: self, action: #selector(restore))
    navigationItem.rightBarButtonItems = [barItem]
    
  }
  
  @objc func restore(){
    SKPaymentQueue.default().restoreCompletedTransactions()
  }
  
  deinit {
    print("\(self) dealloc")
  }
  
}
extension PurchaseVC: UITableViewDataSource, UITableViewDelegate {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return products.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "PurchaseCell", for: indexPath) as! PurchaseCell
    cell.configureWith(products[indexPath.row])
    cell.buyButtonTapAction = { [weak self] in
      guard let `self` = self else {
        return
      }
      SKPaymentQueue.default().add(SKPayment(product: self.products[indexPath.row]))
      
    }
    return cell
    
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
    tableView.deselectRow(at: indexPath, animated: true)
    SKPaymentQueue.default().add(SKPayment.init(product: products[indexPath.row]))
    
  }
}

extension PurchaseVC: SKPaymentTransactionObserver {
  func paymentQueue(_ queue: SKPaymentQueue,
                    updatedTransactions transactions: [SKPaymentTransaction]) {
    
    for transaction in transactions {
      switch (transaction.transactionState) {
        
      case .purchased:
        print("Purchased")
        SKPaymentQueue.default().finishTransaction(transaction)
        if let receiptURL = Bundle.main.appStoreReceiptURL {
          do {
            print(receiptURL.path)
            let receiptData = try Data(contentsOf: receiptURL)
            print(receiptData)
            
            
          } catch {
            print(error.localizedDescription)
          }
        } else {
          print("No receipt URL")
        }
        break
        
      case .failed:
        print("Failed")
        self.present({
          let alert = UIAlertController(title: "Failed", message: nil, preferredStyle: .alert)
          alert.addAction(UIAlertAction.init(title: "OK", style: .default, handler: nil))
          return alert
        }(), animated: true, completion: nil)
        SKPaymentQueue.default().finishTransaction(transaction)
        break
        
      case .restored:
        print("Restored")
        self.present({
          let alert = UIAlertController(title: "Success", message: nil, preferredStyle: .alert)
          alert.addAction(UIAlertAction.init(title: "OK", style: .default, handler: nil))
          return alert
        }(), animated: true, completion: nil)
        
        SKPaymentQueue.default().finishTransaction(transaction)
        if let receiptURL = Bundle.main.appStoreReceiptURL {
          do {
            print(receiptURL.path)
            let receiptData = try Data(contentsOf: receiptURL)
            print(receiptData)

            let recManager = ReceiptManager()
            recManager.validateReceipt()
            
          } catch {
            print(error.localizedDescription)
          }
        } else {
          print("No receipt URL")
        }
        
        break
        
      default:
        break
      }
    }
  }
  
  
}
extension PurchaseVC: SKProductsRequestDelegate {
  
  func productsRequest(_ request: SKProductsRequest,
                       didReceive response: SKProductsResponse) {
    
    products = response.products
    let _ = products.map {
      print($0.localizedTitle)
      
    }
    table.reloadData()
  }
  
}
