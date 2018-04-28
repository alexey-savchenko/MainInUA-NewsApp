//
//  YearEventPreviewCell.swift
//  newsapp
//
//  Created by iosUser on 18.12.2017.
//  Copyright © 2017 Alexey Savchenko. All rights reserved.
//

import UIKit

class YearEventPreviewCell: UITableViewCell {
  
  @IBOutlet weak var backgroundImage: UIImageView!
  @IBOutlet weak var logoImage: UIImageView!
  @IBOutlet weak var nameLabel: UILabel!
  
  let gradientView = UIView()
  let gradientLayer = CAGradientLayer()

  override func awakeFromNib() {
    super.awakeFromNib()
    
    gradientView.layer.addSublayer(gradientLayer)
    contentView.addSubview(gradientView)
    
    contentView.insertSubview(gradientView, aboveSubview: backgroundImage)
    
    gradientLayer.locations = [0.0, 1.0]
    gradientLayer.colors = [UIColor.black.cgColor, UIColor.clear.cgColor]
    gradientLayer.opacity = 0.7
    gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
    gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
    
    
    separatorInset.left = 0
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    
    gradientView.frame = bounds
    gradientLayer.frame = gradientView.frame
    
  }
  
  func configureWith(_ preview: YearEventType){
    
    backgroundImage.sd_setImage(with: URL(string: preview.imageURLString)!, completed: nil)
    logoImage.sd_setImage(with: URL(string: preview.logoURLString)!, completed: nil)
    
    nameLabel.text = preview.name
    
  }
  
}
