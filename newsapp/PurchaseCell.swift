//
//  PurchaseCell.swift
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
    
  }
  
  func configureWith(_ product: SKProduct) {
    titleLabel.text = product.localizedTitle
    titleLabel.font = UIFont.boldSystemFont(ofSize: 17)
    descriptionLabel.text = product.localizedDescription
    PurchaseCell.priceFormatter.locale = product.priceLocale
    buyButton.setTitle(PurchaseCell.priceFormatter.string(from: product.price), for: .normal)
  }
  
  var buyButtonTapAction: (()->())?
  @IBAction func buyButtonTap(_ sender: UIButton) {
    
    buyButtonTapAction?()
    
  }
  
  
  
}
