//
//  VirtualObjectViewController.swift
//  AR-417-Sys
//
//  Created by Kai on 2018/12/16.
//  Copyright © 2018 AppCode. All rights reserved.
//

import UIKit

class VirtualObjectViewController: UIViewController {
    
    @IBOutlet var showName: UILabel!
    @IBOutlet var showisStart: UILabel!
    @IBOutlet var showisCheck: UILabel!
    @IBOutlet var switchStart: UISwitch!
    @IBOutlet var switchCheck: UISwitch!
    @IBOutlet weak var textStart: UITextField!
    @IBOutlet weak var textEnd: UITextField!
    @IBOutlet weak var progress: UIProgressView!
    @IBOutlet weak var showProgress: UILabel!
    
    var virtualObj: VirtualObj = VirtualObj(id: "", code: "", objname: "", dateStart: "", dateEnd: "", isStart: "", isCheck: "", checkType: "", progress: "", superItem: "", superModel: "", duration: "")
    var name: String = ""
    var dateStart: String = ""
    var dateEnd: String = ""
    var isCheck: String = ""
    var isStart: String = ""
    var progressCount: Float = 0
    var permsion: String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.largeTitleDisplayMode = .never
        showName.text = self.virtualObj.objname
        textStart.text = self.virtualObj.dateStart
        textEnd.text = self.virtualObj.dateEnd
        isStart = self.virtualObj.isStart
        isCheck = self.virtualObj.isCheck
        progress.progress = progressCount/10
        showProgress.text = String(100*progressCount/10)+"%"
        
        if (permsion=="engineer") {
            textStart.isEnabled = true
            textEnd.isEnabled = true
        }else{
            textStart.isEnabled = false
            textEnd.isEnabled = false
        }
        
        if (permsion=="supervision") {
            switchStart.isEnabled = true
            switchCheck.isEnabled = true
        }else{
            switchStart.isEnabled = false
            switchCheck.isEnabled = false
        }
        
        
        if (isStart == "1")
        {
            switchStart.isOn = true
            showisStart.text = "已開工"
        }else{
            switchStart.isOn = false
            showisStart.text = "尚未開工"
        }
        showisCheck.text = isCheck
        if (isCheck == "1")
        {
            switchCheck.isOn = true
            showisCheck.text = "已查核"
        }else{
            switchCheck.isOn = false
            showisCheck.text = "尚未查核"
        }
        // Do any additional setup after loading the view.
    }
    
    @IBAction func switchStart(_ sender: UISwitch) {
        if sender.isOn == true {
            self.virtualObj.isStart = "1"
            showisStart.text = "已開工"
        }else{
            self.virtualObj.isStart = "0"
            showisStart.text = "尚未開工"
        }
    }
    
    @IBAction func switchChecl(_ sender: UISwitch) {
        if sender.isOn == true {
            self.virtualObj.isCheck = "1"
            showisCheck.text = "已查核"
        }else{
            self.virtualObj.isCheck = "0"
            showisCheck.text = "尚未查核"
        }
    }
    
    
    //---------------------------查驗項目顯示、與頁面跳轉
    @IBAction func btnCheckList(_ sender: Any) {
        performSegue(withIdentifier: "ShowCheckList", sender: nil)
    }
    //----------------------------------------------
    
    //---------------------------模型資訊上傳、更新
    @IBAction func btnUpdateInfo(_ sender: Any) {
        //URL
        var request = URLRequest(url: URL(string: "http://140.118.5.33/xampp/updateObjInfo.php")!)
        
        //Method
        request.httpMethod = "POST"
        
        //Parameters
        let postString = "isStart=\(String(self.virtualObj.isStart))&isCheck=\(String(self.virtualObj.isCheck))&objName=\(String(self.virtualObj.objname))"
        request.httpBody = postString.data(using: .utf8)
        
        //Http request
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return
            }
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
            print(responseJSON)
            
        }
        task.resume()
    }
    //----------------------------------------------
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
