//
//  TimelineViewModel.swift
//  newsapp
//
//  Created by Alexey Savchenko on 25.12.2017.
//  Copyright © 2017 Alexey Savchenko. All rights reserved.
//

import Foundation
import Alamofire

class ArticleListViewModel: ArticleListViewModelType {
  
  required init(with loadService: ContentLoaderService, contentBuilder: NewsContentBuider) {
    self.contentLoader = loadService
    self.contentBuilder = contentBuilder
  }
  
  private let contentBuilder: NewsContentBuider
  private let contentLoader: ContentLoaderService
  
  private var currentPage = 1
  private var totalPages = 1
  
  var shouldMoveToNextPage: Bool {
    return currentPage < totalPages
  }
  
  private var currentRequest: DataRequest?
  
  private var news = [ArticlePreview]() {
    didSet {
      didLoadNews?()
    }
  }
  
  var didLoadNews: (() -> ())?
  var didFailLoading: ((String) -> ())?
  
  var isLoading = false
  
  func loadArticles() {
    
    isLoading = true
    
    currentRequest = contentLoader.load(content: contentBuilder.buildContentFor(currentPage),
                                        completion: { [weak self] requestResult in
                                          
                                          switch requestResult {
                                            
                                          case let .success(newsPackage):
                                            
                                            self?.news.append(contentsOf: newsPackage.news)
                                            self?.totalPages = newsPackage.totalAvailablePages
                                            self?.isLoading = false
                                          case .failure(let error):
                                            self?.didFailLoading?(error ?? "Corrupted response.")
                                            self?.isLoading = false
                                          }
                                          
    })
    
  }
  
  func articleForItemAt(_ indexPath: IndexPath) -> ArticlePreview {
    return news[indexPath.row]
  }
  
  func numberOfArticles() -> Int {
    return news.count
  }
  
  func moveToNextPage() {
    guard !isLoading else {
      return
    }
    
    currentPage += 1
    loadArticles()
  }
 
  func moveToFirstPage() {
    guard !isLoading else {
      return
    }
    
    currentPage = 1
    news = []
    loadArticles()
  }
  
  
  func markAsReadArticleWithID(_ ID: Int) {
    
    let articleReadIDArray = UserDefaults.standard.readIDArray
    
    if !articleReadIDArray.contains(ID) {
      
      var newArticleReadIDArray = articleReadIDArray
      
      newArticleReadIDArray.append(ID)
      
      UserDefaults.standard.readIDArray = newArticleReadIDArray
      
      if let targetArticleIndex = news.index(where: { $0.id == ID } ) {
        
        var articlePreview = news[targetArticleIndex]
        
        articlePreview.isRead = true
        
        news.replace(with: articlePreview, at: targetArticleIndex)
        
      }
    }
  }
  
  deinit {
    print("\(self) dealloc")
  }
  
}
