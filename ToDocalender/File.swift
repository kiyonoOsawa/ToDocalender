//
//  File.swift
//  ToDocalender
//
//  Created by 大澤清乃 on 2020/07/28.
//  Copyright © 2020 大澤清乃. All rights reserved.
//

import UIKit
class DateUtils {
    class func dateFromString(string: String, format: String) -> Date {
        let formatter: DateFormatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.dateFormat = format
        return formatter.date(from: string)!
    }
    class func stringFromDate(date: Date, format: String) -> String {
        let formatter: DateFormatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.dateFormat = format
        return formatter.string(from: date)
    }
}
