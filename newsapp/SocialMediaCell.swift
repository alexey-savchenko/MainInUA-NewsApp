//
//  SocialMediaCell.swift
//  newsapp
//
//  Created by iosUser on 30.10.2017.
//  Copyright © 2017 Alexey Savchenko. All rights reserved.
//

import UIKit
import WebKit
import TwitterKit

class SocialMediaCell: UITableViewCell {
  
  var socialURL: URL!
  
  let containerView = UIView()
  var webView = WKWebView()
  
  override func awakeFromNib() {
    super.awakeFromNib()
    
    contentView.addSubview(containerView)
    containerView.translatesAutoresizingMaskIntoConstraints = false
    
    webView.translatesAutoresizingMaskIntoConstraints = false
    
    setupConstraints()
  }
  

  
  func setupConstraints(){
    
    containerView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
    containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
    containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
    containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
    containerView.heightAnchor.constraint(equalToConstant: 500).isActive = true
    
  }
  
  func loadWebContent(){
    
    let webViews = contentView.subviews.filter { (view) -> Bool in
      return view.isKind(of: WKWebView.self)
    }
    
    guard webViews.isEmpty else {
      return
    }
    
    containerView.addSubview(webView)
    
    webView.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
    webView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor).isActive = true
    webView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor).isActive = true
    webView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true
  
    webView.load(URLRequest(url: self.socialURL))
    
  }
  
  func loadTwitterPost(){
    
    let tweets = contentView.subviews.filter { (view) -> Bool in
      return view.isKind(of: TWTRTweetView.self)
    }
    
    guard tweets.isEmpty else {
      return
    }
    
    TWTRAPIClient().loadTweet(withID: socialURL.lastPathComponent) { (tweet, error) in
      
      if error == nil {
        
        let tweetView = TWTRTweetView(tweet: tweet!, style: .regular)
        
        self.containerView.addSubview(tweetView)

        tweetView.translatesAutoresizingMaskIntoConstraints = false
        
        tweetView.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor).isActive = true
        tweetView.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor).isActive = true
        self.webView.heightAnchor.constraint(equalToConstant: 400).isActive = true

      }
      
    }
    
  }
  
  
  override func prepareForReuse() {
    super.prepareForReuse()
    
    let _ = containerView.subviews.map {$0.removeFromSuperview()}
    
  }
  
    
}

