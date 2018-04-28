//
//  ArticleVideoCell.swift
//  newsapp
//
//  Created by Alexey Savchenko on 27.09.2017.
//  Copyright © 2017 Alexey Savchenko. All rights reserved.
//

import UIKit
import WebKit
import AVKit

class ArticleVideoCell: UITableViewCell {
  
  var webView: WKWebView!

  override func awakeFromNib() {
    super.awakeFromNib()
    webView = WKWebView()
    webView.translatesAutoresizingMaskIntoConstraints = false

    contentView.addSubview(webView)

    setupConstraints()
  }

  func setupConstraints(){
    webView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
    webView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
    webView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
    webView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
    webView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.width * 0.5625).isActive = true
  }

  var videoURL: URL!

}
