//
//  ViewController.swift
//  App
//
//  Created by yan r on 2019/6/21.
//  Copyright © 2019 yan r. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{

    
    var kindTexts = ""
    var scortTexts : String!
    var moneys : Int!
    var array = [Count]()
    var list = [String]()
    var todayDate = ""
    var time = ""
    var t = ""
    var zeroMonth = ""
    var zeroDay = ""
    var a = true
    var tt = ""
    var datas = [String : [Count]]()
    
    @IBOutlet var calender: UICollectionView!
    @IBOutlet var tableView: UITableView!
    @IBOutlet weak var datePIckerView: UIView!
    @IBOutlet weak var labelText: UILabel!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet var complete: UIButton!
    @IBOutlet var accountingText: UILabel!
    @IBOutlet var kind: UILabel!
    @IBOutlet var money: UILabel!
    
    
    var income : Int = 0
    var pay : Int = 0
    var Years : Int!
    var Months : Int!
    var Days : Int!
    var currentYear = Calendar.current.component(.year, from: Date())
    var currentMonth = Calendar.current.component(.month, from: Date())
    var currentDay = Calendar.current.component(.day, from: Date())
    var months = [" 1月▾"," 2月▾"," 3月▾"," 4月▾"," 5月▾"," 6月▾"," 7月▾"," 8月▾"," 9月▾"," 10月▾"," 11月▾"," 12月▾"]
    
    var numberOfDaysInThisMonth:Int{
        let dateComponents = DateComponents(year: currentYear,month: currentMonth)
        let date = Calendar.current.date(from: dateComponents)!
        let range = Calendar.current.range(of: .day, in: .month, for: date)
        return range?.count ?? 0
    }
    var whatDayIsIt:Int{
        let dateComponents = DateComponents(year: currentYear,month: currentMonth)
        let date = Calendar.current.date(from: dateComponents)!
        return Calendar.current.component(.weekday, from: date)
    }
    var howManyItemShouldIAdd:Int{
        return whatDayIsIt - 1
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        labelText.text = "\(currentYear)年 \(currentMonth)月 \(currentDay)日▾"
        
        if currentMonth <= 9 {
            zeroMonth = "0\(currentMonth)"
        }else{
            zeroMonth = "\(currentMonth)"
        }
        if currentDay <= 9 {
            zeroDay = "0\(currentDay)"
        }else {
            zeroDay = "\(currentDay)"
        }
        
        todayDate = "\(currentYear)-\(zeroMonth)-\(zeroDay)"
        tt = "\(currentYear)-\(zeroMonth)"
        t = todayDate
        datePIckerView.isHidden = true
        setUp()
        tabBar()
        pickerclick()
        array = CountDAO.getCountByName(time: todayDate)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if currentMonth <= 9 {
            zeroMonth = "0\(currentMonth)"
        }else{
            zeroMonth = "\(currentMonth)"
        }
        labelText.text = "\(currentYear)年 \(currentMonth)月 \(currentDay)日▾"
        tabBar()
        array = CountDAO.getCountByName(time: t)
        compute()
        calender.reloadData()
        tableView.reloadData()
    }
