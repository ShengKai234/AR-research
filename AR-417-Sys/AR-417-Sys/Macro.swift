//
//  Macro.swift
//  AR-417-Sys
//
//  Created by Kai on 2019/4/15.
//  Copyright © 2019 AppCode. All rights reserved.
//

import Foundation

class Macro {
    static var checkJSONArray: [String:Any]  = [String:Any] ()
    static func getCheckList( checkTypeNo:String, superCheckNo:String)->[String:Any] {
//        var checkJSONArray: [String:Any] = [String:Any]()
        //URL
        var request = URLRequest(url: URL(string: "http://140.118.5.33/xampp/getCheckList.php")!)
        
        //Method
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        var json: [String: Any] = [String: Any]()
        json["checkTypeNo"] = checkTypeNo
        json["superCheckNo"] = superCheckNo
        request.httpBody = try? JSONSerialization.data(withJSONObject: json, options: JSONSerialization.WritingOptions())
        
        
        //Http request
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return
            }
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
            // 取得傳回的JSON "checkList"
            if let responseJSON = responseJSON as? [String: Any] {
                // 取得傳回的JSON "checkList" 中的資料，並傳入 self.checkJSONArray
                if let responseJSON = responseJSON["checkList"] as? [String: Any] {
                    checkJSONArray = responseJSON
                }
                OperationQueue.main.addOperation {
                    return checkJSONArray as [String:Any]
//                    self.listCheckName.removeAll()
//                    if let checkName = self.checkJSONArray["CheckItemName1"] as? String{
//                        self.listCheckName.append(checkName)
//                    }
//                    if let checkName = self.checkJSONArray["CheckItemName2"] as? String{
//                        self.listCheckName.append(checkName)
//                    }
//                    if let checkName = self.checkJSONArray["CheckItemName3"] as? String{
//                        self.listCheckName.append(checkName)
//                    }
//                    if let checkName = self.checkJSONArray["CheckItemName4"] as? String{
//                        self.listCheckName.append(checkName)
//                    }
//                    if let checkName = self.checkJSONArray["CheckItemName5"] as? String{
//                        self.listCheckName.append(checkName)
//                    }
//                    if let checkName = self.checkJSONArray["CheckItemName6"] as? String{
//                        self.listCheckName.append(checkName)
//                    }
//                    if let checkName = self.checkJSONArray["CheckItemName7"] as? String{
//                        self.listCheckName.append(checkName)
//                    }
//                    if let checkName = self.checkJSONArray["CheckItemName8"] as? String{
//                        self.listCheckName.append(checkName)
//                    }
//                    if let checkName = self.checkJSONArray["CheckItemName9"] as? String{
//                        self.listCheckName.append(checkName)
//                    }
//                    if let checkName = self.checkJSONArray["CheckItemName10"] as? String{
//                        self.listCheckName.append(checkName)
//                    }
//                    
//                    print(self.listCheckName)
//                    
//                    for checkItems in self.checkNameJSONArray{
//                        if let checkItems = checkItems as? [String: Any]
//                        {
//                            for checkItem in checkItems{
//                                if checkItem.key != "Id" {
//                                    self.listCheckName.append(checkItem.value as! String)
//                                }
//                                print(self.listCheckName)
//                            }
//                        }
//                    }
//                    self.listCheckStatus.removeAll()
//                    for checkItems in self.checkStatusJSONArray{
//                        if let checkItems = checkItems as? [String: Any]
//                        {
//                            for checkItem in checkItems{
//                                if checkItem.key != "Id" {
//                                    self.listCheckStatus.append(checkItem.value as! String)
//                                }
//                                print(self.listCheckStatus)
//                            }
//                        }
//                    }
//                    //                    for checkStatus in self.listCheckStatus{
//                    //                        if checkStatus == "1"{self.listCheckBool.append(true)}
//                    //                        else{self.listCheckBool.append(false)}
//                    //                    }
//                    self.tableCheckItrm.reloadData()
                }
            }
            
        }
        task.resume()
        return checkJSONArray
    }
    
    static func alertScheduleDelate(workSchedules :[WorkSchedule])-> WorkSchedule? {
        let formatter = DateFormatter()
        let now:Date = Date()
        formatter.dateFormat = "yyyy/MM/dd"
        for workSchedule in workSchedules
        {
            //與原計劃時間比較
            let boxDateEnd = formatter.date(from: workSchedule.endDate)
            print("__________boxDateEnd" + workSchedule.modelName + workSchedule.endDate)
            if (boxDateEnd!.compare(now) == .orderedAscending && workSchedule.isCheck=="0"){
                print("__________delate" + workSchedule.modelName + workSchedule.endDate)
                return workSchedule
            }
        }
        return nil
    }
}
