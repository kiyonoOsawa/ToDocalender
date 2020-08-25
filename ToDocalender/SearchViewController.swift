//
//  SearchViewController.swift
//  ToDocalender
//
//  Created by 大澤清乃 on 2020/08/23.
//  Copyright © 2020 大澤清乃. All rights reserved.
//

import UIKit
import RealmSwift

class SearchViewController: UIViewController, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource {
    // TODOを取得する
    var TODO: Array<String> = []
    var saveTitle: String = ""
    // SearchBarインスタンス
    var mySearchBar: UISearchBar!
    // tableviewインスタンス
    var myTableView: UITableView!
    // tableviewに表示する配列
    var items: Array<String> = []
    // 検索結果が入る配列
    var searchResult: Array<String> = []
    // searchbarの高さ
    var searchBarHeight: CGFloat = 44
    // SafeAreaの高さ
    var topSafeAreaHeight: CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        view.backgroundColor = .white
        // tableviewに表示させる配列
        // 「CONTAINS」演算子　「TODO」を含むデータを検索
        let realm = try! Realm()
        let result = realm.objects(Item.self).filter("name CONTAINS 'Item'")
        
        //navigationbar関連
        //タイトル、虫眼鏡ボタンの作成
        let myNavItems = UINavigationItem()
        myNavItems.title = "検索付きtableview"
        let rightNavBtn = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(rightBarBtnClicked(sender:)))
        rightNavBtn.action = #selector(rightBarBtnClicked(sender:))
        self.navigationItem.rightBarButtonItem = rightNavBtn
        
        // SearchBar関連
        // SearchBarの作成
        mySearchBar = UISearchBar()
        // デリゲートを設定
        mySearchBar.delegate = self
        // 大きさの指定
        mySearchBar.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: searchBarHeight)
        // キャンセルボタンの追加
        mySearchBar.showsCancelButton = true
        
        // tableview関連
        // tableviewの初期化
        myTableView = UITableView()
        // デリゲートの設定
        myTableView.delegate = self
        myTableView.dataSource = self
        // tableviewの大きさの設定
        myTableView.frame = view.frame
        // 先ほど作成したSearchBarを作成
        myTableView.tableHeaderView = mySearchBar
        // サーチバーの高さだけ初期位置を下げる
        myTableView.contentOffset = CGPoint(x: 0, y: searchBarHeight)
        
        // tableviewの設置
        myTableView.register(UITableViewCell.self, forCellReuseIdentifier: NSStringFromClass(UITableViewCell.self))
        view.addSubview(myTableView)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // viewDidLayoutSubviewsではSafeAreaの取得ができている
        topSafeAreaHeight = view.safeAreaInsets.top
        print(topSafeAreaHeight)
    }
    // NavigationBarの右の虫眼鏡が押されたら呼ばれる
    @objc func rightBarBtnClicked(sender: UIButton) {
        // 一瞬で切り替わると不自然なのでアニメーションを付与する
        UIView.animate(withDuration: 0.1, delay: 0.0, options: [.curveLinear], animations: {
            self.myTableView.contentOffset = CGPoint(x: 0, y: -self.topSafeAreaHeight)
        }, completion: nil)
    }
    // 渡された文字列を含む要素を検索し、tableviewを再表示する
    func searchItems(searchText: String) {
        // 要素を検索する
        if searchText != "" {
            searchResult = items.filter { item in
                return item.contains(searchText)
                } as Array
        }else{
            // 渡された文字列がからの場合は全てを表示
            searchResult = items
        }
        // tableviewを再読み込みする
        myTableView.reloadData()
    }
    // Search Bar Delegate Methods
    // テキストが変更される毎に呼ばれる
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // 検索する
        searchItems(searchText: searchText)
    }
    
    // キャンセルボタンが押されると呼ばれる
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        view.endEditing(true)
        searchResult = items
        // tableviewを再読み込みする
        myTableView.reloadData()
    }
    // searchボタンが押されると呼ばれる
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
        // 検索する
        searchItems(searchText: searchBar.text! as String)
    }
    // TableView Delegate Methods
    // テーブルビューのセルの数を設定する
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // テーブルビューのセルの数はmyItems配列の数とした
        return searchResult.count
    }
    // テーブルビューのセルの中身を設定する
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // myItems配列の中身をテキストにして登録した
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(UITableViewCell.self))! as UITableViewCell
        cell.textLabel?.text = self.searchResult[indexPath.row]
        return cell
    }
    // tableviewのcellが押されたら呼ばれる
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(searchResult[indexPath.row])
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
