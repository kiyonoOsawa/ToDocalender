//
//  AddScheduleViewController.swift
//  ToDocalender
//
//  Created by 大澤清乃 on 2020/06/07.
//  Copyright © 2020 大澤清乃. All rights reserved.
//

import UIKit

class AddScheduleViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet var textField: UITextField!
    
    var pickerView: UIPickerView = UIPickerView()
    let list = ["","1","2","3","4"]
    
    @IBOutlet var circleButton: UIButton!
    
    override func viewDidLoad() {
    super.viewDidLoad()
        
        circleButton.layer.cornerRadius = 5
        
        pickerView.delegate = self
        pickerView.dataSource = self
        pickerView.showsSelectionIndicator = true
        
        let toolbar = UIToolbar(frame: CGRectMake(0,0,0,35))
        let doneItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(ViewController.done))
        let cancelItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(ViewController.cancel))
        toolbar.setItems([cancelItem,doneItem],animated: true)
        
        self.textField.inputView = pickerView
        self.textField.inputAccessoryView = toolbar

    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent componet: Int) -> Int {
        return list.count
    }
   
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return list[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.textField.text = list[row]
    }
    
    func cancel() {
        self.textField.text = ""
        self.textField.endEditing(true)
    }
        
    func done() {
        self.textField.endEditing(true)
    }
    
    func CGRectMake(_ x: CGFloat, _ y: CGFloat, _ width: CGFloat, _ heifht: CGFloat) -> CGFloat {
        return CGRect(x: x, y: y, width: width, height: heifht)
    }
    
   
    
    override func didReceiveMemoryWarning() {
       super.didReceiveMemoryWarning()
    }
        // Do any additional setup after loading the view.
}
    
   

        // Do any additional setup after loading the view.
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */


