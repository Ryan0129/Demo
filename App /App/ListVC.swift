//
//  ListVC.swift
//  App
//
//  Created by ucom Apple root S08 on 2019/7/11.
//  Copyright © 2019 yan r. All rights reserved.
//

import UIKit

class ListVC: UIViewController,UITableViewDelegate,UITableViewDataSource {
    weak var delegate : ViewController!
    var array = [Count]()
    var list = [String]()
    var todayDate = ""
    var t = ""
    var zeroMonth = ""
    var zeroDay = ""
    var datas = [String : [Count]]()
    
    
    @IBOutlet var labelText: UILabel!
    @IBOutlet var datePickerView: UIView!
    @IBOutlet var datePicker: UIDatePicker!
    @IBOutlet var complete: UIButton!
    @IBOutlet var accountingText: UILabel!
    @IBOutlet var tabView: UITableView!

    var income = 0
    var pay = 0
    var Years : Int!
    var Months : Int!
    var Days : Int!
    var currentYear = 0
    var currentMonth = 0
    var currentDay : Int!
    var Year : Int!
    var months = [" 1月▾"," 2月▾"," 3月▾"," 4月▾"," 5月▾"," 6月▾"," 7月▾"," 8月▾"," 9月▾"," 10月▾"," 11月▾"," 12月▾"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if currentMonth <= 9 {
            zeroMonth = "0\(currentMonth)"
        }else{
            zeroMonth = "\(currentMonth)"
        }
        if currentDay <= 9 {
            zeroDay = "0\(currentDay!)"
        }else {
            zeroDay = "\(currentDay!)"
        }
        labelText.text = "\(currentYear)年 \(currentMonth)月"
        datePickerView.isHidden = true
        setUp()
        todayDate = "\(currentYear)-\(zeroMonth)"
        t = todayDate

    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        labelText.text = "\(currentYear)年 \(currentMonth)月"
        tabBar()
        t = "\(currentYear)-\(zeroMonth)"
        array = CountDAO.getCountByNames(time: t)
        list = CountDAO.getCountByTime(time: t)
        for sd in list {
            datas[sd] = CountDAO.getCountByName(time: sd)
        }
        compute()
        tabView.reloadData()
    }
    
    func compute(){
        income = 0
        pay = 0
        for sd in list {
            print("sd\(sd)")
            array = CountDAO.getCountByName(time: sd)
            for i in array{
                income += i.salary
                pay += i.pay
            }
        }
        
        let format = NumberFormatter()
        format.numberStyle = .decimal
        let ee = format.string(for: NSNumber(value: income))!
        let rr = format.string(for: NSNumber(value: pay))!
        let titleMoney = format.string(for: NSNumber(value: income - pay))!
        accountingText.text = "總收入:\(ee) 總支出:\(rr) 總餘額:\(titleMoney)"
    }
    
    func tabBar(){
        if let ViewController = self.tabBarController?.viewControllers?[0] as? ViewController {
            ViewController.currentYear = currentYear
            ViewController.currentMonth = currentMonth
            ViewController.currentDay = currentDay
            if currentMonth <= 9 {
                zeroMonth = "0\(currentMonth)"
            }else{
                zeroMonth = "\(currentMonth)"
            }
            if currentDay <= 9 {
                zeroDay = "0\(currentDay!)"
            }else {
                zeroDay = "\(currentDay!)"
            }
            ViewController.t = "\(currentYear)-\(zeroMonth)-\(zeroDay)"
            ViewController.tableView.reloadData()
        }
    }
    //下個月
    @IBAction func nextMonth(_ sender: UIButton) {
        currentMonth += 1
        if currentMonth == 13{
            currentMonth = 1
            currentYear += 1
        }
        if currentMonth <= 9 {
            zeroMonth = "0\(currentMonth)"
        }else{
            zeroMonth = "\(currentMonth)"
        }
        if currentDay <= 9 {
            zeroDay = "0\(currentDay!)"
        }else {
            zeroDay = "\(currentDay!)"
        }
        t = "\(currentYear)-\(zeroMonth)"
        array = CountDAO.getCountByNames(time: t)
        list = CountDAO.getCountByTime(time: t)
        for sd in list {
            datas[sd] = CountDAO.getCountByName(time: sd)
        }
        compute()
        tabBar()
        setUp()
        tabView.reloadData()
    }
    
