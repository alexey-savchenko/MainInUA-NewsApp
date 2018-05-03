//
//  CategoryViewController.swift
//  newsapp
//
//  Created by Alexey Savchenko on 01.09.17.
//  Copyright © 2017 Alexey Savchenko. All rights reserved.
//

import RxSwift
import UIKit

class CategoryVC: UIViewController {

  // MARK: Init and deinit
  init(viewModel: ArticleListViewModelType) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError()
  }
  deinit {
    print("\(self) dealloc")
  }

  // MARK: Properties
  let disposeBag = DisposeBag()
  let viewModel: ArticleListViewModelType
  var category: NewsCategory!

  // MARK: UI
  let feedTableView = UITableView()
  var activityIndicator: UIActivityIndicatorView!
  lazy var _refreshControl: UIRefreshControl = {
    let refreshControl = UIRefreshControl()
    refreshControl.addTarget(self, action: #selector(handleRefresh(_:)), for: UIControlEvents.valueChanged)

    return refreshControl

  }()

  // MARK: Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()

    activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
    navigationItem.rightBarButtonItems = [UIBarButtonItem(customView: activityIndicator)]
    navigationItem.title = category.name

    setupTableView()
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

  // MARK: Functions
  private func setupTableView() {
    view.addSubview(feedTableView)
    feedTableView.snp.makeConstraints { (make) in
      make.edges.equalToSuperview()
    }
    feedTableView.rowHeight = 90
    feedTableView.register(UINib(nibName: "ArticlePreviewCell", bundle: nil), forCellReuseIdentifier: "ArticlePreviewCell")
    setupTableViewBindings()
  }

  @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
    // TODO: Fix
    //    viewModel.moveToFirstPage()
  }

  private func setupTableViewBindings() {
    viewModel.articlesDriver
      .drive(feedTableView.rx.items) { tableView, row, model in
        let cell = tableView.dequeueReusableCell(withIdentifier: "ArticlePreviewCell") as! ArticlePreviewCell
        cell.configureWith(model)
        return cell
      }.disposed(by: disposeBag)

    feedTableView.rx
      .modelSelected(ArticlePreview.self)
      .subscribe(viewModel.articleSelectedSubject)
      .disposed(by: disposeBag)

    feedTableView.rx.willDisplayCell
      .subscribe(onNext: { [unowned self] (cellIndexPathPair) in
        if cellIndexPathPair.indexPath.row >= (self.feedTableView.numberOfRows(inSection: 0) - 3) {
          self.viewModel.moveToNextPageIfNeededSubject.onNext(())
        }
      }).disposed(by: disposeBag)
  }
}
