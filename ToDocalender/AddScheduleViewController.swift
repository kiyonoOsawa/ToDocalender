//
//  AddScheduleViewController.swift
//  ToDocalender
//
//  Created by 大澤清乃 on 2020/06/07.
//  Copyright © 2020 大澤清乃. All rights reserved.
//

import UIKit
import RealmSwift

class AddScheduleViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet var table: UITableView!
    
    //@IBOutlet var textField: UITextField!
    
    //var pickerView: UIPickerView = UIPickerView()
    //let list = ["","1","2","3","4"]
    var TODO:[String] = []
    let ud = UserDefaults.standard
    var saveTitle: String = ""
    
    //@IBOutlet var circleButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
      //tableviewのデータソースメゾットはviewcontorollerクラスに書く
        table.dataSource = self
        table.delegate = self
        if self.ud.object(forKey: "category") != nil {
            TODO = self.ud.object(forKey: "category") as! [String]
        }
        //circleButton.layer.cornerRadius = 5
    
        // ピッカー設定
        //pickerView.delegate = self
        //pickerView.dataSource = self
        //pickerView.showsSelectionIndicator = true
        // 決定バーの生成
//        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 35))
//        let spacelItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
//        let doneItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
//        toolbar.setItems([spacelItem, doneItem], animated: true)
//        // インプットビュー設定
//        textField.inputView = pickerView
//        textField.inputAccessoryView = toolbar
    }
    // 決定ボタン押下
//    @objc func done() {
//        textField.endEditing(true)
//        textField.text = "\(list[pickerView.selectedRow(inComponent: 0)])"
//    }
//    // ドラムロールの列数
//    func numberOfComponents(in pickerView: UIPickerView) -> Int {
//        return 1
//    }
//    // ドラムロールの行数
//    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
//        /*
//         列が複数ある場合は
//         if component == 0 {
//         } else {
//         ...
//         }
//         こんな感じで分岐が可能
//         */
//        return list.count
//    }
//    // ドラムロールの各タイトル
//    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
//        /*
//         列が複数ある場合は
//         if component == 0 {
//         } else {
//         ...
//         }
//         こんな感じで分岐が可能
//         */
//        return list[row]
//    }
    
    //セルの数を設定
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return TODO.count
    }
    //ID付きのセルを取得してセル付属のtextLabelに「テスト」と表示する
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
        
        cell?.textLabel?.text = TODO[indexPath.row]
        
        return cell!
    }
    
    
    @IBAction func addCategory(_ sender: Any) {
        
        //アラートコントローラー
        let alert = UIAlertController(title: "新規カテゴリ", message: "", preferredStyle: .alert)
        var textField = UITextField()
        //OKボタンを生成
        let okAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction) in
            //複数のtextFieldのテキストを格納
            //guard let textFields:[UITextField] = alert.textFields else {return}
            //ここでuserdefaultsに保存
            self.TODO.append(textField.text!)
            self.ud.set(self.TODO, forKey: "category")
            self.table.reloadData()
        }
        //OKボタンを追加
        alert.addAction(okAction)
        
        //Cancelボタンを生成
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        //Cancelボタンを追加
        alert.addAction(cancelAction)
        
        //TextFieldを２つ追加
        alert.addTextField { (text: UITextField!) in
            text.placeholder = "テキストを入力してください"
            //１つ目のtextFieldのタグ
            textField = text
        }
        
        //アラートを表示
        present(alert, animated: true, completion: nil)

    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("\(indexPath.row)番目の行が選択されました。")
        saveTitle = TODO[indexPath.row]
        let alert: UIAlertController = UIAlertController(title: "アラート表示", message: "記録しますか？", preferredStyle: UIAlertController.Style.actionSheet)
            
            let defaultAction: UIAlertAction = UIAlertAction(title: "OK?", style: UIAlertAction.Style.default, handler:{
                (action: UIAlertAction!) -> Void in
                print("OK")
                
                self.saveData()
        })
            let cancelAction: UIAlertAction = UIAlertAction(title: "キャンセル", style: UIAlertAction.Style.cancel, handler:{
                (action: UIAlertAction!) -> Void in
                print("cancel")
        })
            alert.addAction(cancelAction)
            alert.addAction(defaultAction)
            
            present(alert, animated: true, completion: nil)
    }
    
    func saveData() {
        // 入力値をセット
        let item:Item = Item()
        item.title = self.saveTitle

        // 保存
        let realm = try! Realm()
        try! realm.write {
            realm.add(item)
        }
    }
    
    
    // Do any additional setup after loading the view.

// Do any additional setup after loading the view.
/*
 // MARK: - Navigation
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
 // Get the new view controller using segue.destination.
 // Pass the selected object to the new view controller.
 }
 */
   

        // Do any additional setup after loading the view.
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */


}
