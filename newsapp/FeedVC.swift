//
//  FeedTVC.swift
//  newsapp
//
//  Created by Alexey Savchenko on 14.08.17.
//  Copyright © 2017 Alexey Savchenko. All rights reserved.
//

import UIKit

class FeedVC: UIViewController, ArticleSelectable, ArticleListPresentable {
  
  required init(viewModel: ArticleListViewModelType) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError()
  }
  
  var viewModel: ArticleListViewModelType
  
  var feedTV: UITableView!
  
  let categories: [NewsCategory] = [NewsCategory(name: "В Україні", rawName: "in-ukraine"),
                                    NewsCategory(name: "Економіка", rawName: "ekonomika"),
                                    NewsCategory(name: "Культура", rawName: "kultura"),
                                    NewsCategory(name: "Політика", rawName: "politika"),
                                    NewsCategory(name: "Спорт", rawName: "sport"),
                                    NewsCategory(name: "IT", rawName: "it"),
                                    NewsCategory(name: "Суспільство", rawName: "suspilstvo"),
                                    NewsCategory(name: "У світі", rawName: "u-sviti")]
  
  var animationInProgress = false
  
  let blackView = UIView() 
  
  var menuIsShown = false
  
  
  func toggleMenu() {
    guard animationInProgress == false else {
      return
    }
    if menuIsShown {
      
      animationInProgress = true
      self.menuLeadingConstraint.constant = -300
      self.hamburgerItem.image = UIImage(named: "hamburgerImage")
      UIView.animate(withDuration: 0.3, animations: {
        
        self.menuTableView.layoutIfNeeded()
        self.blackView.alpha = 0
        
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
        self.blackView.alpha = 1
        
      }, completion: { (_) in
        
        self.animationInProgress = false
        
      })
      
      menuIsShown = true
      
    }
  }
  
  @objc func hamburgerTap(){
    toggleMenu()
  }
  
  lazy var _refreshControl: UIRefreshControl = {
    let refreshControl = UIRefreshControl()
    refreshControl.addTarget(self, action: #selector(handleRefresh(_:)), for: UIControlEvents.valueChanged)
    
    return refreshControl
    
  }()
  
  @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
    viewModel.moveToFirstPage()
  }
  
  var menuLeadingConstraint: NSLayoutConstraint!
  
  @objc func blackViewTap(){
    toggleMenu()
  }
  
  var hamburgerItem: UIBarButtonItem!
  var activityIndicator: UIActivityIndicatorView!
  var menuTableView: UITableView!
  var searchButton: UIBarButtonItem!
  
  
  @objc func searchTapped() {
    navigationController?.pushViewController(SearchVC(), animated: true)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.backgroundColor = .white
    
    hamburgerItem = UIBarButtonItem(image: UIImage(named: "hamburgerImage"),
                                    style: .done,
                                    target: self,
                                    action: #selector(hamburgerTap))
    
    navigationItem.leftBarButtonItems = [hamburgerItem]
    
    self.navigationController?.interactivePopGestureRecognizer?.delegate = nil
    
    activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
    searchButton = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(searchTapped))
    navigationItem.rightBarButtonItems = [searchButton, UIBarButtonItem.init(customView: activityIndicator)]
    
    
    blackView.translatesAutoresizingMaskIntoConstraints = false
    blackView.backgroundColor = UIColor(white: 0, alpha: 0.5)
    blackView.alpha = 0
    blackView.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(blackViewTap)))
    
    feedTV = UITableView()
    feedTV.dataSource = self
    feedTV.translatesAutoresizingMaskIntoConstraints = false
    feedTV.delegate = self
    feedTV.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    feedTV.tableFooterView = UIView(frame: .zero)
    
    view.addSubview(feedTV)
    
    menuTableView = UITableView()
    menuTableView.translatesAutoresizingMaskIntoConstraints = false
    menuTableView.dataSource = self
    menuTableView.delegate = self
    menuTableView.tableFooterView = UIView(frame: .zero)
    
    
    view.addSubview(menuTableView)
    view.bringSubview(toFront: menuTableView)
    view.insertSubview(blackView, belowSubview: menuTableView)
    
    setupConstraints()
    
    feedTV.refreshControl = _refreshControl
    feedTV.register(UINib(nibName: "ArticlePreviewDummyCell", bundle: nil), forCellReuseIdentifier: "ArticlePreviewDummyCell")
    feedTV.register(UINib(nibName: "ArticlePreviewCell", bundle: nil), forCellReuseIdentifier: "ArticlePreviewCell")
    feedTV.register(UINib(nibName: "YearEventsCell", bundle: nil), forCellReuseIdentifier: "YearEventsCell")
    
    self.navigationItem.titleView = {
      let image : UIImage = UIImage(named: "logoSmall.png")!
      let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
      imageView.contentMode = .scaleAspectFit
      imageView.image = image
      return imageView
    }()
    
    viewModel.didLoadNews = { [unowned self] in
      self.feedTV.reloadData()
      self._refreshControl.endRefreshing()
    }
    
    viewModel.didFailLoading = { [unowned self] message in
      self.present(UIAlertController.createWith(type: .error, message: message), animated: true, completion: nil)
      self._refreshControl.endRefreshing()
    }
    
    viewModel.loadArticles()
    
  }
  
  func setupConstraints() {
    
    if #available(iOS 11.0, *) {
      let safeArea = view.safeAreaLayoutGuide
      
      feedTV.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 0).isActive = true
      feedTV.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor).isActive = true
      feedTV.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor).isActive = true
      feedTV.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor).isActive = true
      
      menuTableView.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 0).isActive = true
      menuTableView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor).isActive = true
      menuTableView.widthAnchor.constraint(equalToConstant: 200).isActive = true
      
      menuLeadingConstraint = menuTableView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor)
      menuLeadingConstraint.constant = -300
      menuLeadingConstraint.isActive = true
      
      blackView.topAnchor.constraint(equalTo: safeArea.topAnchor).isActive = true
      blackView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor).isActive = true
      blackView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor).isActive = true
      blackView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor).isActive = true
      
    } else {
      // Fallback on earlier versions
      automaticallyAdjustsScrollViewInsets = false
      feedTV.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor).isActive = true
      feedTV.bottomAnchor.constraint(equalTo: bottomLayoutGuide.bottomAnchor).isActive = true
      feedTV.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
      feedTV.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
      
      menuTableView.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor, constant: 0).isActive = true
      menuTableView.bottomAnchor.constraint(equalTo: bottomLayoutGuide.bottomAnchor).isActive = true
      menuTableView.widthAnchor.constraint(equalToConstant: 200).isActive = true
      
      menuLeadingConstraint = menuTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor)
      menuLeadingConstraint.constant = -300
      menuLeadingConstraint.isActive = true
      
      blackView.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor).isActive = true
      blackView.bottomAnchor.constraint(equalTo: bottomLayoutGuide.bottomAnchor).isActive = true
      blackView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
      blackView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
      
    }
    

    
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
  
  func yearEventSelected(){
    
    navigationController?.pushViewController(YearEventsVC(), animated: true)
    
  }
  
  
}

