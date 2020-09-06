//
//  CountDAO.swift
//  App
//
//  Created by ucom Apple root S08 on 2019/7/18.
//  Copyright © 2019 yan r. All rights reserved.
//

import Foundation

class CountDAO{
    //複製的地址
    static var dbPath : String{
        let target = "\(NSHomeDirectory())/Documents/db.sqlite"
        let fileMgr = FileManager.default
        if !fileMgr.fileExists(atPath: target){
            if let source = Bundle.main.path(forResource: "test1", ofType: "sqlite"){
                try? fileMgr.copyItem(atPath: source, toPath: target)
            }
        }
        return target
    }
    
    static func getCountBySid(sid:Int)->Count?{
        var data : Count?
        let db = FMDatabase(path: dbPath)
        db?.open()
        if let results = db?.executeQuery("SELECT * FROM Count WHERE sid = ?", withArgumentsIn: [sid]){
            if results.next(){
                let sid = results.int(forColumn: "sid")
                let time = results.string(forColumn: "time")
                let pay = results.int(forColumn: "pay")
                let salary = results.int(forColumn: "salary")
                let position = results.string(forColumn: "position")
                let sort = results.string(forColumn: "sort")
                data = Count(sid: Int(sid), time: time!, pay: Int(pay), salary: Int(salary), position: position! , sort: sort!)
            }
        }
        db?.close()
        return data
    }

    static func getCountByName(time:String)->[Count]{
        var list = [Count]()
        let db = FMDatabase(path: dbPath)
        db?.open()
        if let results = db?.executeQuery("SELECT * FROM Count WHERE time = ?", withArgumentsIn: [time]){
            while results.next(){
                let sid = results.int(forColumn: "sid")
                let time = results.string(forColumn: "time")
                let pay = results.int(forColumn: "pay")
                let salary = results.int(forColumn: "salary")
                let position = results.string(forColumn: "position")
                let sort = results.string(forColumn: "sort")
                let data = Count(sid: Int(sid), time: time!, pay: Int(pay), salary: Int(salary), position: position! , sort: sort!)
                list.append(data)
            }
            results.close()
        }
        db?.close()
        return list
    }
    
    static func getCountByNames(time:String)->[Count]{
        var list = [Count]()
        let db = FMDatabase(path: dbPath)
        db?.open()
        if let results = db?.executeQuery("SELECT * FROM Count WHERE time like ? ORDER BY time ASC",withArgumentsIn: ["\(time)%"]){
            while results.next(){
                let sid = results.int(forColumn: "sid")
                let time = results.string(forColumn: "time")
                let pay = results.int(forColumn: "pay")
                let salary = results.int(forColumn: "salary")
                let position = results.string(forColumn: "position")
                let sort = results.string(forColumn: "sort")
                let data = Count(sid: Int(sid), time: time!, pay: Int(pay), salary: Int(salary), position: position! , sort: sort!)
                list.append(data)
            }
            results.close()
        }
        db?.close()
        return list
    }
    
    static func getCountByTime(time:String)->[String]{
        var list = [String]()
        let db = FMDatabase(path: dbPath)
        db?.open()
        if let results = db?.executeQuery("SELECT DISTINCT time FROM Count WHERE time like ? ORDER BY time ASC",withArgumentsIn: ["\(time)%"]){
            while results.next(){
                let time = results.string(forColumn: "time")
                list.append(time!)
            }
            results.close()
        }
        db?.close()
        return list
    }
    
    static func getAllCount()->[Count]{
        var list = [Count]()
        let db = FMDatabase(path: dbPath)
        db?.open()
        if let results = db?.executeQuery("SELECT * FROM Count", withArgumentsIn: []){
            while results.next(){
                let sid = results.int(forColumn: "sid")
                let time = results.string(forColumn: "time")
                let pay = results.int(forColumn: "pay")
                let salary = results.int(forColumn: "salary")
                let position = results.string(forColumn: "position")
                let sort = results.string(forColumn: "sort")
                let data = Count(sid: Int(sid), time: time!, pay: Int(pay), salary: Int(salary), position: position! , sort: sort!)
                list.append(data)
            }
            results.close()
        }
        db?.close()
        return list
    }
    
    static func insert(data:Count){
        var dict = [String:Any]()
        dict["t"] = data.time
        dict["p"] = data.pay
        dict["s"] = data.salary
        dict["pos"] = data.position
        dict["sor"] = data.sort
        let sql = "INSERT INTO Count(time,pay,salary,position,sort) VALUES (:t,:p,:s,:pos,:sor)"
        execUpdate(sql,data: dict)
    }
    
    static func update(data:Count){
        var dict = [String:Any]()
        dict["t"] = data.time
        dict["p"] = data.pay
        dict["s"] = data.salary
        dict["pos"] = data.position
        dict["sor"] = data.sort
        dict["sid"] = data.sid
        let sql = "UPDATE Count SET time=:t,pay=:p,salary=:s,position=:pos,sort=:sor WHERE sid=:sid"
        execUpdate(sql,data: dict)

    }
    static func delete(sid:Int){
        var dict = [String:Any]()
        dict["sid"] = sid
        let sql = "DELETE FROM Count WHERE sid = :sid"
        execUpdate(sql,data: dict)
    }
    
    static func execUpdate(_ sql : String, data : [String:Any]){
        execUpdate(sql,data:data,path: dbPath)
    }
    
    static func execUpdate(_ sql : String, data : [String:Any], path : String){
        let db = FMDatabase(path: path)
        db?.open()
        db?.executeUpdate(sql, withParameterDictionary: data)
        db?.close()
    }
}
