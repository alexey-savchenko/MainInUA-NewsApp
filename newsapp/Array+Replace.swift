//
//  Array+Replace.swift
//  newsapp
//
//  Created by Alexey Savchenko on 09.10.2017.
//  Copyright © 2017 Alexey Savchenko. All rights reserved.
//

import Foundation

extension Array {
  mutating func replace(with item: Element, at position: Int){
    remove(at: position)
    insert(item, at: position)
  }
}
