//
//  TimelineViewmodelFailTest.swift
//  newsappTests
//
//  Created by Alexey Savchenko on 25.12.2017.
//  Copyright © 2017 Alexey Savchenko. All rights reserved.
//

import XCTest

class TimelineViewmodelFailTest: XCTestCase {
  
  override func setUp() {
    super.setUp()
    // Put setup code here. This method is called before the invocation of each test method in the class.
  }
  
  override func tearDown() {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    super.tearDown()
  }
  
  func testExample() {
    
//    var vm: ArticleListViewModelType = TimelineViewModel(with: MockContentLoader.FailureLoader())
    let vm  = ArticleListViewModel(with: MockContentLoader.FailureLoader(), contentBuilder: ContentBuilder(api: .timeline(page: 1)))
    
    let expect = XCTestExpectation(description: "fail download")
    
    vm.didFailLoading = { message in
      XCTAssert(message == "Corrupted response.")
      expect.fulfill()
    }
    
    vm.loadArticles()
    
    wait(for: [expect], timeout: 20)
    
  }
  
  func testPerformanceExample() {
    // This is an example of a performance test case.
    self.measure {
      // Put the code you want to measure the time of here.
    }
  }
  
}