extension FeedVC: UITableViewDataSource, UITableViewDelegate {
  
  func numberOfSections(in tableView: UITableView) -> Int {
    
    if tableView == feedTV {
      return 2
    } else {
      return 1
    }
    
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if tableView == feedTV {
      if section == 0 {
        //Extra section for Year event
        return 1
      } else {
        if viewModel.numberOfArticles() == 0 {
          return 10
        } else {
          return viewModel.numberOfArticles()
        }
      }
    } else {
      return categories.count + 1
    }
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    if tableView == feedTV {
      if indexPath.section == 0 {
        return 200
      } else {
        return 90
      }
    } else {
      return UITableViewAutomaticDimension
    }
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    if tableView == feedTV {
      
      if indexPath.section == 0 {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "YearEventsCell", for: indexPath) as! YearEventsCell
        cell.selectionStyle = .none
        return cell
        
      } else {
        
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
     
    } else {
      
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
    
  }
  
  func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    
    if tableView == feedTV {
      
      guard indexPath.section == 1 else { return }
      
      if indexPath.row == tableView.numberOfRows(inSection: 1) - 3 {
        if viewModel.shouldMoveToNextPage {
          viewModel.moveToNextPage()
        }
      }
      
    }
    
  }
  
  func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
    guard (0..<viewModel.numberOfArticles()).contains(indexPath.row) else { return nil }
    return indexPath
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
    if tableView == feedTV {
      
      if indexPath.section == 0 {
        //Year event
        yearEventSelected()
      } else {
        articleSelectedWithID(viewModel.articleForItemAt(indexPath).id)
      }
      
    } else {
      
      guard indexPath.row != 0 else { return }
      
      tableView.deselectRow(at: indexPath, animated: true)
      
      toggleMenu()
      
      DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
        let category = self.categories[indexPath.row - 1]
        
        let categoryVC = CategoryViewController(viewModel:
          ArticleListViewModel(with: WebContentLoader(),
                               contentBuilder: ContentBuilder(api: .category(category: category, page: 1))))
        
        categoryVC.category = category
        self.navigationController?.pushViewController(categoryVC, animated: true)
        
      })
    }
    
  }
  
  
}
