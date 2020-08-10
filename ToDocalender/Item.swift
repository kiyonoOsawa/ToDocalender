//
//  Item.swift
//  ToDocalender
//
//  Created by 大澤清乃 on 2020/07/19.
//  Copyright © 2020 大澤清乃. All rights reserved.
//

import UIKit
import RealmSwift

class Item: Object {
    //タイトル
    @objc dynamic var title: String? = nil
    //String型の日付
    @objc dynamic var dateString: String? = DateUtils.stringFromDate(date: Date(), format: "yyyy/MM/dd")
    //String型の時間
    @objc dynamic var timeString: String? = DateUtils.stringFromDate(date: Date(), format: "HH:mm")
    //日付
    @objc dynamic var date: Date? = Date()
    
    // マイグレーション必要だった
    //メモ
    @objc dynamic var memo: String? = nil

}
