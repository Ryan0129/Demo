//
//  addVC.swift
//  App
//
//  Created by ucom Apple root S08 on 2019/6/28.
//  Copyright © 2019 yan r. All rights reserved.
//
import UIKit


class addVC: UIViewController,UIPickerViewDelegate,UIPickerViewDataSource,UITextFieldDelegate,UITextViewDelegate{
    
    weak var delegate : ViewController!
    var current : Count!
    var sid = -1
    
    var Years : Int!
    var Months : Int!
    var Days : Int!
    var currentYear : Int!
    var currentMonth : Int!
    var currentDay : Int!
    var kindText = ""
    var scortText = ""
    var kindStr = ""
    var sortStr = ""
    var date = ""
    var vcKind : String!
    var vcSort : String!
    var vcmoney : String!
    var zeroMonth = ""
    var zeroDay = ""
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var inputText: UITextField!
    @IBOutlet var kind: UILabel!
    @IBOutlet var scort: UILabel!
    @IBOutlet var fulfill: UIButton!
    @IBOutlet var complete: UIButton!
    @IBOutlet var labelText: UILabel!
    @IBOutlet var datePickerView: UIView!
    @IBOutlet var datePicker: UIDatePicker!
    @IBOutlet var pickerView: UIView!
    
    //    var mykind = ["支出","收入"]
    //    var mysort = ["飲食","日常用品","交通","油資"]
    var mykind : [String]!
    var mysort : [String:[String]]!
    
    //   @IBOutlet var addCount: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        inputText.delegate = self
        menu()
        labelText.text = "\(currentYear!)年 \(currentMonth!)月 \(currentDay!)日"
        if sid == -1 {
            titleLabel.text = "新增"
            current = Count()
        }else{
            print( "addVC 修改: \(sid)")
            titleLabel.text = "修改"
            current = CountDAO.getCountBySid(sid: sid)!
            inputText.text = vcmoney
            kind.text = vcKind
            scort.text = vcSort
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        inputText.becomeFirstResponder()
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        inputText.resignFirstResponder()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }
        let count = text.count + string.count - range.length
        return count <= 6
    }
    
    @IBAction func saveHandler(_ sender: UIButton) {
        if let input = inputText.text{
            if input == "" {
                let myAlert = UIAlertController(title: "警告", message: "請輸入金額", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "確定", style: .default, handler: nil)
                myAlert.addAction(okAction)
                present(myAlert,animated: true,completion: nil)
            }else if input == "0" || input == "00" || input == "000" || input == "0000" || input == "00000" || input == "000000"{
                let myAlert = UIAlertController(title: "警告", message: "輸入金額不可為0", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "確定", style: .default, handler: nil)
                myAlert.addAction(okAction)
                present(myAlert,animated: true,completion: nil)
            }else{
                if kindText == ""{
                    kindText = "支出"
                }
                if scortText == ""{
                    scortText = "飲食"
                }
                if kindText == "支出" {
                    current.salary = 0
                    current.pay = Int(input)!
                }
                if kindText == "收入" {
                    current.pay = 0
                    current.salary = Int(input)!
                }
                if currentMonth <= 9 {
                    zeroMonth = "0\(currentMonth!)"
                }else{
                    zeroMonth = "\(currentMonth!)"
                }
                
                if currentDay <= 9 {
                    zeroDay = "0\(currentDay!)"
                }else {
                    zeroDay = "\(currentDay!)"
                }
                print("確定時間\(zeroMonth) \(zeroDay)")
                current.sort = "\(scortText)"
                current.time = "\(currentYear!)-\(zeroMonth)-\(zeroDay)"
                current.position = "\(kindText)-\(scortText)"
                print("儲存頁的時間\(current.time)")
                if sid == -1{
                    CountDAO.insert(data: current)
                }else{
                    CountDAO.update(data: current)
                }
                sid = -1
                print("addVC sid :\(sid)   sort \(scortText)" )
                dismiss(animated: true, completion: nil)
                inputText.resignFirstResponder()
            }
        }
    }
    
    func menu(){
        mysort = ["支出":["飲食","日常用品","交通","油資","娛樂","服飾","電話網路","醫療保健","稅金","保險"],
                  "收入":["工資","獎金","副業","投資"]]
        mykind = mysort.keys.sorted()
        let city = mykind[0]
        kind.text = city
        let disList = mysort[city]!
        scort.text = disList[0]
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0{
            return mykind.count
        }else{
            let idx = pickerView.selectedRow(inComponent: 0)
            let city = mykind[idx]
            let distList = mysort[city]!
            return distList.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0{
            print("mykind : \(mykind[row])")
            return mykind[row]
        }else{
            let idx = pickerView.selectedRow(inComponent: 0)
            let city = mykind[idx]
            let distList = mysort[city]!
            if row < distList.count {
                return distList[row]
            }
            return ""
        }
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        fulfill.isEnabled = true
        inputText.resignFirstResponder()
        if component == 0{
            kindText = mykind[row]
            let distList = mysort[kindText]!
            scortText = distList[0]
            pickerView.reloadComponent(1)
            pickerView.selectRow(0, inComponent: 1, animated: true)
        }else{
            let idx = pickerView.selectedRow(inComponent: 0)
            let city = mykind[idx]
            let distList = mysort[city]!
            if row < distList.count {
                scortText = distList[row]
            }
            
        }
        if kindText == "" {
            kind.text = mykind[0]
            if scortText != "" {
                scort.text = scortText
            }
            sortStr = scortText
        }else{
            kind.text = kindText
            scort.text = scortText
            kindStr = kindText
            sortStr = scortText
        }
    }
    
    //datePicker Action 動作事件
    @IBAction func datePickerAction(_ sender: Any) {
        let date = datePicker.calendar.dateComponents([.year, .month, .day], from: datePicker.date)
        let pickerYear = date.year
        let pickerMonth = date.month
        let pickerDay = date.day
        if pickerYear != nil{
            Years = pickerYear!
        }
        if pickerMonth != nil{
            Months = pickerMonth!
        }
        if pickerDay != nil{
            Days = pickerDay!
        }
        complete.isEnabled = true
    }
    
    @IBAction func back(_ sender: UIButton) {
        inputText.resignFirstResponder()
        dismiss(animated: true, completion: nil)
    }
    
}
