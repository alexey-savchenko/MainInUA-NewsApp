
//
//  PurchasCell.swift
//  newsapp
//
//  Created by iosUser on 21.11.2017.
//  Copyright © 2017 Alexey Savchenko. All rights reserved.
//

import UIKit
import StoreKit

class PurchaseCell: UITableViewCell {
  
  static let priceFormatter: NumberFormatter = {
    let formatter = NumberFormatter()
    
    formatter.formatterBehavior = .behavior10_4
    formatter.numberStyle = .currency
    
    return formatter
  }()
  
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var descriptionLabel: UILabel!
  
  @IBOutlet weak var buyButton: UIButton!
  
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
  }
  
  func configure(with product: SKProduct) {
    titleLabel.text = product.localizedTitle
    descriptionLabel.text = product.localizedDescription
    buyButton.setTitle("<#T##title: String?##String?#>", for: <#T##UIControlState#>)
  }
  
  @IBAction func buyButtonTap(_ sender: UIButton) {
    
  }
  
  
}
