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
        // textviewの装飾(角丸)
        memoTextView.layer.cornerRadius = 5
        memoTextView.layer.masksToBounds = true
        // label装飾
        // 枠線の幅
        self.textLabel.layer.borderWidth = 0.05
        // 枠線の色
        self.textLabel.layer.borderColor = UIColor.gray.cgColor
        //
        self.textLabel.layer.cornerRadius = 5
        self.textLabel.clipsToBounds = true
        //角丸装飾
        SaveButton.layer.cornerRadius = 5
        //textlabelにtodoのタイトルを代入する。
        textLabel.text = todo.title
        memoTextView.text = todo.memo
        // Do any additional setup after loading the view.
    }
    @IBAction func saveMemo() {
        //保存の処理
        let realm = try! Realm()
        try! realm.write {
            todo.memo = memoTextView.text
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
