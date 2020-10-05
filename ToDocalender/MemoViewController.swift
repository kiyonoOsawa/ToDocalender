//
//  MemoViewController.swift
//  ToDocalender
//
//  Created by 大澤清乃 on 2020/08/09.
//  Copyright © 2020 大澤清乃. All rights reserved.
//

import UIKit
import RealmSwift

class MemoViewController: UIViewController {
    
    @IBOutlet var memoTextView: UITextView!
    @IBOutlet var SaveButton: UIButton!
    @IBOutlet var textLabel: UILabel!
    
    var todo: Item!
    var TODO: Array<Item> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // textview
        // 装飾(角丸)
        memoTextView.layer.cornerRadius = 2
        memoTextView.layer.masksToBounds = true
        // 枠のカラー
        memoTextView.layer.borderColor = UIColor.lightGray.cgColor
        // 枠線の幅
        memoTextView.layer.borderWidth = 0.3
        //textlabelにtodoのタイトルを代入する。
        textLabel.text = todo.title
        memoTextView.text = todo.memo
    }
    
    @IBAction func saveMemo() {
        //保存の処理
        let realm = try! Realm()
        try! realm.write {
            todo.memo = memoTextView.text
            // アラート
            let alert: UIAlertController = UIAlertController(title: "保存完了", message: "", preferredStyle: .alert)
            // 表示させる
            alert.view.tintColor = .black
            present(alert, animated: true, completion: nil)
            // 三秒だけ表示
            // アラートを閉じる
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4, execute: {
                alert.dismiss(animated: true, completion: nil)
            })
        }
    }
    
}
