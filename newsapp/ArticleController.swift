//
//  ArticleTVC.swift
//  newsapp
//
//  Created by Alexey Savchenko on 14.08.17.
//  Copyright © 2017 Alexey Savchenko. All rights reserved.
//

import UIKit
import AVKit
import RxSwift
import MobileCoreServices

final class ArticleController: UIViewController, UIScrollViewDelegate {

  // MARK: Init and deinit
  init(_ vm: SingleArticleViewModelType) {
    viewModel = vm
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  deinit {
    print("\(self) dealloc")
  }

  // MARK: Properties
  private let disposeBag = DisposeBag()
  private let viewModel: SingleArticleViewModelType
  private var articleID: Int!

  // MARK: UI
  var shareBarItem: UIBarButtonItem!
  var customBackButton: [UIBarButtonItem]!
  let tableView = UITableView()

  @objc func backPressed(){
    navigationController?.popViewController(animated: true)
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.backgroundColor = .white

    setupTableView()
    setupTableViewBindings()
    
    customBackButton = CustomBackButton.createWithText(text: "", color: .black, target: self, action: #selector(backPressed))
    navigationItem.leftBarButtonItems = customBackButton

    tableView.register(ArticleHeaderCell.self, forCellReuseIdentifier: "ArticleHeaderCell")
    tableView.register(UINib(nibName: "ArticleDescriptionCell", bundle: nil), forCellReuseIdentifier: "ArticleDescriptionCell")
    tableView.register(UINib(nibName: "ArticleImageCell", bundle: nil), forCellReuseIdentifier: "ArticleImageCell")
    tableView.register(UINib(nibName: "ArticleParagraphCell", bundle: nil), forCellReuseIdentifier: "ArticleParagraphCell")
    tableView.register(UINib(nibName: "ArticleTitleCell", bundle: nil), forCellReuseIdentifier: "ArticleTitleCell")
    tableView.register(UINib(nibName: "ArticleQuoteCell", bundle: nil), forCellReuseIdentifier: "ArticleQuoteCell")
    tableView.register(UINib(nibName: "ArticleVideoCell", bundle: nil), forCellReuseIdentifier: "ArticleVideoCell")
    tableView.register(UINib(nibName: "SocialMediaCell", bundle: nil), forCellReuseIdentifier: "SocialMediaCell")
    tableView.register(UINib(nibName: "ArticleTagsCell", bundle: nil), forCellReuseIdentifier: "ArticleTagsCell")

    navigationController?.navigationBar.shadowImage = UIImage()
    navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
    
    shareBarItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareButtonTap))
    navigationItem.rightBarButtonItems = [shareBarItem]
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

  func setupTableView() {
    view.addSubview(tableView)
    tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 16, right: 0)
    tableView.bounces = false
    tableView.allowsSelection = false
    tableView.separatorStyle = .none
    tableView.rowHeight = UITableViewAutomaticDimension
    tableView.estimatedRowHeight = 100

    if #available(iOS 11.0, *) {
      tableView.contentInsetAdjustmentBehavior = .never
    } else {
      // Fallback on earlier versions
      automaticallyAdjustsScrollViewInsets = false
    }
    tableView.snp.makeConstraints { (make) in
      make.edges.equalToSuperview()
    }
    (tableView as UIScrollView).delegate = self
  }

  func setupTableViewBindings() {
    viewModel.sectionsDriver
      .drive(tableView.rx.items(dataSource: viewModel.dataSource))
      .disposed(by: disposeBag)
  }
  
  @objc func catSelected() {
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
//    let sharingArray: [Any] = [article.webURL.absoluteString]
//
//    let vc = UIActivityViewController(activityItems: sharingArray, applicationActivities: nil)
//    vc.popoverPresentationController?.sourceView = self.navigationController!.navigationBar
//    vc.popoverPresentationController?.sourceRect = self.navigationController!.navigationBar.frame
//
//    self.present(vc, animated: true, completion: nil)
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
}
