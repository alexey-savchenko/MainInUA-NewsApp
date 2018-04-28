//
//  Date+String.swift
//  newsapp
//
//  Created by iosUser on 20.12.2017.
//  Copyright © 2017 Alexey Savchenko. All rights reserved.
//

import Foundation

extension Date {
  func toStringNotation() -> String {
    
    let dayTimePeriodFormatter = DateFormatter()
    dayTimePeriodFormatter.dateFormat = "dd.MM.YYYY HH:mm"
    dayTimePeriodFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone!
    
    let dateString = dayTimePeriodFormatter.string(from: self)
    
    return dateString
  }
}
