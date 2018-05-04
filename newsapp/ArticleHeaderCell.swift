//
//  ArticleHeaderCell.swift
//  newsapp
//
//  Created by Alexey Savchenko on 14.08.17.
//  Copyright © 2017 Alexey Savchenko. All rights reserved.
//

import UIKit

class ArticleHeaderCell: UITableViewCell {
  
  override func awakeFromNib() {
    super.awakeFromNib()
  }
  
  @IBOutlet weak var headerImage: UIImageView!
  @IBOutlet weak var copyrightLabel: UILabel!
//
//  override func layoutSubviews() {
//    super.layoutSubviews()
//    bounds.size.height = UIScreen.main.bounds.width * 0.5625
//  }
}
