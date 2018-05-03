//
//  FeedTVC.swift
//  newsapp
//
//  Created by Alexey Savchenko on 14.08.17.
//  Copyright © 2017 Alexey Savchenko. All rights reserved.
//

import UIKit
import SnapKit
import RxCocoa
import RxSwift

final class FeedVC: UIViewController {

  // Init and deinit
  init(_ vm: ArticleListViewModelType) {
    viewModel = vm
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError()
  }

  deinit {
    print("\(self) dealloc")
  }

  // MARK: Properties
  private let disposeBag = DisposeBag()
  private let viewModel: ArticleListViewModelType
  private let categories: [NewsCategory] = [NewsCategory(name: "В Україні", rawName: "in-ukraine"),
                                            NewsCategory(name: "Економіка", rawName: "ekonomika"),
                                            NewsCategory(name: "Культура", rawName: "kultura"),
                                            NewsCategory(name: "Політика", rawName: "politika"),
                                            NewsCategory(name: "Спорт", rawName: "sport"),
                                            NewsCategory(name: "IT", rawName: "it"),
                                            NewsCategory(name: "Суспільство", rawName: "suspilstvo"),
                                            NewsCategory(name: "У світі", rawName: "u-sviti")]
  
  var animationInProgress = false
  var menuIsShown = false

  // MARK: UI
  private let menuBackgroundView = UIView()
  private let feedTableView = UITableView()
  private let hamburgerItem = UIBarButtonItem(image: #imageLiteral(resourceName: "hamburgerImage"), style: .done, target: self, action: #selector(toggleMenu))
  private let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
  private let menuTableView = UITableView()
  private let searchButton = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(searchTapped))
  
  
  @objc func toggleMenu() {
    guard animationInProgress == false else {
      return
    }
    if menuIsShown {
      animationInProgress = true
      self.menuLeadingConstraint.constant = -300
      self.hamburgerItem.image = UIImage(named: "hamburgerImage")
      UIView.animate(withDuration: 0.3, animations: {
        self.menuTableView.layoutIfNeeded()
        self.menuBackgroundView.alpha = 0
      }, completion: { (_) in
        self.animationInProgress = false
      })
      
      menuIsShown = false
    } else {
      animationInProgress = true
      
      self.menuLeadingConstraint.constant = 0
      self.hamburgerItem.image = UIImage(named: "crossImage")
      UIView.animate(withDuration: 0.3, animations: {
        
        self.menuTableView.layoutIfNeeded()
        self.menuBackgroundView.alpha = 1
        
      }, completion: { (_) in
        
        self.animationInProgress = false
        
      })
      menuIsShown = true
    }
  }

  lazy var _refreshControl: UIRefreshControl = {
    let refreshControl = UIRefreshControl()
    refreshControl.addTarget(self, action: #selector(handleRefresh(_:)), for: UIControlEvents.valueChanged)
    return refreshControl
  }()
  
  @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
    // TODO: Fix
    // viewModel.moveToFirstPage()
  }
  
  var menuLeadingConstraint: NSLayoutConstraint!

  // MARK: Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.backgroundColor = .white
    navigationItem.leftBarButtonItems = [hamburgerItem]
    navigationController?.interactivePopGestureRecognizer?.delegate = nil

    navigationItem.rightBarButtonItems = [searchButton, UIBarButtonItem(customView: activityIndicator)]

    setupMenuTableView()
    setupFeedTableView()
    
    view.addSubview(menuTableView)
    view.bringSubview(toFront: menuTableView)
    view.insertSubview(menuBackgroundView, belowSubview: menuTableView)
    
    setupConstraints()

