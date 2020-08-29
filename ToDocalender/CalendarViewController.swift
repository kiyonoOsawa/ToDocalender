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

class CalendarViewController: UIViewController, UITableViewDataSource,UITableViewDelegate, FSCalendarDataSource, FSCalendarDelegate {
    
    //storyboardで扱うTableViewを宣言
    @IBOutlet var table:UITableView!
    @IBOutlet weak var calendar: FSCalendar!
    var tappedDateString = DateUtils.stringFromDate(date: Date(), format: "yyyy/MM/dd")
    var TODO: Array<Item> = []
    var hearderVisible = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        table.delegate = self
        
        // Do any additional setup after loading the view.
        
        //tableViewのデータソースメゾットはControllerクラスに書くよという設定
//        table.dataSource = self
//        calendar.dataSource = self
//        calendar.delegate = self
        
        // デフォルトRealmを取得
        //        let realm = try! Realm()
        // 一覧を取得：金額を条件に、登録日時が新しい順でソート
        //TODO = Array(realm.objects(Item.self).sorted(byKeyPath: "date", ascending: false))
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // タップされたcellの行番号を出力
        print("\(indexPath.row)番目の行が選択されました。")
        // 別の画面に遷移
        performSegue(withIdentifier: "toMemoViewController", sender: indexPath)
    }
    
    // 画面遷移が行われる時に呼ばれる
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toMemoViewController" {
            // inddxPathを宣言している。使えるようにする。
            let index = (sender as! IndexPath).row
            // 選択したTODOを取得
            let todo = TODO[index]
            // 次の画面を取得
            let nextVC = segue.destination as! MemoViewController
            nextVC.todo = todo
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // tableViewのデータソースメゾットはControllerクラスに書くよという設定
        table.dataSource = self
        calendar.dataSource = self
        calendar.delegate = self
        // デフォルトRealmを取得
        let realm = try! Realm()
         // 一覧を取得：金額を条件に、登録日時が新しい順でソート
        TODO = Array(realm.objects(Item.self).sorted(byKeyPath: "date", ascending: false))
        table.reloadData()
    }
    
    //セルの数を設定
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let realm = try! Realm()
        let items = realm.objects(Item.self).filter("dateString == %@", tappedDateString).sorted(byKeyPath: "date", ascending: false)
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
        let items = realm.objects(Item.self).filter("dateString == %@", tappedDateString).sorted(byKeyPath: "date", ascending: false)
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
    
    //セルの編集許可
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    //スワイプしたセルを削除
    func tableView(_ tableview: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCell.EditingStyle.delete {
            do{
                let realm = try! Realm()
                try realm.write {
                    realm.delete(self.TODO[indexPath.row])
                }
                tableview.deleteRows(at: [(indexPath as IndexPath)], with: UITableView.RowAnimation.fade)
            }catch{
            }
            table.reloadData()
            //            // スワイプして削除された時に呼ばれる
            //            TODO.remove(at: indexPath.row)
            //            // Realmのデータだから、Realmの削除の方法で行う
            //            tableview.deleteRows(at: [indexPath as IndexPath], with: UITableView.RowAnimation.automatic)
        }
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

extension CalendarViewController {

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let translation = scrollView.panGestureRecognizer.translation(in: scrollView.superview)
        performHeaderCheck(translation: translation)
    }
    func performHeaderCheck(translation: CGPoint) {
        if translation.y == 0 {return}
        if translation.y > 0 {
            // Scroll Down
            if !hearderVisible {
                showHeader()
            }
        } else {
            // Scroll Up
            if hearderVisible {
                hideHeader()
            }
        }
    }
    
    func hideHeader() {
        self.hearderVisible = false
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveLinear, animations: {
            let parent = self.parent as! TabViewController
            parent.hideHeader()
        })
    }
    func showHeader() {
        self.hearderVisible = true
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveLinear, animations: {
            let parent = self.parent as! TabViewController
            parent.showHeader()
        })
    }
}
