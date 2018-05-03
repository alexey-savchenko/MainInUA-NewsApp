//
//  CategoryViewController.swift
//  newsapp
//
//  Created by Alexey Savchenko on 01.09.17.
//  Copyright © 2017 Alexey Savchenko. All rights reserved.
//

import RxSwift
import UIKit

class CategoryViewController: UIViewController {
  init(viewModel: NewArticleListViewModelType) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError()
  }
  deinit {
    print("\(self) dealloc")
  }

  let disposeBag = DisposeBag()
  let viewModel: NewArticleListViewModelType
  var category: NewsCategory!
  let feedTableView = UITableView()

  lazy var _refreshControl: UIRefreshControl = {
    let refreshControl = UIRefreshControl()
    refreshControl.addTarget(self, action: #selector(handleRefresh(_:)), for: UIControlEvents.valueChanged)

    return refreshControl

  }()

  @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
    // TODO: Fix
//    viewModel.moveToFirstPage()
  }

  var activityIndicator: UIActivityIndicatorView!

  override func viewDidLoad() {
    super.viewDidLoad()

    activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
    navigationItem.rightBarButtonItems = [UIBarButtonItem(customView: activityIndicator)]
    navigationItem.title = category.name

    view.addSubview(feedTableView)
    feedTableView.snp.makeConstraints { (make) in
      make.edges.equalToSuperview()
    }

    feedTableView.rowHeight = 90
    feedTableView.register(UINib(nibName: "ArticlePreviewCell", bundle: nil), forCellReuseIdentifier: "ArticlePreviewCell")

    viewModel.articlesDriver
      .drive(feedTableView.rx.items) { tableView, row, model in
        let cell = tableView.dequeueReusableCell(withIdentifier: "ArticlePreviewCell") as! ArticlePreviewCell
        cell.configureWith(model)
        return cell
      }.disposed(by: disposeBag)
    
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
}
