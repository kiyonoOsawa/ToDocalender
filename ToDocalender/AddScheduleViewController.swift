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
    var hearderVisible = true
    
    //@IBOutlet var circleButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //tableviewのデータソースメゾットはviewcontorollerクラスに書く
        table.dataSource = self
        table.delegate = self
        if self.ud.object(forKey: "category") != nil {
            TODO = self.ud.object(forKey: "category") as! [String]
        }
        
    }
    
    //セルの編集許可
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    //スワイプしたセルを削除
    func tableView(_ tableview: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCell.EditingStyle.delete {
            TODO.remove(at: indexPath.row)
            tableview.deleteRows(at: [indexPath as IndexPath], with: UITableView.RowAnimation.automatic)
            self.ud.set(self.TODO, forKey: "category")
        }
    }
    //セルの数を設定
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return TODO.count
    }
    //ID付きのセルを取得してセル付属のtextLabelに表示させる
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
        
        cell?.textLabel?.text = TODO[indexPath.row]
        // textcolorを変える
        cell?.textLabel?.textColor = #colorLiteral (red: 67/255, green: 67/255, blue: 67/255, alpha: 1.0)
        //#colorLiteral (red: 67/255, green: 67/255, blue: 67/255, alpha: 1.0)
        // textsizeとfontを変える
        cell?.textLabel?.font = UIFont(name: "HiraginoSans-W3", size: 17)
        
        return cell!
    }
    
    @objc func addCategory() {
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
            
            //アラート
            let savealert: UIAlertController = UIAlertController(title: "保存しました。", message: "", preferredStyle: .alert)
            // 表示させる
            present(savealert, animated: true, completion: nil)
            // 三秒だけ表示
            // アラートを閉じる
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4, execute: {
                savealert.dismiss(animated: true, completion: nil)
            })
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
    
}
extension AddScheduleViewController {

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


