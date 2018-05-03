//
//  SearchVC.swift
//  newsapp
//
//  Created by Alexey Savchenko on 25.09.17.
//  Copyright © 2017 Alexey Savchenko. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class SearchVC: UIViewController {

  deinit {
    print("\(self) dealloc")
  }
  
  var feedTV: UITableView!
  var articleArray = [ArticlePreview]()
  var activityIndicator: UIActivityIndicatorView!
  
  let searchController = UISearchController(searchResultsController: nil)
  
  var customBackButton: [UIBarButtonItem]!
  
  var viewModel: SearchNewsViewModel!
  
  let disposeBag = DisposeBag()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    feedTV = UITableView()
    feedTV.translatesAutoresizingMaskIntoConstraints = false
    feedTV.register(UINib(nibName: "ArticlePreviewCell", bundle: nil), forCellReuseIdentifier: "ArticlePreviewCell")
    feedTV.rowHeight = 90
    feedTV.allowsSelection = true
    feedTV.keyboardDismissMode = .interactive
    feedTV.tableFooterView = UIView(frame: .zero)
    
    view.addSubview(feedTV)
    
    //    self.navigationItem.searchController = searchController
    feedTV.tableHeaderView = searchController.searchBar
    view.backgroundColor = .white

    activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
    navigationItem.rightBarButtonItems = [UIBarButtonItem(customView: activityIndicator)]

    searchController.hidesNavigationBarDuringPresentation = false
    searchController.searchBar.barTintColor = UIColor(hexString: "EBEBEB")
    //    navigationItem.hidesSearchBarWhenScrolling = false
    searchController.dimsBackgroundDuringPresentation = false
    
    

    
    setupConstraints()
    
    viewModel = SearchNewsViewModel(searchService: NewsSearchService(query: searchController.searchBar.rx.text.orEmpty.asDriver()))

    viewModel.querying.asObservable().subscribe { [unowned self] (event) in
      switch event {
      case .next(let value):
        value ? self.activityIndicator.startAnimating() : self.activityIndicator.stopAnimating()
      default:
        break
      }
      }.disposed(by: disposeBag)

    viewModel.searchResultsDriver.asObservable().bind(to: feedTV.rx.items(cellIdentifier: "ArticlePreviewCell", cellType: ArticlePreviewCell.self)) { row, article, cell in
      cell.configureWith(article)
      }.disposed(by: disposeBag)
    
    feedTV.rx.modelSelected(ArticlePreview.self)
      .subscribe(onNext: { [unowned self] (article) in
        print("Selected - \(article.title)")
        self.feedTV.deselectRow(at: self.feedTV.indexPathForSelectedRow!, animated: true)
        self.searchController.dismiss(animated: true, completion: nil)
        let vc = ArticleTVC.instantiateWithAricleID(article.id)
        self.navigationController?.pushViewController(vc, animated: true)
      }).disposed(by: disposeBag)
    
  }
  
  func setupConstraints() {

    if #available(iOS 11.0, *) {
      let safeArea = view.safeAreaLayoutGuide
      
      NSLayoutConstraint.activate([feedTV.topAnchor.constraint(equalTo: safeArea.topAnchor),
                                   feedTV.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
                                   feedTV.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
                                   feedTV.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor)])
      
    } else {
      NSLayoutConstraint.activate([feedTV.topAnchor.constraint(equalTo: topLayoutGuide.topAnchor),
                                   feedTV.bottomAnchor.constraint(equalTo: bottomLayoutGuide.bottomAnchor),
                                   feedTV.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                                   feedTV.trailingAnchor.constraint(equalTo: view.trailingAnchor)])

    }
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    navigationController?.navigationBar.tintColor = UIColor.black
  }

  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    searchController.dismiss(animated: true, completion: nil)
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    navigationController?.navigationBar.shadowImage = nil
    navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
  }
}
