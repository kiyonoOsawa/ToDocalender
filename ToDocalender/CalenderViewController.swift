//
//  CalenderViewController.swift
//  ToDocalender
//
//  Created by 大澤清乃 on 2020/06/07.
//  Copyright © 2020 大澤清乃. All rights reserved.
//

import UIKit
import FSCalendar
import RealmSwift

class CalenderViewController: UIViewController, UITableViewDataSource, FSCalendarDataSource, FSCalendarDelegate {
    
    //storyboardで扱うTableViewを宣言
    @IBOutlet var table:UITableView!
    @IBOutlet weak var calendar: FSCalendar!
    var tappedDateString = DateUtils.stringFromDate(date: Date(), format: "yyyy/MM/dd")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        //tableViewのデータソースメゾットはControllerクラスに書くよという設定
        table.dataSource = self
        calendar.dataSource = self
        calendar.delegate = self
        
        // デフォルトRealmを取得
        let realm = try! Realm()
        // 一覧を取得：金額を条件に、登録日時が新しい順でソート
        let TODO = realm.objects(Item.self).sorted(byKeyPath: "date", ascending: false)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        table.reloadData()
    }
    
    //セルの数を設定
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let realm = try! Realm()
        let items = realm.objects(Item.self).filter("dateString == %@", tappedDateString)
        return items.count
    }
    
    //セルの表示
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView .dequeueReusableCell(withIdentifier: "Cell")
        let titleLabel = cell?.viewWithTag(1) as! UILabel
        let timeLabel = cell?.viewWithTag(2) as! UILabel
        
        //デフォルトRealmを取得
        let realm = try! Realm()
        //tappedDateStringに一致するitemを取得
        let items = realm.objects(Item.self).filter("dateString == %@", tappedDateString)
        print(items)
        
        titleLabel.text = items[indexPath.row].title
        timeLabel.text = items[indexPath.row].timeString!
        return cell!
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        tappedDateString = DateUtils.stringFromDate(date: date, format: "yyyy/MM/dd")
        print(tappedDateString)
        table.reloadData()
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
