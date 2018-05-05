//
//  YearEventVC.swift
//  newsapp
//
//  Created by iosUser on 18.12.2017.
//  Copyright © 2017 Alexey Savchenko. All rights reserved.
//

import UIKit

class YearEventVC: UIViewController {
  
  let eventID: Int
  
  var tableView = UITableView()
  
  var event: YearEvent?
  
  var customBackButton: [UIBarButtonItem]!
  
  init(eventID: Int) {
    
    self.eventID = eventID
    super.init(nibName: nil, bundle: nil)
    
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  @objc func backPressed(){
    navigationController?.popViewController(animated: true)
  }
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    customBackButton = CustomBackButton.createWithText(text: "", color: .black, target: self, action: #selector(backPressed))
    
    navigationItem.leftBarButtonItems = customBackButton
    
    tableView.bounces = false
    tableView.allowsSelection = false
    tableView.separatorStyle = .none
    tableView.estimatedRowHeight = 100
    
    if #available(iOS 11.0, *) {
      tableView.contentInsetAdjustmentBehavior = .never
    } else {
      automaticallyAdjustsScrollViewInsets = false
    }
    
    navigationController?.navigationBar.shadowImage = UIImage()
    navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
    
    view.addSubview(tableView)
    tableView.translatesAutoresizingMaskIntoConstraints = false
    
    
    NSLayoutConstraint.activate([tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                                 tableView.topAnchor.constraint(equalTo: topLayoutGuide.topAnchor),
                                 tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                                 tableView.bottomAnchor.constraint(equalTo: bottomLayoutGuide.bottomAnchor)])
    
    tableView.dataSource = self
    tableView.delegate = self
    
    tableView.register(UINib(nibName: "YearEventTextCell", bundle: nil), forCellReuseIdentifier: "YearEventTextCell")
    tableView.register(UINib(nibName: "YearEventImageCell", bundle: nil), forCellReuseIdentifier: "YearEventImageCell")
    tableView.register(UINib(nibName: "YearEventCategoryCell", bundle: nil), forCellReuseIdentifier: "YearEventCategoryCell")
    tableView.register(UINib(nibName: "YearEventPreviewCell", bundle: nil), forCellReuseIdentifier: "YearEventPreviewCell")
    
    Networking.getYearEvent(with: eventID) { [weak self] (status, event) in
      
      switch status {
      case .success:
        self?.event = event
        self?.tableView.reloadData()
      case .fail(let errorMessage):
        self?.present(UIAlertController.createWith(type: AlertType.error, message: errorMessage), animated: true, completion: nil)
      }
      
    }
    
    
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    navigationController?.navigationBar.tintColor = UIColor.white
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    navigationController?.navigationBar.shadowImage = nil
    navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
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
  deinit {
    print("\(self) dealloc")
  }
}

extension YearEventVC: UITableViewDataSource, UITableViewDelegate {
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return 2
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    switch section {
    case 0:
      if event == nil {
        return 0
      } else {
        return 1
      }
    default:
      if event == nil {
        return 0
      } else {
        return event!.media.count
      }
    }
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    
    guard event != nil else {
      return 0
    }
    
    if indexPath.section == 0 {
      
      return UIScreen.main.bounds.width * 0.5625
      
    } else {
      
      let cellMedia = event!.media[indexPath.row]
      
      switch cellMedia.type {
      case .category:
        return 70
      case .image:
        return UIScreen.main.bounds.width * 0.5 + 24
      case .text:
        return UITableViewAutomaticDimension
      default:
        return 0
      }
      
      
    }
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    switch indexPath.section {
      
    case 0:
      
      let cell = tableView.dequeueReusableCell(withIdentifier: "YearEventPreviewCell", for: indexPath) as! YearEventPreviewCell
      cell.configureWith(event!)
      return cell
      
    case 1:
      
      let cellMedia = event!.media[indexPath.row]
      
      switch cellMedia.type {
        
      case .category:
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "YearEventCategoryCell", for: indexPath) as! YearEventCategoryCell
        cell.categoryLabel.text = cellMedia.content
        return cell
        
      case .image:
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "YearEventImageCell", for: indexPath) as! YearEventImageCell
        cell.yearEventImage.sd_setImage(with: URL(string: cellMedia.content)!, completed: nil)
        return cell
        
      case .text:
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "YearEventTextCell", for: indexPath) as! YearEventTextCell
        cell.textlabel.text = cellMedia.content
        return cell
        
      default:
        return UITableViewCell()
        
      }
      
    default:
      return UITableViewCell()
      
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
  
}

