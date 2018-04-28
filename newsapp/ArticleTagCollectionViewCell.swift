//
//  ArticleTagCollectionViewCell.swift
//  newsapp
//
//  Created by iosUser on 27.12.2017.
//  Copyright © 2017 Alexey Savchenko. All rights reserved.
//

import UIKit

class ArticleTagCollectionViewCell: UICollectionViewCell {
  
  @IBOutlet weak var tagLabel: UILabel!
  
  var selectedBGView: UIImageView = UIImageView(image: UIImage.from(color: UIColor.red, size: .zero))
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
    contentView.layer.borderWidth = 1
    contentView.layer.borderColor = UIColor.red.cgColor
    selectedBackgroundView = selectedBGView
  }

  override func layoutSubviews() {
    super.layoutSubviews()
    
    contentView.layer.cornerRadius = contentView.bounds.height / 2
    selectedBGView.bounds = contentView.bounds
  }
  
  
}
