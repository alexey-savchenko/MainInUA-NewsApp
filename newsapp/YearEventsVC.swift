//
//  YearEventsVC.swift
//  newsapp
//
//  Created by iosUser on 18.12.2017.
//  Copyright © 2017 Alexey Savchenko. All rights reserved.
//

import UIKit

class YearEventsVC: UIViewController {
  
  let yearEventsTV = UITableView()
  
  var events: [YearEventPreview]? = []
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    navigationItem.title = "Підсумки року"
    
    yearEventsTV.dataSource = self
    yearEventsTV.delegate = self
    yearEventsTV.tableFooterView = UIView(frame: .zero)
    yearEventsTV.separatorStyle = .none
    view.addSubview(yearEventsTV)
    
    yearEventsTV.translatesAutoresizingMaskIntoConstraints = false
    
    if #available(iOS 11.0, *) {
      let safeArea = view.safeAreaLayoutGuide
      
      NSLayoutConstraint.activate([yearEventsTV.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
                                   yearEventsTV.topAnchor.constraint(equalTo: safeArea.topAnchor),
                                   yearEventsTV.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
                                   yearEventsTV.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor)])
    } else {
      NSLayoutConstraint.activate([yearEventsTV.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                                   yearEventsTV.topAnchor.constraint(equalTo: topLayoutGuide.topAnchor),
                                   yearEventsTV.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                                   yearEventsTV.bottomAnchor.constraint(equalTo: bottomLayoutGuide.bottomAnchor)])
    }
    


    yearEventsTV.register(UINib(nibName: "YearEventPreviewCell", bundle: nil), forCellReuseIdentifier: "YearEventPreviewCell")
    
    Networking.getYearEvents { [weak self] (status, previews) in
      
      switch status {
      case .success:
        self?.events = previews
        self?.yearEventsTV.reloadData()
        
      case .fail(let errorMessage):
        self?.present(UIAlertController.createWith(type: AlertType.error, message: errorMessage), animated: true, completion: nil)
      }
      
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
  
   func selectedYearEventWithID(_ ID: Int) {
    navigationController?.pushViewController(YearEventVC(eventID: ID), animated: true)
  }
  
  deinit {
    print("\(self) dealloc")
  }
  
}


extension YearEventsVC: UITableViewDataSource, UITableViewDelegate {
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 200
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return events?.count ?? 0
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let cell = tableView.dequeueReusableCell(withIdentifier: "YearEventPreviewCell", for: indexPath) as! YearEventPreviewCell
    cell.selectionStyle = .none
    cell.configureWith(events![indexPath.row])
    return cell
    
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    selectedYearEventWithID(events![indexPath.row].ID)
  }
  
}
