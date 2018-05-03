//
//  ArticleTVC.swift
//  newsapp
//
//  Created by Alexey Savchenko on 14.08.17.
//  Copyright © 2017 Alexey Savchenko. All rights reserved.
//

import UIKit
import AVKit
import MobileCoreServices

class ArticleTVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
  
  static func instantiateWithAricleID(_ id: Int) -> ArticleTVC {
    let vc = ArticleTVC()
    vc.articleID = id
    return vc
  }
  
  private var articleID: Int!
  
  var shareBarItem: UIBarButtonItem!
  var article: Article!
  
  var customBackButton: [UIBarButtonItem]!
  
  @objc func backPressed(){
    navigationController?.popViewController(animated: true)
  }
  
  let tableView = UITableView()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.backgroundColor = .white
    
    tableView.dataSource = self
    tableView.delegate = self
    tableView.translatesAutoresizingMaskIntoConstraints = false
    
    view.addSubview(tableView)
    setupConstraints()
    
    customBackButton = CustomBackButton.createWithText(text: "", color: .black, target: self, action: #selector(backPressed))
    
    navigationItem.leftBarButtonItems = customBackButton
    
    tableView.estimatedRowHeight = 100
    
    tableView.register(UINib(nibName: "ArticleHeaderCell", bundle: nil), forCellReuseIdentifier: "ArticleHeaderCell")
    tableView.register(UINib(nibName: "ArticleDescriptionCell", bundle: nil), forCellReuseIdentifier: "ArticleDescriptionCell")
    tableView.register(UINib(nibName: "ArticleImageCell", bundle: nil), forCellReuseIdentifier: "ArticleImageCell")
    tableView.register(UINib(nibName: "ArticleParagraphCell", bundle: nil), forCellReuseIdentifier: "ArticleParagraphCell")
    tableView.register(UINib(nibName: "ArticleTitleCell", bundle: nil), forCellReuseIdentifier: "ArticleTitleCell")
    tableView.register(UINib(nibName: "ArticleQuoteCell", bundle: nil), forCellReuseIdentifier: "ArticleQuoteCell")
    tableView.register(UINib(nibName: "ArticleVideoCell", bundle: nil), forCellReuseIdentifier: "ArticleVideoCell")
    tableView.register(UINib(nibName: "SocialMediaCell", bundle: nil), forCellReuseIdentifier: "SocialMediaCell")
    tableView.register(UINib(nibName: "ArticleTagsCell", bundle: nil), forCellReuseIdentifier: "ArticleTagsCell")
    
    tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 16, right: 0)
    
    tableView.bounces = false
    tableView.allowsSelection = false
    tableView.separatorStyle = .none
    
    if #available(iOS 11.0, *) {
      tableView.contentInsetAdjustmentBehavior = .never
    } else {
      // Fallback on earlier versions
      automaticallyAdjustsScrollViewInsets = false
    }
    
    navigationController?.navigationBar.shadowImage = UIImage()
    navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
    
    shareBarItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareButtonTap))
    navigationItem.rightBarButtonItems = [shareBarItem]
    
    Networking.getSingleArticle(with: articleID!) { (status, article) in
      switch status {
      case .success:
        self.article = article!
        self.tableView.reloadData()
      case .fail(let errorMessage):
        self.present(UIAlertController.createWith(type: AlertType.error, message: errorMessage), animated: true, completion: nil)
      }
    }
  }
  
  func setupConstraints(){
    
    if #available(iOS 11.0, *) {
      let safeArea = view.safeAreaLayoutGuide
      
      NSLayoutConstraint.activate([tableView.topAnchor.constraint(equalTo: topLayoutGuide.topAnchor),
                                   tableView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
                                   tableView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
                                   tableView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor)])
      
    } else {
      NSLayoutConstraint.activate([tableView.topAnchor.constraint(equalTo: topLayoutGuide.topAnchor),
                                   tableView.bottomAnchor.constraint(equalTo: bottomLayoutGuide.bottomAnchor),
                                   tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                                   tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)])
      
    }
    
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    navigationController?.navigationBar.tintColor = UIColor.white
    NotificationCenter.default.addObserver(self, selector: #selector(catSelected), name: NSNotification.Name("CategorySelected"), object: nil)
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
    let offset = tableView.contentOffset.y
    
    if offset > 250 {
      
      navigationController?.navigationBar.shadowImage = nil
      navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
      navigationController?.navigationBar.tintColor = UIColor.black
      
    } else {
      
      navigationController?.navigationBar.shadowImage = UIImage()
      navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
      navigationController?.navigationBar.tintColor = UIColor.white
    }
    
    
  }
  
  @objc func catSelected(){
    // TODO: Fix
    //    let category = article.categories.first!
    //
    //    let categoryVC = CategoryViewController(viewModel:
    //      NewArticleListViewModel(with: NewWebContentLoader(),
    //                              contentBuilder: ContentBuilder(api: .category(category: category, page: 1)),
    //                              delegate: <#ArticleSelectionDelegate#>))
    //
    //    categoryVC.category = category
    //    self.navigationController?.pushViewController(categoryVC, animated: true)
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    navigationController?.navigationBar.shadowImage = nil
    navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
    NotificationCenter.default.removeObserver(self, name: NSNotification.Name("CategorySelected"), object: nil)
  }
  

  
  @objc private func shareButtonTap() {
    let sharingArray: [Any] = [article.webURL.absoluteString]
    
    let vc = UIActivityViewController(activityItems: sharingArray, applicationActivities: nil)
    vc.popoverPresentationController?.sourceView = self.navigationController!.navigationBar
    vc.popoverPresentationController?.sourceRect = self.navigationController!.navigationBar.frame
    
    self.present(vc, animated: true, completion: nil)
  }
  
  //MARK: UITableView datasource & delegate methods
  func numberOfSections(in tableView: UITableView) -> Int {
    
    guard article != nil else {
      return 0
    }
    return article.mediaArray.count + 3
    //    return article.mediaArray.count + 2
  }	
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 1
  }
  
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard article != nil else {
      return UITableViewCell()
    }
    
    if indexPath.section == 0 {
      
      let headerCell = tableView.dequeueReusableCell(withIdentifier: "ArticleHeaderCell", for: indexPath) as! ArticleHeaderCell
      
      headerCell.headerImage.sd_setImage(with: article.coverImageURL, completed: { (image, error, chacheType, url) in
        headerCell.headerImage.image = UIImage.imageWithGradient(img: image!)
      })
      
      headerCell.copyrightLabel.text = article.copyrightImage
      return headerCell
      
    } else if indexPath.section == 1 {
      
      let cell = tableView.dequeueReusableCell(withIdentifier: "ArticleTitleCell", for: indexPath) as! ArticleTitleCell
      cell.titlelabel.text = article.title
      cell.TimestampLabel.text = article.timestamp
      var catString = ""
      
      if let cat = article.categories.first?.name {
        catString = cat
      }
      
      cell.categoriesLabel.text = catString
      
      return cell
      
    } else {
      
      if indexPath.section == article.mediaArray.count + 2 {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ArticleTagsCell", for: indexPath) as! ArticleTagsCell
        
        cell.tags = article.tagArray
        cell.tagSelectionAction = { [unowned self] tag in

          // TODO: Fix
//          let tagSearchVC = TagSearchVC(viewModel:
//            NewArticleListViewModel(with: NewWebContentLoader(),
//                                    contentBuilder: ContentBuilder(api: NewsAPI.tagSearch(tag: tag, page: 1)),
//                                    delegate: <#ArticleSelectionDelegate#>))
//          tagSearchVC.targetTag = tag
//          self.navigationController?.pushViewController(tagSearchVC, animated: true)

        }
        
        return cell
        
      } else {
        
        let cellMedia = article.mediaArray[indexPath.section - 2]
        
        switch cellMedia.type {
          
        case .description:
          
          let cell = tableView.dequeueReusableCell(withIdentifier: "ArticleDescriptionCell") as! ArticleDescriptionCell
          cell.descriptionText.text = (cellMedia as! DescriptionMedia).content
          
          return cell
          
        case .text:
          
          let cell = tableView.dequeueReusableCell(withIdentifier: "ArticleParagraphCell") as! ArticleParagraphCell
          cell.textParapraph.text = "    \((cellMedia as! TextMedia).content)"
          
          return cell
          
        case .image:
          
          let cell = tableView.dequeueReusableCell(withIdentifier: "ArticleImageCell") as! ArticleImageCell
          cell.contentImage.sd_setImage(with: URL.init(string: (cellMedia as! ImageMedia).content)!, completed: nil)
          
          
          return cell
          
        case .quote:
          
          let cell = tableView.dequeueReusableCell(withIdentifier: "ArticleQuoteCell") as! ArticleQuoteCell
          cell.quoteText.text = "    \((cellMedia as! QuoteMedia).content)"
          
          return cell
          
        case .video:
          
          let cell = tableView.dequeueReusableCell(withIdentifier: "ArticleVideoCell") as! ArticleVideoCell
          
          let videoURL = URL(string: (cellMedia as! VideoMedia).content)!
          cell.videoURL = videoURL
          
          return cell
        case .twitter:
          
          let cell = tableView.dequeueReusableCell(withIdentifier: "SocialMediaCell") as! SocialMediaCell
          
          let socialURL = URL(string: (cellMedia as! TwitterMedia).content)!
          cell.socialURL = socialURL
          
          return cell
          
        case .facebook:
          let cell = tableView.dequeueReusableCell(withIdentifier: "SocialMediaCell") as! SocialMediaCell
          
          let socialURL = URL(string: (cellMedia as! FacebookMedia).content)!
          cell.socialURL = socialURL
          
          return cell
        case .instagram:
          let cell = tableView.dequeueReusableCell(withIdentifier: "SocialMediaCell") as! SocialMediaCell
          
          let socialURL = URL(string: (cellMedia as! InstagramMedia).content)!
          cell.socialURL = socialURL
          
          return cell
          
        default:
          return UITableViewCell()
        }
      }
    }
  }
  
  func tableView(_ tableView: UITableView,
                 willDisplay cell: UITableViewCell,
                 forRowAt indexPath: IndexPath) {
    if let _cell = cell as? ArticleVideoCell {
      _cell.webView.load(URLRequest(url: _cell.videoURL))
    }
    if let _cell = cell as? SocialMediaCell {
      let cellMedia = article.mediaArray[indexPath.section - 2]
      if cellMedia.type == .twitter {
        _cell.loadTwitterPost()
      } else {
        _cell.loadWebContent()
      }
    }
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    guard article != nil else {
      return 0
    }
    
    if indexPath.section == 0 {
      return UIScreen.main.bounds.width * 0.5625
    } else {
      return UITableViewAutomaticDimension
    }
  }
  
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    let offset = scrollView.contentOffset.y
    let threshold = UIScreen.main.bounds.width * 0.5625
    
    if offset > threshold {
      navigationController?.navigationBar.shadowImage = nil
      navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
      navigationController?.navigationBar.tintColor = UIColor.black
    } else {
      navigationController?.navigationBar.shadowImage = UIImage()
      navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
      navigationController?.navigationBar.tintColor = UIColor.white
    }
  }

  deinit {
    print("\(self) dealloc")
  }
}
