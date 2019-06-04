//
//  APIService.swift
//  AR-417-Simulation
//
//  Created by Kai on 2019/6/2.
//  Copyright © 2019 AppCode. All rights reserved.
//

import Foundation

class APIService {
    
    static func getModelSchedule(userCompletionHandler: @escaping ([WorkSchedule]?, Error?) -> Void) {
        //URL
        var request = URLRequest(url: URL(string: "http://140.118.5.33/xampp/getObjInfo.php")!)
        
        //Method
        request.httpMethod = "GET"
        
        //Parameters
        let postString = ""
        request.httpBody = postString.data(using: .utf8)
        
        //Http request
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return
            }
            let responseJSON = try! JSONSerialization.jsonObject(with: data, options: [])
            //            print(responseJSON)
            if let responseJSON = responseJSON as? [AnyObject] {
                var workSchedules: [WorkSchedule] = []
                for objJSON in responseJSON
                {
                    if let objJSON = objJSON as? [String: Any]
                    {
                        workSchedules.append(WorkSchedule(id: objJSON["Id"] as! String,
                                                           scheduleId: objJSON["scheduleId"] as! String,
                                                           projectName: objJSON["ProjectName"] as! String,
                                                           startDate: objJSON["StartDate"] as! String,
                                                           endDate: objJSON["EndDate"] as! String,
                                                           progress: objJSON["Progress"] as! String,
                                                           superItem: objJSON["SuperItem"] as! String,
                                                           duration: objJSON["Duration"] as! String,
                                                           superModelGroupId: objJSON["SuperModelGroupId"] as! String,
                                                           modelName: objJSON["ModelName"] as! String,
                                                           groupId: objJSON["GroupId"] as! String,
                                                           isStart: objJSON["IsStart"] as! String,
                                                           isCheck: objJSON["IsCheck"] as! String,
                                                           checkTypeNo: objJSON["CheckTypeNo"] as! String,
                                                           superCheckNo: objJSON["SuperCheckNo"] as! String))
                    }
                }
                userCompletionHandler(workSchedules, nil)
            }
        }
        task.resume()
        // function will end here and return
        // then after receiving HTTP response, the completionHandler will be called
    }
    
}
