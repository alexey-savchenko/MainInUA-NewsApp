//
//  TagSearchVC.swift
//  newsapp
//
//  Created by Alexey Savchenko on 26.09.2017.
//  Copyright © 2017 Alexey Savchenko. All rights reserved.
//

import UIKit
import RxSwift

class TagSearchVC: UIViewController {

  required init(viewModel: NewArticleListViewModelType) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  deinit {
    print("\(self) dealloc")
  }

  let viewModel: NewArticleListViewModelType
  let disposeBag = DisposeBag()
  var targetTag: String?
  var feedTableView = UITableView()

  override func viewDidLoad() {
    super.viewDidLoad()

    navigationItem.title = targetTag ?? ""

    feedTableView = UITableView()
    feedTableView.register(UINib(nibName: "ArticlePreviewCell", bundle: nil), forCellReuseIdentifier: "ArticlePreviewCell")
    feedTableView.tableFooterView = UIView(frame: .zero)
    feedTableView.rowHeight = 90
    view.addSubview(feedTableView)

    viewModel.articlesDriver
      .drive(feedTableView.rx.items) { tableView, row, model in
        let cell = tableView.dequeueReusableCell(withIdentifier: "ArticlePreviewCell") as! ArticlePreviewCell
        cell.configureWith(model)
        return cell
      }.disposed(by: disposeBag)

    setupConstraints()
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)

    navigationController?.navigationBar.tintColor = .black
    navigationController?.navigationBar.barTintColor = .white
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)

    navigationController?.navigationBar.shadowImage = nil
    navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
  }

  func setupConstraints() {
    feedTableView.snp.makeConstraints { (make) in
      make.edges.equalToSuperview()
    }
  }

}
