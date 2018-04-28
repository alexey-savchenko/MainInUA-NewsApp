//
//  CustomAlert.swift
//  newsapp
//
//  Created by Alexey Savchenko on 20.09.17.
//  Copyright © 2017 Alexey Savchenko. All rights reserved.
//

import Foundation
import UIKit

enum AlertType: String {
  case warning = "Warning"
  case error = "Error"
}

extension UIAlertController {

  static func createWith(type: AlertType, message: String) -> UIAlertController {

    let vc = UIAlertController(title: type.rawValue, message: message, preferredStyle: .alert)
    vc.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))

    return vc

  }

}

