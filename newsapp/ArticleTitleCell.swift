//
//  ArticleTitleCell.swift
//  newsapp
//
//  Created by Alexey Savchenko on 22.09.17.
//  Copyright © 2017 Alexey Savchenko. All rights reserved.
//

import UIKit

class ArticleTitleCell: UITableViewCell {

  override func awakeFromNib() {
    super.awakeFromNib()
    
  }

  @IBOutlet weak var titlelabel: UILabel!
  @IBOutlet weak var categoriesLabel: UILabel!
  @IBOutlet weak var TimestampLabel: UILabel!



  @IBAction func categoryTap(_ sender: UIButton) {
    NotificationCenter.default.post(name: NSNotification.Name.init("CategorySelected"), object: nil)
  }

}
