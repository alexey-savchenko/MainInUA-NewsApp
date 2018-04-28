//
//  YearEventImageCell.swift
//  newsapp
//
//  Created by iosUser on 19.12.2017.
//  Copyright © 2017 Alexey Savchenko. All rights reserved.
//

import UIKit

class YearEventImageCell: UITableViewCell {
  
  @IBOutlet weak var yearEventImage: UIImageView!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    yearEventImage.layer.shadowRadius = 10
    yearEventImage.layer.shadowOffset = CGSize(width: 0, height: -2)
    yearEventImage.layer.shadowOpacity = 0.3
  }
  
}
