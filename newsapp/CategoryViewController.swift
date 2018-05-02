//
//  CategoryViewController.swift
//  newsapp
//
//  Created by Alexey Savchenko on 01.09.17.
//  Copyright © 2017 Alexey Savchenko. All rights reserved.
//

import UIKit

class CategoryViewController: UIViewController, ArticleSelectable, ArticleListPresentable {

  required init(viewModel: ArticleListViewModelType) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError()
  }
  
  var viewModel: ArticleListViewModelType

  var category: NewsCategory!

  var feedTableView: UITableView!

  lazy var _refreshControl: UIRefreshControl = {
    let refreshControl = UIRefreshControl()
    refreshControl.addTarget(self, action: #selector(handleRefresh(_:)), for: UIControlEvents.valueChanged)

    return refreshControl

  }()

  @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
    viewModel.moveToFirstPage()
  }

  var activityIndicator: UIActivityIndicatorView!

  override func viewDidLoad() {
    super.viewDidLoad()

    activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
    navigationItem.rightBarButtonItems = [UIBarButtonItem.init(customView: activityIndicator)]
    navigationItem.title = category.name

    feedTableView = UITableView()
    feedTableView.frame = view.frame
    feedTableView.dataSource = self
    feedTableView.delegate = self
    view.addSubview(feedTableView)
    
    feedTableView.rowHeight = 90
    feedTableView.register(UINib(nibName: "ArticlePreviewDummyCell", bundle: nil), forCellReuseIdentifier: "ArticlePreviewDummyCell")
    feedTableView.register(UINib(nibName: "ArticlePreviewCell", bundle: nil), forCellReuseIdentifier: "ArticlePreviewCell")

    viewModel.didLoadNews = { [unowned self] in
      self.feedTableView.reloadData()
      self._refreshControl.endRefreshing()
    }
    
    viewModel.didFailLoading = { [unowned self] message in
      self.present(UIAlertController.createWith(type: .error, message: message), animated: true, completion: nil)
      self._refreshControl.endRefreshing()
    }
    
    viewModel.loadArticles()
    
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)

    navigationController?.navigationBar.tintColor = UIColor.black
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)

    navigationController?.navigationBar.shadowImage = nil
    navigationController?.navigationBar.setBackgroundImage(nil, for: .default)

  }

  deinit {
    print("\(self) dealloc")
  }

}

extension CategoryViewController: UITableViewDataSource, UITableViewDelegate {

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//    return viewModel.numberOfArticles()
    if viewModel.numberOfArticles() == 0 {
      return 10
    } else {
      return viewModel.numberOfArticles()
    }
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

    if viewModel.numberOfArticles() == 0 {
      
      let cell = tableView.dequeueReusableCell(withIdentifier: "ArticlePreviewDummyCell") as! ArticlePreviewDummyCell
      return cell
      
    } else {
      
      let cell = tableView.dequeueReusableCell(withIdentifier: "ArticlePreviewCell", for: indexPath) as! ArticlePreviewCell
      cell.selectionStyle = .none
      cell.configureWith(viewModel.articleForItemAt(indexPath))
      return cell
      
    }
  }

  func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    if indexPath.row == tableView.numberOfRows(inSection: 0) - 3 {
      if viewModel.shouldMoveToNextPage {
        viewModel.moveToNextPage()
      }
    }
  }

  func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
    guard (0..<viewModel.numberOfArticles()).contains(indexPath.row) else { return nil }
    return indexPath
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    articleSelectedWithID(viewModel.articleForItemAt(indexPath).id)
  }

}