    //上個月
    @IBAction func lastMonth(_ sender: UIButton) {
        currentMonth -= 1
        if currentMonth == 0{
            currentMonth = 12
            currentYear -= 1
        }
        
        if currentMonth <= 9 {
            zeroMonth = "0\(currentMonth)"
        }else{
            zeroMonth = "\(currentMonth)"
        }
        if currentDay <= 9 {
            zeroDay = "0\(currentDay!)"
        }else {
            zeroDay = "\(currentDay!)"
        }
        
        t = "\(currentYear)-\(zeroMonth)"
        array = CountDAO.getCountByNames(time: t)
        list = CountDAO.getCountByTime(time: t)
        for sd in list {
            datas[sd] = CountDAO.getCountByName(time: sd)
        }
        compute()
        tabBar()
        setUp()
        tabView.reloadData()
    }
    //上下一個月份更改labelText
    func setUp(){
        labelText.text = "\(currentYear)年 \(currentMonth)月"
        let dateFormatter = DateFormatter.init()  //調整上下月份連動datePicker
        dateFormatter.dateFormat = "yyyy-MM"
        let date = dateFormatter.date(from: "\(currentYear)-\(currentMonth)")
        datePicker.setDate(date!, animated: true)
        datePickerView.isHidden = true
        
    }
    
    @IBAction func okClick(_ sender: UIButton) {
        if Years != nil || Months != nil || Days != nil{
            currentYear = Years
            currentMonth = Months
            currentDay = Days
            t = "\(Years!)-\(Months!)"
            datePickerView.isHidden = true
        }
        array = CountDAO.getCountByNames(time: t)
        print("list : t = \(t)")
        print("list : array\(array)")
        labelText.text = "\(currentYear)年 \(currentMonth)月▾"
        complete.isEnabled = false
        tabView.reloadData()
        tabBar()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return list.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let number = datas[list[section]]!.count
        return number
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "CELL", for: indexPath) as? ListTableViewCell{
            let data = datas[list[indexPath.section]]![indexPath.row]
            let format = NumberFormatter()
            format.numberStyle = .decimal
            if data.salary == 0 {
                cell.moneyText.text = "$ \(format.string(for: NSNumber(value: data.pay))!)"
                cell.moneyText.textColor = .red
                cell.kindText.textColor = .red
            }else{
                cell.moneyText.text = "$ \(format.string(for: NSNumber(value: data.salary))!)"
                cell.moneyText.textColor = UIColor(red: 14 / 255.0, green: 181 / 255.0, blue: 11 / 255.0 , alpha: 1)
                cell.kindText.textColor = UIColor(red: 14 / 255.0, green: 181 / 255.0, blue: 11 / 255.0 , alpha: 1)
            }
            cell.kindText.text = "\(data.position)"
            return cell
        }
        let cell = UITableViewCell()
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            let data = datas[list[indexPath.section]]!.remove(at: indexPath.row)
            let sid = data.sid
            CountDAO.delete(sid: sid)
            list = CountDAO.getCountByTime(time: t)
            for sd in list {
                datas[sd] = CountDAO.getCountByName(time: sd)
            }
            compute()
//            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.reloadData()
        }else if editingStyle == .insert{
            
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return list[section]
    }
    
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "刪除"
    }
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        let test = UIView(frame: CGRect(x: 10, y: 10, width: 10, height: 10))
//        test.backgroundColor = .white
//        let label = UILabel(frame: CGRect(x: 10, y: 10, width: 10, height: 10))
//        test.addSubview(label)
//        label.text = list[section]
//
//        return test
//    }
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 20
//    }
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        return nil
//    }
//    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
//        return nil
//    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        if section == 0 {
//            return CGFloat.leastNormalMagnitude
//        }
        return 30
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1
    }
}
