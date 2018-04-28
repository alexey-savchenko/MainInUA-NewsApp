//
//  UserDefaults+ReadIDArray.swift
//  newsapp
//
//  Created by iosUser on 26.12.2017.
//  Copyright © 2017 Alexey Savchenko. All rights reserved.
//

import Foundation

extension UserDefaults {
  var readIDArray: [Int] {
    get {
      return UserDefaults.standard.array(forKey: "articleReadIDArray") as? [Int] ?? [Int]()
    }
    set(newValue) {
      UserDefaults.standard.set(newValue, forKey: "articleReadIDArray")
    }
  }
}
