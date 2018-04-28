//
//  UIImage+Color.swift
//  newsapp
//
//  Created by Alexey Savchenko on 14.08.17.
//  Copyright © 2017 Alexey Savchenko. All rights reserved.
//

import Foundation
import UIKit


extension UIImage {

  static func from(color: UIColor, size: CGSize) -> UIImage {
    let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
    UIGraphicsBeginImageContext(rect.size)
    if let context = UIGraphicsGetCurrentContext() {
      context.setFillColor(color.cgColor)
      context.fill(rect)
      let img = UIGraphicsGetImageFromCurrentImageContext()
      UIGraphicsEndImageContext()
      return img!

    } else {
      return UIImage()
    }
  }

  static func imageWithGradient(img:UIImage!) -> UIImage {

    UIGraphicsBeginImageContext(img.size)
    let context = UIGraphicsGetCurrentContext()

    img.draw(at: CGPoint(x: 0, y: 0))

    let colorSpace = CGColorSpaceCreateDeviceRGB()
    let locations:[CGFloat] = [0.0, 0.5, 1.0]

    let bottom = UIColor(red: 0, green: 0, blue: 0, alpha: 0).cgColor
    let middle = UIColor(red: 0, green: 0, blue: 0, alpha: 0).cgColor
    let top = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5).cgColor

    let colors = [top, middle, bottom] as CFArray

    let gradient = CGGradient(colorsSpace: colorSpace, colors: colors, locations: locations)

    let startPoint = CGPoint(x: img.size.width/2, y: 0)
    let endPoint = CGPoint(x: img.size.width/2, y: img.size.height)

    context!.drawLinearGradient(gradient!, start: startPoint, end: endPoint, options: CGGradientDrawingOptions(rawValue: UInt32(0)))

    let image = UIGraphicsGetImageFromCurrentImageContext()

    UIGraphicsEndImageContext()
    
    return image!
  }
}
