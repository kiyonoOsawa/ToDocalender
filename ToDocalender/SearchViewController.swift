//
//  SearchViewController.swift
//  ToDocalender
//
//  Created by 大澤清乃 on 2020/08/23.
//  Copyright © 2020 大澤清乃. All rights reserved.
//

import UIKit
import RealmSwift

class SearchViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate{
    
    @IBOutlet var table:UITableView!
    @IBOutlet var searchBar: UISearchBar!
    
    var searchText = ""
    var TODO: Array<Item> = []
    var items: Results<Item>!
    var headerVisible = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
        table.delegate = self
        table.dataSource = self
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
        table.dataSource = self
        let realm = try! Realm()
        TODO = Array(realm.objects(Item.self).sorted(byKeyPath: "date", ascending: false))
        table.reloadData()
    }
    
    // セルの数を設定
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let realm = try! Realm()
        if searchText != "" && searchText != nil {
            // 検索ワードでitemsを取得
            items = realm.objects(Item.self).filter("title CONTAINS %@",searchText).sorted(byKeyPath: "date", ascending: false)
        } else {
            // 検索ワードがないので全部取得
            items = realm.objects(Item.self).sorted(byKeyPath: "date", ascending: false)
        }
        return items.count
    }
    
    // セルの表示
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView .dequeueReusableCell(withIdentifier: "Cell")
        let dateLabel = cell?.viewWithTag(1) as! UILabel
        let titleLabel = cell?.viewWithTag(2) as! UILabel
        let timeLabel = cell?.viewWithTag(3) as! UILabel
        
        // デフォルトRealmを取得
        let realm = try! Realm()
        // tappedDateStringに一致するitemを取得
        if searchText != "" {
            // 検索ワードでitemsを取得
            items = realm.objects(Item.self).filter("title CONTAINS %@",searchText).sorted(byKeyPath: "date", ascending: false)
        } else {
            // 検索ワードがないので全部取得
            items = realm.objects(Item.self).sorted(byKeyPath: "date", ascending: false)
        }
        
        print(items)
        
        dateLabel.text = items[indexPath.row].dateString
        titleLabel.text = items[indexPath.row].title
        timeLabel.text = items[indexPath.row].timeString!
        
        return cell!
    }
    
    //キャンセルボタンを表示
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar){
        searchBar.setShowsCancelButton(true, animated: true)
    }
    
    // キャンセルボタンでキャセルボタン非表示
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        searchBar.setShowsCancelButton(false, animated: true)
        //        let realm = try! Realm()
        //        items = realm.objects(Item.self).sorted(byKeyPath: "date", ascending: false)
        //        table.reloadData()
        searchText = ""
        table.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        searchBar.setShowsCancelButton(false, animated: true)
        if let text = searchBar.text {
            searchText = text
            print(searchText)
            table.reloadData()
        }
    }
    
}

extension SearchViewController {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let translation = scrollView.panGestureRecognizer.translation(in: scrollView.superview)
        performHeaderCheck(translation: translation)
    }
    
    func performHeaderCheck(translation:CGPoint) {
        if translation.y == 0 { return }
        if translation.y > 0 {
            // Scroll Down
            if !headerVisible {
                showHeader()
            }
        } else {
            // Scroll Up
            if headerVisible {
                hideHeader()
            }
        }
    }
    
    func hideHeader() {
        self.headerVisible = false
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveLinear, animations: {
            let parent = self.parent as! TabViewController
            parent.hideHeader()
        })
    }
    
    func showHeader() {
        self.headerVisible = true
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveLinear, animations: {
            let parent = self.parent as! TabViewController
            parent.showHeader()
        })
    }
    
}


