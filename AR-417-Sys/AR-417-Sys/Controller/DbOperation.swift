//
//  DbOperation.swift
//  AR-417-Sys
//
//  Created by Kai on 2018/12/15.
//  Copyright © 2018 AppCode. All rights reserved.
//

import Foundation

class DbOperation{
    var virtualObjs: [VirtualObj] = [VirtualObj(id: "",code: "", objname: "", dateStart: "", dateEnd: "", isStart: "", isCheck: "", checkType: "", progress: "", superItem: "", superModel: "", duration: "")]

    init(){}
    func queryObjInfo()->[VirtualObj]
    {
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
            //print(responseJSON)
            if let responseJSON = responseJSON as? [AnyObject] {
                for obj in responseJSON
                {
                    print(responseJSON[0]["ObjId"])
//                    var responseObj = VirtualObj(objname: obj["ObjName"] as! String,
//                                                dateStart: obj["DateStart"] as! String,
//                                                dateEnd: obj["DateEnd"] as! String,
//                                                isStart: obj["IsStart"] as! String,
//                                                isCheck: obj["IsCheck"] as! String,
//                                                type: obj["type"] as! String
//                                                )
                    
//                    self.virtualObjs.append(responseObj as VirtualObj)
                }
            }
        }
        task.resume()
        return virtualObjs
    }
    
}
