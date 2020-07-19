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
    //日付
    @objc dynamic var date: Date? = Date()

}
