//
//  TabViewController.swift
//  ToDocalender
//
//  Created by 大澤清乃 on 2020/08/25.
//  Copyright © 2020 大澤清乃. All rights reserved.
//

import UIKit

class TabViewController: UIViewController {
    
    var selectedIndex: Int = 0
    var previousIndex: Int = 0
    
    var viewConrtollers = [UIViewController] ()
    var titleList = ["Calendar","Add","Search"]
    
    @IBOutlet var buttons: [UIButton]!
    @IBOutlet var tabView: UIView!
    var footerHeight: CGFloat = 50
    
    static let calendarVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier:"CalendarViewController")
    static let addVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddScheduleViewController") as!AddScheduleViewController
    static let searchCV = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SearchViewController")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        viewConrtollers.append(TabViewController.calendarVC)
        viewConrtollers.append(TabViewController.addVC)
        viewConrtollers.append(TabViewController.searchCV)
        
        buttons[selectedIndex].isSelected = true
        tabChanged(sender:buttons[selectedIndex])
        tabView.layer.cornerRadius = 30
        tabView.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        tabView.layer.shadowColor = UIColor.gray.cgColor
        tabView.layer.shadowOpacity = 0.6
        tabView.layer.shadowRadius = 4
    }
    
}

//MARK:-Actions
extension TabViewController {
    
    @IBAction func tabChanged(sender:UIButton){
        previousIndex = selectedIndex
        selectedIndex = sender.tag
        
        if selectedIndex == 0 {
            buttons[0].setBackgroundImage(UIImage(named: "home_selected"), for: .normal)
            buttons[1].setBackgroundImage(UIImage(named: "add"), for: .normal)
            buttons[2].setBackgroundImage(UIImage(named: "search"), for: .normal)
        } else if selectedIndex == 1 {
            buttons[0].setBackgroundImage(UIImage(named: "home"), for: .normal)
            buttons[1].setBackgroundImage(UIImage(named: "add_selected"), for: .normal)
            buttons[2].setBackgroundImage(UIImage(named: "search"), for: .normal)
        } else {
            buttons[0].setBackgroundImage(UIImage(named: "home"), for: .normal)
            buttons[1].setBackgroundImage(UIImage(named: "add"), for: .normal)
            buttons[2].setBackgroundImage(UIImage(named: "search_selected"), for: .normal)
        }
        
        buttons[previousIndex].isSelected = false
        let previousVC = viewConrtollers[previousIndex]
        
        previousVC.willMove(toParent: nil)
        previousVC.view.removeFromSuperview()
        previousVC.removeFromParent()
        
        sender.isSelected = true
        
        let vc = viewConrtollers[selectedIndex]
        vc.view.frame = UIApplication.shared.windows[0].frame
        vc.didMove(toParent: self)
        self.addChild(vc)
        self.view.addSubview(vc.view)
        self.navigationItem.title = titleList[selectedIndex]
        if selectedIndex == 1 {
            let addBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add,target: self,action:#selector(addCategory))
            addBarButtonItem.tintColor = .white
            self.navigationItem.rightBarButtonItems = [addBarButtonItem]
        } else {
            self.navigationItem.rightBarButtonItems?.removeAll()
        }
        self.view.bringSubviewToFront(tabView)
        
    }
    
    func hideHeader() {
        UIView.animate(withDuration: 1.0, delay: 0, options: .curveLinear, animations:{
            self.tabView.alpha = 0
        })
    }
    
    func showHeader() {
        UIView.animate(withDuration: 1.0, delay: 0, options: .curveLinear,animations: {
            self.tabView.alpha = 1
        })
    }
    
    @objc func addCategory() {
        TabViewController.addVC.addCategory()
    }
    
}
