//
//  ArticlePreviewDummyCell.swift
//  newsapp
//
//  Created by Alexey Savchenko on 14.08.17.
//  Copyright © 2017 Alexey Savchenko. All rights reserved.
//

import UIKit

class ArticlePreviewDummyCell: UITableViewCell {



  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var timeStampLabel: UILabel!
  @IBOutlet weak var previewImage: UIImageView!
  @IBOutlet weak var viewsLabel: UILabel!





  override func awakeFromNib() {
    super.awakeFromNib()

    previewImage.image = UIImage.from(color: UIColor(hexString: "EBEBEB"), size: previewImage.bounds.size)
    previewImage.layer.cornerRadius = 10
    previewImage.clipsToBounds = true

  }

}