    self.navigationItem.titleView = {
      let image: UIImage = #imageLiteral(resourceName: "logoSmall")
      let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
      imageView.contentMode = .scaleAspectFit
      imageView.image = image
      return imageView
    }()
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    navigationController?.navigationBar.tintColor = .black
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)

    navigationController?.navigationBar.shadowImage = nil
    navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
  }

  fileprivate func setupMenuTableView() {
    menuBackgroundView.backgroundColor = UIColor(white: 0, alpha: 0.5)
    menuBackgroundView.alpha = 0
    menuBackgroundView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(toggleMenu)))

    menuTableView.dataSource = self
    menuTableView.delegate = self
    menuTableView.tableFooterView = UIView(frame: .zero)
  }

  private func setupFeedTableView() {
    feedTableView.refreshControl = _refreshControl
    feedTableView.register(UINib(nibName: "ArticlePreviewDummyCell", bundle: nil), forCellReuseIdentifier: "ArticlePreviewDummyCell")
    feedTableView.register(UINib(nibName: "ArticlePreviewCell", bundle: nil), forCellReuseIdentifier: "ArticlePreviewCell")
    feedTableView.tableFooterView = UIView(frame: .zero)
    feedTableView.rowHeight = 90
    view.addSubview(feedTableView)
    feedTableView.snp.makeConstraints { (make) in
      make.edges.equalToSuperview()
    }
    setupFeedTableViewBindings()
  }

  private func setupFeedTableViewBindings() {
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

  @objc func searchTapped() {
    navigationController?.pushViewController(SearchVC(), animated: true)
  }
  
  func setupConstraints() {
    
    if #available(iOS 11.0, *) {
      let safeArea = view.safeAreaLayoutGuide

      menuTableView.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 0).isActive = true
      menuTableView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor).isActive = true
      menuTableView.widthAnchor.constraint(equalToConstant: 200).isActive = true
      
      menuLeadingConstraint = menuTableView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor)
      menuLeadingConstraint.constant = -300
      menuLeadingConstraint.isActive = true
      
      menuBackgroundView.topAnchor.constraint(equalTo: safeArea.topAnchor).isActive = true
      menuBackgroundView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor).isActive = true
      menuBackgroundView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor).isActive = true
      menuBackgroundView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor).isActive = true
      
    } else {
      // Fallback on earlier versions
      automaticallyAdjustsScrollViewInsets = false

      menuTableView.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor, constant: 0).isActive = true
      menuTableView.bottomAnchor.constraint(equalTo: bottomLayoutGuide.bottomAnchor).isActive = true
      menuTableView.widthAnchor.constraint(equalToConstant: 200).isActive = true
      
      menuLeadingConstraint = menuTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor)
      menuLeadingConstraint.constant = -300
      menuLeadingConstraint.isActive = true
      
      menuBackgroundView.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor).isActive = true
      menuBackgroundView.bottomAnchor.constraint(equalTo: bottomLayoutGuide.bottomAnchor).isActive = true
      menuBackgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
      menuBackgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
      
    }
  }
}

extension FeedVC: UITableViewDataSource, UITableViewDelegate {

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return categories.count + 1
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

    if indexPath.row == 0 {
      let cell = UITableViewCell()
      cell.textLabel?.text = "Розділи:"
      cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 20)
      cell.selectionStyle = .none
      return cell

    } else {
      let cell = UITableViewCell()
      cell.textLabel?.text = categories[indexPath.row - 1].name
      return cell
    }
  }

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if tableView == menuTableView {
      guard indexPath.row != 0 else { return }
      tableView.deselectRow(at: indexPath, animated: true)
      toggleMenu()
      
      DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
        //TODO: Fix
        //        let category = self.categories[indexPath.row - 1]
        //        let categoryVC = CategoryViewController(viewModel:
        //          NewArticleListViewModel(with: NewWebContentLoader(),
        //                                  contentBuilder: ContentBuilder(api: .category(category: category, page: 1)),
        //                                  delegate: <#ArticleSelectionDelegate#>))
        //        categoryVC.category = category
        //        self.navigationController?.pushViewController(categoryVC, animated: true)

      })
    }
  }
}
