//
//  TagSearchVC.swift
//  newsapp
//
//  Created by Alexey Savchenko on 26.09.2017.
//  Copyright © 2017 Alexey Savchenko. All rights reserved.
//

import UIKit

class TagSearchVC: UIViewController, ArticleSelectable, ArticleListPresentable {

  var viewModel: ArticleListViewModelType

  required init(viewModel: ArticleListViewModelType) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  
  var targetTag: String?
//  var currentPage = 1
//  var totalPages = 1
//  var loadingInProgress = false
  
//  var articleArray = [ArticlePreview]() {
//    didSet{
//      print("searchResults count - \(articleArray.count)")
//    }
//  }

//  var customBackButton: [UIBarButtonItem]!
//  var activityIndicator: UIActivityIndicatorView!

  var feedTV: UITableView!
//
//  @objc func backPressed(){
//    navigationController?.popViewController(animated: true)
//  }



  override func viewDidLoad() {
    super.viewDidLoad()

    navigationItem.title = targetTag ?? ""

//    activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
//    navigationItem.rightBarButtonItems = [UIBarButtonItem(customView: activityIndicator)]

//    customBackButton = CustomBackButton.createWithText(text: "", color: .black, target: self, action: #selector(backPressed))
//    navigationItem.leftBarButtonItems = customBackButton

    feedTV = UITableView()
    feedTV.delegate = self
    feedTV.dataSource = self
    feedTV.translatesAutoresizingMaskIntoConstraints = false
    feedTV.register(UINib(nibName: "ArticlePreviewCell", bundle: nil), forCellReuseIdentifier: "ArticlePreviewCell")
    feedTV.tableFooterView = UIView(frame: .zero)
    feedTV.rowHeight = 90
    view.addSubview(feedTV)

    setupConstraints()

    viewModel.didLoadNews = { [unowned self] in
      self.feedTV.reloadData()
    }
    
    viewModel.didFailLoading = { [unowned self] message in
      self.present(UIAlertController.createWith(type: .error, message: message), animated: true, completion: nil)
    }
    
    viewModel.loadArticles()
    
    
//    activityIndicator.startAnimating()
//    Networking.searchNewsWithTag(targetTag!, page: 1) { (status, articles, totalPageCount) in
//
//      switch status {
//      case .success:
//
//        self.articleArray = articles!
//        self.currentPage = 1
//        self.totalPages = totalPageCount!
//        self.activityIndicator.stopAnimating()
//        self.loadingInProgress = false
//        self.feedTV.reloadData()
//
//      case .fail(let errorMessage):
//
//        self.loadingInProgress = false
//        self.present(UIAlertController.createWith(type: AlertType.error, message: errorMessage), animated: true, completion: nil)
//        self.activityIndicator.stopAnimating()
//
//      }
//
//    }

  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)

    navigationController?.navigationBar.tintColor = UIColor.black
    navigationController?.navigationBar.barTintColor = UIColor.white

  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)

    navigationController?.navigationBar.shadowImage = nil
    navigationController?.navigationBar.setBackgroundImage(nil, for: .default)

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
  
  deinit {
    print("\(self) dealloc")
  }
  
}

extension TagSearchVC: UITableViewDataSource, UITableViewDelegate {

  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return viewModel.numberOfArticles()
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "ArticlePreviewCell", for: indexPath) as! ArticlePreviewCell

    cell.selectionStyle = .none
    cell.configureWith(viewModel.articleForItemAt(indexPath))

    return cell
  }

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    articleSelectedWithID(viewModel.articleForItemAt(indexPath).id)
  }

  func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {

    if indexPath.row == tableView.numberOfRows(inSection: 0) - 3 {
      if viewModel.shouldMoveToNextPage {
        viewModel.moveToNextPage()
      }
    }
    
//    if indexPath.row == articleArray.count - 3 && currentPage < totalPages && !loadingInProgress {
//
//      loadingInProgress = true
//      activityIndicator.startAnimating()
//
//      Networking.searchNewsWithTag(targetTag, page: (currentPage + 1)) { (status, articles, totalPageCount) in
//
//        switch status {
//        case .success:
//
//          self.articleArray.append(contentsOf: articles!)
//          self.currentPage += 1
//          self.totalPages = totalPageCount!
//          self.activityIndicator.stopAnimating()
//          self.loadingInProgress = false
//          self.feedTV.reloadData()
//
//        case .fail(let errorMessage):
//
//          self.loadingInProgress = false
//          self.present(UIAlertController.createWith(type: AlertType.error, message: errorMessage), animated: true, completion: nil)
//          self.activityIndicator.stopAnimating()
//
//        }
//
//      }
//
//    }

  }

}
