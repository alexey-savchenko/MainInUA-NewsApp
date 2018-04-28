//
//  YearEventsCell.swift
//  newsapp
//
//  Created by iosUser on 18.12.2017.
//  Copyright © 2017 Alexey Savchenko. All rights reserved.
//

import UIKit

class YearEventsCell: UITableViewCell {
  
  @IBOutlet weak var mainImage: UIImageView!
  
  @IBOutlet weak var label: UILabel!
  
  let gradient = CAGradientLayer()
  
  let view = UIView()
  
  override func awakeFromNib() {
    super.awakeFromNib()
    
    gradient.colors = [UIColor.clear.cgColor, UIColor(hexString: "EB6E6E").cgColor]
    gradient.locations = [0.0, 1.0]
    gradient.opacity = 0.9
    
    view.layer.addSublayer(gradient)
    
    contentView.addSubview(view)
    contentView.insertSubview(view, belowSubview: label)
    
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    
    gradient.frame = bounds
    view.frame = bounds
  }
}
