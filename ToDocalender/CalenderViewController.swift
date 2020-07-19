//
//  CalenderViewController.swift
//  ToDocalender
//
//  Created by 大澤清乃 on 2020/06/07.
//  Copyright © 2020 大澤清乃. All rights reserved.
//

import UIKit
import RealmSwift

class CalenderViewController: UIViewController, UITableViewDataSource {
    
    //storyboardで扱うTableViewを宣言
    @IBOutlet var table:UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        //tableViewのデータソースメゾットはControllerクラスに書くよという設定
        table.dataSource = self
        
        // デフォルトRealmを取得
        let realm = try! Realm()
        // 一覧を取得：金額を条件に、登録日時が新しい順でソート
        let TODO = realm.objects(Item.self).sorted(byKeyPath: "date", ascending: false)
        
        }
    
    //セルの数を設定
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
        
    }
    
    //ID付きのエルを取得して、セル付属のtextLabelに「テスト」と表示させてみる
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView .dequeueReusableCell(withIdentifier: "Cell")
        
        cell?.textLabel?.text = "テスト"
        
        return cell!
        
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
