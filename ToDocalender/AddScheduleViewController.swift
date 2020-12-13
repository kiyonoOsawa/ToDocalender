//
//  AddScheduleViewController.swift
//  ToDocalender
//
//  Created by 大澤清乃 on 2020/06/07.
//  Copyright © 2020 大澤清乃. All rights reserved.
//

import UIKit
import RealmSwift

class AddScheduleViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet var table: UITableView!
    
    var TODO:[String] = []
    var imageNumList:[Int] = []
    let ud = UserDefaults.standard
    var saveTitle: String = ""
    var hearderVisible = true
    var pickerView: UIPickerView = UIPickerView()
    let list = ["", "ヘルスケア", "仕事", "食事", "買い物", "勉強", "スポーツ", "デイリー", "休憩", "連絡", "その他"]
    let imageList = ["", "helth", "work", "eat", "shop", "study", "exercise", "daily", "break", "phone", "other"]
    var categoryTextField = UITextField()
    var selectedNum = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pickerView.delegate = self
        pickerView.dataSource = self
        pickerView.showsSelectionIndicator = true
        
        // tableviewのデータソースメゾットはviewcontorollerクラスに書く
        table.dataSource = self
        table.delegate = self
        if self.ud.object(forKey: "category") != nil {
            TODO = self.ud.object(forKey: "category") as! [String]
            imageNumList = self.ud.object(forKey: "imageNum") as! [Int]
        }
    }
    
    // セルの編集許可
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    // スワイプしたセルを削除
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
            self.TODO.remove(at: indexPath.row)
            self.imageNumList.remove(at: indexPath.row)
            self.ud.set(self.TODO, forKey: "category")
            self.ud.set(self.imageNumList, forKey: "imageNum")
            self.table.reloadData()
        }
        delete.backgroundColor = UIColor(red: 255 / 255, green: 118 / 255, blue: 133 / 255, alpha: 1)
        return [delete]
    }
    
    // セルの数を設定
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return TODO.count
    }
    
    // ID付きのセルを取得してセル付属のtextLabelに表示させる
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
        let imageView = cell?.viewWithTag(1) as! UIImageView
        let titleLabel = cell?.viewWithTag(2) as! UILabel
        titleLabel.text = TODO[indexPath.row]
        // textcolorを変える
        titleLabel.textColor = #colorLiteral (red: 67/255, green: 67/255, blue: 67/255, alpha: 1.0)
        // textsizeとfontを変える
        titleLabel.font = UIFont(name: "HiraginoSans-W3", size: 17)
        imageView.image = UIImage(named: imageList[imageNumList[indexPath.row]])
        // scellの選択不可にする
        cell?.selectionStyle = .none
        return cell!
    }
    
    @objc func addCategory() {
        // アラートコントローラー
        let alert = UIAlertController(title: "新規カテゴリ", message: "", preferredStyle: .alert)
        var textField = UITextField()
        // OKボタンを生成
        let okAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction) in
            // ここでuserdefaultsに保存
            self.TODO.append(textField.text!)
            self.imageNumList.append(self.selectedNum)
            self.ud.set(self.TODO, forKey: "category")
            self.ud.set(self.imageNumList, forKey: "imageNum")
            self.table.reloadData()
        }
        // OKボタンを追加
        alert.addAction(okAction)
        // Cancelボタンを生成
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        // Cancelボタンを追加
        alert.addAction(cancelAction)
        // TextFieldを２つ追加
        alert.addTextField { (text: UITextField!) in
            text.placeholder = "カテゴリを選択してください"
            // １つ目のtextFieldのタグ
            let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 0, height: 45))
            let doneItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(self.done))
            let cancelItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(self.cancel))
            toolbar.setItems([cancelItem, doneItem], animated: true)
            
            text.inputView = self.pickerView
            text.inputAccessoryView = toolbar
            self.categoryTextField = text
        }
        alert.addTextField { (text: UITextField!) in
            text.placeholder = "テキストを入力してください"
            textField = text
        }
        alert.view.tintColor = .black
        // アラートを表示
        present(alert, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("\(indexPath.row)番目の行が選択されました。")
        saveTitle = TODO[indexPath.row]
        selectedNum = imageNumList[indexPath.row]
        let alert: UIAlertController = UIAlertController(title: "記録しますか？", message: "カレンダーに表示されます。", preferredStyle: UIAlertController.Style.actionSheet)
        
        let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler:{
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
        alert.view.tintColor = .black
        present(alert, animated: true, completion: nil)
        
        alert.popoverPresentationController?.sourceView = self.view
        let screenSize = UIScreen.main.bounds
        // ここで表示位置を調整
        // xは画面中央、yは画面下部になる様に指定
        alert.popoverPresentationController?.sourceRect = CGRect(x: screenSize.size.width/2, y: screenSize.size.height, width: 0, height: 0)
        
    }
    
    func saveData() {
        // 入力値をセット
        let item:Item = Item()
        item.title = self.saveTitle
        item.categoryNum = self.selectedNum
        
        // 保存
        let realm = try! Realm()
        try! realm.write {
            realm.add(item)
            // アラート
            let savealert: UIAlertController = UIAlertController(title: "保存しました。", message: "", preferredStyle: .alert)
            savealert.view.tintColor = .black
            // 表示させる
            present(savealert, animated: true, completion: nil)
            // 三秒だけ表示
            // アラートを閉じる
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4, execute: {
                savealert.dismiss(animated: true, completion: nil)
            })
        }
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
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return list.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return list[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.categoryTextField.text = list[row]
        selectedNum = row
    }
    
    @objc func cancel() {
        self.categoryTextField.text = ""
        self.categoryTextField.endEditing(true)
    }
    
    @objc func done() {
        print(selectedNum)
        self.categoryTextField.endEditing(true)
    }
    
}


