//
//  ArticleTagsCell.swift
//  newsapp
//
//  Created by iosUser on 27.12.2017.
//  Copyright © 2017 Alexey Savchenko. All rights reserved.
//

import UIKit

class ArticleTagsCell: UITableViewCell {
  
  var collectionViewHeightConstraint: NSLayoutConstraint!
  
  var tags: [String] = [] {
    didSet {
      dataSourceWidths = tags.map { $0.size(withAttributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 16.0)]).width + 40 }
      collectionView.reloadData()
      collectionView.layoutIfNeeded()
      collectionViewHeightConstraint = collectionView.heightAnchor.constraint(equalToConstant: collectionView.contentSize.height)
      collectionViewHeightConstraint.isActive = true
    }
  }
  
  var tagSelectionAction: ((String)->())?
  
  var dataSourceWidths: [CGFloat] = []
  
  var collectionView: UICollectionView!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    
    selectionStyle = .none
    
    let layout = RFQuiltLayout()
    layout.blockPixels = CGSize(width: 1, height: 40)
    layout.direction = .vertical
    layout.delegate = self
    collectionView = UICollectionView(frame: contentView.frame, collectionViewLayout: layout)
    collectionView.isScrollEnabled = false
    collectionView.dataSource = self
    collectionView.backgroundColor = .white
    collectionView.delegate = self
    contentView.addSubview(collectionView)
    collectionView.translatesAutoresizingMaskIntoConstraints = false
    
    NSLayoutConstraint.activate([collectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
                                 collectionView.topAnchor.constraint(equalTo: contentView.topAnchor),
                                 collectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
                                 collectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)])
    
    collectionView.register(UINib(nibName: "ArticleTagCollectionViewCell", bundle: nil),
                            forCellWithReuseIdentifier: "ArticleTagCollectionViewCell")
    
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    
  }
  
}

extension ArticleTagsCell: UICollectionViewDataSource, UICollectionViewDelegate {
  
  func collectionView(_ collectionView: UICollectionView,
                      cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ArticleTagCollectionViewCell", for: indexPath) as! ArticleTagCollectionViewCell
    cell.tagLabel.text = tags[indexPath.row]
    return cell
    
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return tags.count
  }
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    collectionView.deselectItem(at: indexPath, animated: true)
    let tag = tags[indexPath.row]
    tagSelectionAction?(tag)
  }
  
}

extension ArticleTagsCell: RFQuiltLayoutDelegate {
  
  func collectionView(_ collectionView: UICollectionView!,
                      layout collectionViewLayout: UICollectionViewLayout!,
                      blockSizeForItemAt indexPath: IndexPath!) -> CGSize {
    
    return CGSize(width: dataSourceWidths[indexPath.row], height: 1)
  }
  
  func collectionView(_ collectionView: UICollectionView!,
                      layout collectionViewLayout: UICollectionViewLayout!,
                      insetsForItemAt indexPath: IndexPath!) -> UIEdgeInsets {
    
    return UIEdgeInsets(top: 8, left: 8, bottom: 0, right: 8)
  }
}


