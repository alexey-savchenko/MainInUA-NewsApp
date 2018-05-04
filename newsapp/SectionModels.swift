//
//  SectionModels.swift
//  newsapp
//
//  Created by Alexey Savchenko on 04.05.2018.
//  Copyright © 2018 Alexey Savchenko. All rights reserved.
//

import Foundation
import RxDataSources

enum MultipleSectionModel: SectionModelType {
  typealias Item = SectionItem

  case headerImageSection(item: SectionItem)
  case titleSection(item: SectionItem)
  case mediaSection(items: [SectionItem])
  case tagsSection(tags: SectionItem)


  var items: [SectionItem] {
    switch self {
    case .headerImageSection(let item):
      return [item]
    case .titleSection(let item):
      return [item]
    case .mediaSection(let items):
      return items
    case .tagsSection(let tags):
      return [tags]
    }
  }

  init(original: MultipleSectionModel, items: [SectionItem]) {
    switch original {
    case .headerImageSection(let item):
      self = .headerImageSection(item: item)
    case .mediaSection(let items):
      self = .mediaSection(items: items)
    case .tagsSection(let tags):
      self = .tagsSection(tags: tags)
    case .titleSection(let item):
      self = .titleSection(item: item)
    }
  }
}

enum SectionItem {
  case headerImageSectionItem(imgURL: URL, copyright: String)
  case titleSectionItem(title: String, timestamp: String, category: String)
  case mediaSectionItem(media: Media)
  case tagsSectionItem(tags: [String])
}
