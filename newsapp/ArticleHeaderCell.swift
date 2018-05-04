//
//  ArticleHeaderCell.swift
//  newsapp
//
//  Created by Alexey Savchenko on 14.08.17.
//  Copyright © 2017 Alexey Savchenko. All rights reserved.
//

import UIKit

class ArticleHeaderCell: UITableViewCell {
  let headerImage = UIImageView()
  let copyrightLabel = UILabel()

  override func layoutSubviews() {
    super.layoutSubviews()
    guard contentView.subviews.isEmpty else {
      return
    }

    contentView.addSubview(headerImage)
    contentView.addSubview(copyrightLabel)

    headerImage.snp.makeConstraints { make in
      make.edges.equalToSuperview()
      make.height.equalTo((UIScreen.main.bounds.width * 0.5625))
    }

    copyrightLabel.snp.makeConstraints { (make) in
      make.trailing.equalToSuperview()
      make.bottom.equalToSuperview()
    }

    copyrightLabel.backgroundColor = UIColor.white.withAlphaComponent(0.3)

  }
}