//    override func viewWillAppear(_ animated: Bool) {
//        compute()
//        calender.reloadData()
//        tableView.reloadData()
//    }
    //收支計算
    func compute(){
        income = 0
        pay = 0
        for i in array{
            income += i.salary
            pay += i.pay
        }
        let format = NumberFormatter()
        format.numberStyle = .decimal
        let ee = format.string(for: NSNumber(value: income))!
        let rr = format.string(for: NSNumber(value: pay))!
        let titleMoney = format.string(for: NSNumber(value: income - pay))!
        accountingText.text = "收入:\(ee) 支出:\(rr) 餘額:\(titleMoney)"
    }
    func  tabBar(){
        if let listvc = self.tabBarController?.viewControllers?[1] as? ListVC {
            listvc.t = "\(currentYear)-\(zeroMonth)"
            listvc.currentYear = currentYear
            listvc.currentMonth = currentMonth
            listvc.currentDay = currentDay
        }
    }
    
    //上下一個月份更改labelText
    func setUp(){
        labelText.text = "\(currentYear)年 \(currentMonth)月 \(currentDay)日▾"
        let dateFormatter = DateFormatter.init()  //調整上下月份連動datePicker
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date = dateFormatter.date(from: "\(currentYear)-\(currentMonth)-\(currentDay)")
        datePicker.setDate(date!, animated: true)
    }
    //datePicker Action 動作事件
    @IBAction func datePickerAction(_ sender: UIDatePicker) {
        let date = datePicker.calendar.dateComponents([.year, .month, .day], from: datePicker.date)
        let pickerYear = date.year
        let pickerMonth = date.month
        let pickerDay = date.day
        if pickerYear != nil{
            Years = pickerYear!
        }
        if pickerMonth != nil{
            Months = pickerMonth!
            a = true
        }
        if pickerDay != nil{
            Days = pickerDay!
        }
        complete.isEnabled = true
    }
    //按下確定後datePikerView消失後變更labelText跟日曆日期
    @IBAction func okClick(_ sender: Any) {

        if Years != nil || Months != nil || Days != nil{
            
            currentYear = Years
            currentMonth = Months
            currentDay = Days
            
            if Months <= 9 {
                zeroMonth = "0\(Months!)"
            }else{
                zeroMonth = "\(Months!)"
            }
            
            if Days <= 9 {
                zeroDay = "0\(Days!)"
            }else {
                zeroDay = "\(Days!)"
            }
            t = "\(Years!)-\(zeroMonth)-\(zeroDay)"
            print("t \(t)")
            datePIckerView.isHidden = true
        }
        
        array = CountDAO.getCountByName(time: t)
        calender.reloadData()
        tableView.reloadData()
        labelText.text = "\(currentYear)年 \(currentMonth)月 \(currentDay)日▾"
        complete.isEnabled = false
        tabBar()
        compute()
    }
    //datePikerView 取消事件
    @IBAction func cancel(_ sender: Any) {
        datePIckerView.isHidden = true
    }
    //文字(uiLabel labelText)彈出事件
    func pickerclick(){
        labelText.isUserInteractionEnabled = true
        labelText.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(click)))
    }
    //文字(uiLabel labelText)彈出datePiker事件
    @objc func click(){
        labelText.text = "\(currentYear)年 \(currentMonth)月 \(currentDay)日▾"
        let dateFormatter = DateFormatter.init()  //調整上下月份連動datePicker
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dates = dateFormatter.date(from: "\(currentYear)-\(currentMonth)-\(currentDay)")
        datePicker.setDate(dates!, animated: false)
        datePIckerView.isHidden = false
        complete.isEnabled = false
    }
    //按＋可以跳出新頁面做統計計算
    @IBAction func addCount(_ sender: Any) {
        self.performSegue(withIdentifier: "segue_add", sender: self)
        datePIckerView.isHidden = true
    }
    //傳值給第二頁
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segue_add" {
            if let controller = segue.destination as? addVC{
                controller.currentYear = currentYear
                controller.currentMonth = currentMonth
                controller.currentDay = currentDay
                controller.delegate = self
                let row = tableView.indexPathForSelectedRow?.row
                if row != nil {
                    let data = array[row!]
                    controller.sid = data.sid
                    if data.pay == 0{
                        controller.vcKind = "收入"
                        controller.vcSort = data.sort
                        controller.vcmoney = "\(data.salary)"
                    }else if data.pay != 0{
                        controller.vcKind = "支出"
                        controller.vcSort = data.sort
                        controller.vcmoney = "\(data.pay)"
                    }
                }
            }
        }
    }
    //取消事件
    @IBAction func Unwind(for segue :UIStoryboardSegue){
        print("取消")
    }
    //tableView 設計
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return array.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "CELL", for: indexPath) as? MoneyTableViewCell{
            let data = array[indexPath.row]
            let format = NumberFormatter()
            format.numberStyle = .decimal
            if data.salary == 0 {
                cell.moneyText.text = "$ \(format.string(for: NSNumber(value: data.pay))!)"
                cell.kindText.textColor = .red
                cell.moneyText.textColor = .red
            }else{
                cell.moneyText.text = "$ \(format.string(for: NSNumber(value: data.salary))!)"
                cell.moneyText.textColor = UIColor(red: 14 / 255.0, green: 181 / 255.0, blue: 11 / 255.0 , alpha: 1)
                cell.kindText.textColor = UIColor(red: 14 / 255.0, green: 181 / 255.0, blue: 11 / 255.0 , alpha: 1)
            }
            cell.kindText.text = data.position
            return cell
        }
        let cell = UITableViewCell()
        return cell
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        datePIckerView.isHidden = true
        if editingStyle == .delete{
            let data = array.remove(at: indexPath.row)
            let sid = data.sid
            CountDAO.delete(sid: sid)
            compute()
            calender.reloadData()
            tableView.deleteRows(at: [indexPath], with: .fade)
        }else if editingStyle == .insert{
            
        }
    }
    
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "刪除"
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "segue_add", sender: self)
        datePIckerView.isHidden = true
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numberOfDaysInThisMonth + howManyItemShouldIAdd
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CEll", for: indexPath)
        
        if currentMonth != Months {
            cell.contentView.backgroundColor = UIColor.clear
            cell.backgroundColor = UIColor.clear
        }else{
            cell.contentView.backgroundColor = UIColor.clear
        }
        cell.backgroundColor = UIColor.clear
        
        let idx = Int("\((indexPath.row + 1) - howManyItemShouldIAdd)")
        tt = "\(currentYear)-\(zeroMonth)"
        list = CountDAO.getCountByTime(time: tt)
        for sd in list {
            datas[sd] = CountDAO.getCountByName(time: sd)
            let test = String(sd.suffix(2))
            
            if idx! == Int(test) {
                cell.backgroundColor = UIColor(red: 244/256, green: 164/256, blue: 96/256, alpha: 1)
                print(idx!)
            }
        }
        
        if let textLabel = cell.contentView.subviews[0] as? UILabel{ //找到所有cell加的物件 『0』第一個物件
            if indexPath.row < howManyItemShouldIAdd{ //每個月份第一天前面的星期都是空字串
                textLabel.text = ""
            }else{
                //(indexPath.row + 1 )0~30 +1
                textLabel.text = "\((indexPath.row + 1) - howManyItemShouldIAdd)"
            }
        }
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width / 7
        
        return CGSize(width: width, height: 40)
    }
    var idex : Int!
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("點擊\((indexPath.row + 1) - howManyItemShouldIAdd)")
        var idx = Int("\((indexPath.row + 1) - howManyItemShouldIAdd)")
        if idx != nil {
            if idx! >= 1 && idx! <= 31{
                let selectedCell:UICollectionViewCell = collectionView.cellForItem(at: indexPath)!
                selectedCell.contentView.backgroundColor = UIColor(red: 220/256, green: 220/256, blue: 220/256, alpha: 1)
                idex = idx!
                currentDay = idx!
                idx! = idex
                if currentMonth <= 9 {
                    zeroMonth = "0\(currentMonth)"
                }else{
                    zeroMonth = "\(currentMonth)"
                }
                if idex! <= 9 {
                    zeroDay = "0\(idex!)"
                }else {
                    zeroDay = "\(idex!)"
                }
                t = "\(currentYear)-\(zeroMonth)-\(zeroDay)"
                array = CountDAO.getCountByName(time: t)
                compute()
                labelText.text = "\(currentYear)年 \(currentMonth)月 \(currentDay)日▾"
                tabBar()
                tableView.reloadData()
            }
        }
    }
    //取消點擊的動作
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
            let cellToDeselect:UICollectionViewCell = collectionView.cellForItem(at: indexPath)!
            cellToDeselect.contentView.backgroundColor = UIColor.clear
    }
}



