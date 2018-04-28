//
//  ArticleListPresentable.swift
//  newsapp
//
//  Created by Alexey Savchenko on 25.12.2017.
//  Copyright © 2017 Alexey Savchenko. All rights reserved.
//

import Foundation
import UIKit

protocol ArticleListPresentable {
  
  init(viewModel: ArticleListViewModelType)
  
  var viewModel: ArticleListViewModelType { get set }
  var feedTV: UITableView! { get set }
}
