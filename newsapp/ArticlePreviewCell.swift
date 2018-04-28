//
//  ArticlePreviewCell.swift
//  newsapp
//
//  Created by Alexey Savchenko on 14.08.17.
//  Copyright © 2017 Alexey Savchenko. All rights reserved.
//

import UIKit
import SDWebImage

class ArticlePreviewCell: UITableViewCell {

  @IBOutlet weak var articleImage: UIImageView!

  @IBOutlet weak var articleTimestamp: UILabel!

  @IBOutlet weak var articleTitle: UILabel!

  @IBOutlet weak var categoryLabel: UILabel!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    articleImage.layer.cornerRadius = 10
    articleImage.clipsToBounds = true
    articleImage.contentMode = .scaleAspectFill
  }

  func configureWith(_ article: ArticlePreview){
    
    articleImage.sd_setImage(with: article.coverImageURL, completed: nil)
    articleTitle.text = article.title
    articleTimestamp.text = article.timestamp
    categoryLabel.text = article.category.name
    
    if article.isRead {
      articleTitle.textColor = UIColor.lightGray
    }
    
    if article.isHot {
      articleTitle.textColor = UIColor(hexString: "EB6E6E")
    }

  }


  override func prepareForReuse() {
    articleTitle.textColor = UIColor.black
  }

}
