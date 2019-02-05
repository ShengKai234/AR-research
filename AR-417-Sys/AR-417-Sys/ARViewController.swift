//
//  ARViewController.swift
//  AR-417-Sys
//
//  Created by Kai on 2018/12/13.
//  Copyright © 2018 AppCode. All rights reserved.
//

import UIKit
import ARKit
import Foundation


class ARViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var sceneView: ARSCNView!
    var saveSceneView: ARSCNView!
    
    @IBOutlet weak var permisonLabel: UILabel!
    @IBOutlet weak var ObjInfoView: UIView!
    
    let fadeDuration: TimeInterval = 1
    let rotateDuration: TimeInterval = 3
    let waitDuration: TimeInterval = 3600
    private var currentNode: SCNNode?
    var user = User(username: "", userid: 0, usersecurity: "",  usermail: "")
    var virtualObjs: [VirtualObj] = []
    
    //Data from database
    var objJSONArray:[AnyObject] = [AnyObject]()
    
    //var virtualObj = VirtualObj()
    //圖片辨識模型動作變數
    lazy var fadeAction: SCNAction = {
        return .sequence([
            .fadeOpacity(by: 0.8, duration: fadeDuration),
            .wait(duration: waitDuration),
            .fadeOut(duration: fadeDuration)
            ])
    }()
    
    //物件建立於場景的初始化，以及影像辨識對應的物件
    lazy var ColumnNode: SCNNode = {
        guard let scene = SCNScene(named: "417.scn"),
            let node = scene.rootNode.childNode(withName: "box_node", recursively: false) else { return SCNNode() }
        return node
    }()
    
    //--------------------------------------場景載入點＿1
    override func viewDidLoad() {
        super.viewDidLoad()
        sceneView.delegate = self
        sceneView.autoenablesDefaultLighting = true
        OperationQueue.main.addOperation {
            self.permisonLabel.text = self.user.usersecurity
        }
//        configureLighting()
        addTapGestureToSceneView()
//                getData()
//                locationManager.delegate = self
//
//                if CLLocationManager.isMonitoringAvailable(for: CLBeaconRegion.self){
//                    if CLLocationManager.authorizationStatus() != CLAuthorizationStatus.authorizedAlways{
//                        locationManager.requestAlwaysAuthorization()
//                    }
//                }
        
    }
    //場景加載（2）
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let configuration = ARWorldTrackingConfiguration()
        sceneView.session.run(configuration)
        resetTrackingCongiguration()
        
    }
    //場景加載（3）
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        sceneView.session.pause()
    }
    //------------------------------------------------
    
    
    //--------------------------------------重置按鈕呼叫方法
    @IBAction func resetButtonDidTouch(_ sender: UIButton) {
        resetTrackingCongiguration()
    }
    //------------------------------------------------
    
    
//--------------------------------------AR偵測（辨識）系統
    func resetTrackingCongiguration()
    {
        //識別圖片加載，並辨視攝影機照射之影像，如果沒有辨識到預先輸入圖片則return
        guard let referenceImages = ARReferenceImage.referenceImages(inGroupNamed: "AR Resources", bundle: nil) else {return}
        
        //陀螺儀位置抓取
        let configuration = ARWorldTrackingConfiguration()
        //錨點設置
        configuration.detectionImages = referenceImages
        //清出先前追蹤相關錨點
        let options: ARSession.RunOptions=[.resetTracking, .removeExistingAnchors]
        //執行sceneView配置，－－> renderer
        sceneView.session.run(configuration, options: options)
        saveSceneView = sceneView
        
        
        //label.text = "Move Camera around tp detect images"
        //DataPicker()
    }
//------------------------------------------------------------------------------------------
    
//----------------------------------------date、time----------------------------------------
    let now:Date = Date()
    let formatter = DateFormatter()
    @IBAction func DataPicker(_ sender: UIDatePicker)
    {
        formatter.dateFormat = "yyyy/MM/dd"
        //        label_time.text = formatter.string(from: sender.date)
        
        for virtualObj in self.virtualObjs
        {
            let boxDateStart = formatter.date(from: virtualObj.dateStart)
            let boxDateEnd = formatter.date(from: virtualObj.dateEnd)
            //if boxDateStart later sender(select Date())
            if(now.compare(boxDateStart!) == .orderedAscending && virtualObj.isStart == "0")
            {
                currentNode?.childNode(withName: virtualObj.objname, recursively: false)?.isHidden = false
                currentNode?.childNode(withName: virtualObj.objname, recursively: false)?.geometry?.firstMaterial?.diffuse.contents = UIColor.blue
                currentNode?.childNode(withName: virtualObj.objname, recursively: false)?.geometry?.firstMaterial?.emission.contents = UIColor.blue
                if (sender.date < (boxDateStart!)) {
                    currentNode?.childNode(withName: virtualObj.objname, recursively: false)?.isHidden = true
                }
                //else if sender(select Date()) later boxDateStart and is check
            }else if(virtualObj.isCheck == "1" && virtualObj.isStart == "1"){
                currentNode?.childNode(withName: virtualObj.objname, recursively: false)?.isHidden = false
                currentNode?.childNode(withName: virtualObj.objname, recursively: false)?.geometry?.firstMaterial?.diffuse.contents = UIColor.green
                currentNode?.childNode(withName: virtualObj.objname, recursively: false)?.geometry?.firstMaterial?.emission.contents = UIColor.green
                //else if sender(select Date()) later boxDateStart and is start doing
            }else if((virtualObj.isStart == "1" && sender.date.compare(boxDateEnd!) == .orderedAscending) || (virtualObj.isStart == "1" && sender.date.compare(boxDateEnd!) == .orderedSame)){
                currentNode?.childNode(withName: virtualObj.objname, recursively: false)?.isHidden = false
                currentNode?.childNode(withName: virtualObj.objname, recursively: false)?.geometry?.firstMaterial?.diffuse.contents = UIColor.yellow
                currentNode?.childNode(withName: virtualObj.objname, recursively: false)?.geometry?.firstMaterial?.emission.contents = UIColor.yellow
                //else sender(select Date()) later boxDateStart and is start doing and sender later boxDateEnd
            }else{
                currentNode?.childNode(withName: virtualObj.objname, recursively: false)?.isHidden = false
                currentNode?.childNode(withName: virtualObj.objname, recursively: false)?.geometry?.firstMaterial?.diffuse.contents = UIColor.red
                currentNode?.childNode(withName: virtualObj.objname, recursively: false)?.geometry?.firstMaterial?.emission.contents = UIColor.red
            }
        }
    }
    
//---------------------------------操作DB撈取模型資訊-----------------------------------------
    func getObjDate()
    {
        self.virtualObjs.removeAll()
        for objJSON in self.objJSONArray
        {
            if let objJSON = objJSON as? [String: Any]
            {
                //print(objJSON)
                self.virtualObjs.append(VirtualObj(id: objJSON["Id"] as! String,
                                                   code: objJSON["Code"] as! String,
                                                   objname: objJSON["ProjectName"] as! String,
                                                   dateStart: objJSON["StartDate"] as! String,
                                                   dateEnd: objJSON["EndDate"] as! String,
                                                   isStart: objJSON["IsStart"] as! String,
                                                   isCheck: objJSON["IsCheck"] as! String,
                                                   checkType: objJSON["CheckType"] as! String,
                                                   progress: objJSON["Progress"] as! String,
                                                   superItem: objJSON["SuperItem"] as! String,
                                                   superModel: objJSON["SuperModel"] as! String,
                                                   duration: objJSON["Duration"] as! String))
            }
        }
        formatter.dateFormat = "yyyy/MM/dd"
        //        label_time.text = formatter.string(from: sender.date)
        
        for virtualObj in self.virtualObjs
        {
            let boxDateStart = formatter.date(from: virtualObj.dateStart)
            var boxDateEnd = formatter.date(from: virtualObj.dateEnd)
            boxDateEnd = Calendar.current.date(byAdding: .day, value: 1, to: boxDateEnd!)
//            print(boxDateEnd)
            //if boxDateStart later sender(select Date())
            if(now.compare(boxDateStart!) == .orderedAscending && virtualObj.isStart == "0")
            {
                currentNode?.childNode(withName: virtualObj.objname, recursively: false)?.isHidden = false
                currentNode?.childNode(withName: virtualObj.objname, recursively: false)?.geometry?.firstMaterial?.diffuse.contents = UIColor.blue
                currentNode?.childNode(withName: virtualObj.objname, recursively: false)?.geometry?.firstMaterial?.emission.contents = UIColor.blue
                if (now.compare(boxDateStart!) == .orderedAscending) {
                    currentNode?.childNode(withName: virtualObj.objname, recursively: false)?.isHidden = true
                }
                //else if sender(select Date()) later boxDateStart and is check
            }else if(virtualObj.isCheck == "1" && virtualObj.isStart == "1"){
                currentNode?.childNode(withName: virtualObj.objname, recursively: false)?.isHidden = false
                currentNode?.childNode(withName: virtualObj.objname, recursively: false)?.geometry?.firstMaterial?.diffuse.contents = UIColor.green
                currentNode?.childNode(withName: virtualObj.objname, recursively: false)?.geometry?.firstMaterial?.emission.contents = UIColor.green
                //else if sender(select Date()) later boxDateStart and is start doing
            }else if((virtualObj.isStart == "1" && now.compare(boxDateEnd!) == .orderedAscending) || (virtualObj.isStart == "1" && now.compare(boxDateEnd!) == .orderedSame)){
                currentNode?.childNode(withName: virtualObj.objname, recursively: false)?.isHidden = false
                currentNode?.childNode(withName: virtualObj.objname, recursively: false)?.geometry?.firstMaterial?.diffuse.contents = UIColor.yellow
                currentNode?.childNode(withName: virtualObj.objname, recursively: false)?.geometry?.firstMaterial?.emission.contents = UIColor.yellow
                //else sender(select Date()) later boxDateStart and is start doing and sender later boxDateEnd
            }else{
                currentNode?.childNode(withName: virtualObj.objname, recursively: false)?.isHidden = false
                currentNode?.childNode(withName: virtualObj.objname, recursively: false)?.geometry?.firstMaterial?.diffuse.contents = UIColor.red
                currentNode?.childNode(withName: virtualObj.objname, recursively: false)?.geometry?.firstMaterial?.emission.contents = UIColor.red
            }
        }
        
    }
    
    //------------------------------------------------
    
    //getObjInfo Button --> queryObjInfo --> getObjDate
    func queryObjInfo()
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
//            print(responseJSON)
            if let responseJSON = responseJSON as? [AnyObject] {
                self.objJSONArray = responseJSON as [AnyObject]
            }
            OperationQueue.main.addOperation {
                self.getObjDate()
            }
            
        }
        task.resume()
    }
    //----------------------------------------------------
    
    //queryObjInfo_improvement Button --> queryObjInfo_improvement --> getObjDate
    func queryObjInfo_improvement()
    {
        //URL
        var request = URLRequest(url: URL(string: "http://140.118.5.33/xampp/getObjInfo.improvement.php")!)
        
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
                self.objJSONArray = responseJSON as [AnyObject]
            }
            OperationQueue.main.addOperation {
                self.getObjDate()
            }
            
        }
        task.resume()
    }
    //----------------------------------------------------
    
    //btn get info
    @IBAction func getObjInfo(_ sender: Any) {
        queryObjInfo()
    }
    
    @IBAction func getObjInfo_improvement(_ sender: Any) {
        queryObjInfo_improvement()
    }
    
    
    
//--------------------------------------點擊模型事件，參數傳遞------------------------------------------------
    private var selectNode: SCNNode?
    func addTapGestureToSceneView()
    {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ARViewController.didTap(withGestureRecognizer:)))
        sceneView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc func didTap(withGestureRecognizer recognizer: UIGestureRecognizer)
    {
        let tapLocation = recognizer.location(in: sceneView)
        let hitTestResults = sceneView.hitTest(tapLocation)
        guard let node = hitTestResults.first?.node else { return }
        selectNode = node
        
        //performSegue 用虛擬物件做view傳輸，如果有button可以直接建立連線不用使用此行
            //performSegue(withIdentifier: "ShowObjInfo", sender: nil)
        //Open Obj Info
        ObjInfoView.isHidden=false
        getObjInfo()
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "ShowObjInfo" {
            let destinationController = segue.destination as! VirtualObjectViewController
            var progressCount: Float = 0
            for virtualObj in self.virtualObjs
            {
                if (virtualObj.isCheck == "1") {
                    progressCount += 1.0
                }
            }
            for virtualObj in self.virtualObjs
            {
                if (selectNode?.name == virtualObj.objname)
                {
                    destinationController.virtualObj = virtualObj
                    destinationController.permsion = user.usersecurity
                    destinationController.progressCount = progressCount
                    break
                }
            }
        }
    }
//-----------------------------------------------------------------------------------------------------
    
    
//Obj Info View----------------------------------------------------------------------------------------
    var ObjInfo: VirtualObj = VirtualObj(id: "", code: "", objname: "", dateStart: "", dateEnd: "", isStart: "", isCheck: "", checkType: "", progress: "", superItem: "", superModel: "", duration: "")
    
    //受影響工項
    var effects:[String] = [String]()
    
    @IBAction func btnVewClose(_ sender: Any) {
        ObjInfoView.isHidden=true
        self.ObjInfo = VirtualObj(id: "", code: "", objname: "", dateStart: "", dateEnd: "", isStart: "", isCheck: "", checkType: "", progress: "", superItem: "", superModel: "", duration: "")
    }
    
    
    @IBOutlet weak var ObjName: UILabel!
    @IBOutlet weak var fieldStartDate: UITextField!
    @IBOutlet weak var fieldEndDate: UITextField!
    @IBOutlet weak var labelStart: UILabel!
    @IBOutlet weak var labelCheck: UILabel!
    @IBOutlet weak var switchStart: UISwitch!
    @IBOutlet weak var switchCheck: UISwitch!
    @IBOutlet weak var tableCheckItrm: UITableView!
    @IBOutlet weak var effectItem: UILabel!
    @IBAction func btnShowCheck(_ sender: Any) {
        queryCheckType()
        tableCheckItrm.isHidden = false
    }
    
    @IBAction func switchStart(_ sender: UISwitch) {
        if sender.isOn == true {
            self.ObjInfo.isStart = "1"
            labelStart.text = "已開工"
        }else{
            self.ObjInfo.isStart = "0"
            labelStart.text = "尚未開工"
        }
    }
    @IBAction func switchChecl(_ sender: UISwitch) {
        if sender.isOn == true {
            self.ObjInfo.isCheck = "1"
            labelCheck.text = "已查核"
        }else{
            self.ObjInfo.isCheck = "0"
            labelCheck.text = "尚未查核"
        }
    }
    
    @IBOutlet weak var progressSingle: UIProgressView!
    @IBOutlet weak var progressAll: UIProgressView!
    
    
    
    func getObjInfo(){
        effects.removeAll()
        for virtualObj in self.virtualObjs
        {
            if (selectNode?.name == virtualObj.objname)
            {
                ObjInfo = virtualObj
                self.ObjName.text = ObjInfo.objname
                fieldStartDate.text = ObjInfo.dateStart
                fieldEndDate.text = ObjInfo.dateEnd
                if (user.usersecurity=="engineer") {
                    fieldStartDate.isEnabled = true
                    fieldEndDate.isEnabled = true
                }else{
                    fieldStartDate.isEnabled = false
                    fieldEndDate.isEnabled = false
                }
                
                if (user.usersecurity=="supervision") {
                    switchStart.isEnabled = true
                    switchCheck.isEnabled = true
                }else{
                    switchStart.isEnabled = false
                    switchCheck.isEnabled = false
                }
                
                
                if (ObjInfo.isStart == "1")
                {
                    switchStart.isOn = true
                    labelStart.text = "已開工"
                }else{
                    switchStart.isOn = false
                    labelStart.text = "尚未開工"
                }
                if (ObjInfo.isCheck == "1")
                {
                    switchCheck.isOn = true
                    labelCheck.text = "已查核"
                }else{
                    switchCheck.isOn = false
                    labelCheck.text = "尚未查核"
                }
                
                //effect item
//                var effects:[String] = [String]()
                var allCountSingle:Float = 0
                var CountSingleCheck:Float = 0
                var allCountCheck:Float = 0
                for effectObj in self.virtualObjs{
                    if virtualObj.code == effectObj.superItem && !(self.effects.contains(effectObj.id)){
                        self.effects.append(effectObj.id)
                    }
                    if effectObj.code == virtualObj.code{
                        allCountSingle+=1
                        if effectObj.isCheck=="1"{
                            CountSingleCheck+=1
                        }
                    }
                    if effectObj.isCheck=="1"{
                        allCountCheck+=1
                    }
                }
                for effect in self.effects{
                    for effectObj in self.virtualObjs{
                        if effectObj.id==effect{
                            for other_effectObj in self.virtualObjs{
                                if effectObj.code == other_effectObj.superItem && !(self.effects.contains(other_effectObj.id)){
                                    print (other_effectObj.id)
                                    self.effects.append(other_effectObj.id)
                                }
                            }
                        }
                    }
                }
                progressSingle.progress = Float(CountSingleCheck/allCountSingle)
                progressAll.progress = Float(allCountCheck/Float(self.virtualObjs.count))
                effectItem.text = self.effects.joined(separator:",")
                
                break
            }else{
                ObjName.text = "Nothing"
            }
        }
    }
    
    //---------------------------模型資訊上傳、更新------------------------
    @IBAction func btnUpdateInfo(_ sender: Any) {
        updateInfo()
    }
    func updateInfo(){
        //URL
        var request = URLRequest(url: URL(string: "http://140.118.5.33/xampp/updateObjInfo.php")!)
        
        //Method
        request.httpMethod = "POST"
        //print(self.ObjInfo.objname)
        //print(self.ObjInfo.isStart)
        //print(self.ObjInfo.isCheck)
        //Parameters
        let postString = "isStart=\(String(self.ObjInfo.isStart))&isCheck=\(String(self.ObjInfo.isCheck))&objName=\(String(self.ObjInfo.objname))"
        request.httpBody = postString.data(using: .utf8)
        
        //Http request
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return
            }
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
            print(responseJSON)
            OperationQueue.main.addOperation {
                self.queryObjInfo()
            }
        }
        task.resume()
    }
    //------------------------------------------------------
    
    //顯示影響工項
    @IBAction func btnShowEffects(_ sender: Any) {
        presentBeEffects()
    }
    func presentBeEffects(){
        for virtualObj in self.virtualObjs{
            for effect in self.effects
            {
                if effect == virtualObj.id
                {
                    currentNode?.childNode(withName: virtualObj.objname, recursively: false)?.isHidden = false
                    currentNode?.childNode(withName: virtualObj.objname, recursively: false)?.geometry?.firstMaterial?.diffuse.contents = UIColor.orange
                    currentNode?.childNode(withName: virtualObj.objname, recursively: false)?.geometry?.firstMaterial?.emission.contents = UIColor.orange
                    break
                }
                    //                else if virtualObj.isCheck=="1"{
                    //                    currentNode?.childNode(withName: virtualObj.objname, recursively: false)?.isHidden = false
                    //                    currentNode?.childNode(withName: virtualObj.objname, recursively: false)?.geometry?.firstMaterial?.diffuse.contents = UIColor.green
                    //                    currentNode?.childNode(withName: virtualObj.objname, recursively: false)?.geometry?.firstMaterial?.emission.contents = UIColor.green
                    //                }
                    //                else if virtualObj.isStart=="1"{
                    //                    currentNode?.childNode(withName: virtualObj.objname, recursively: false)?.isHidden = false
                    //                    currentNode?.childNode(withName: virtualObj.objname, recursively: false)?.geometry?.firstMaterial?.diffuse.contents = UIColor.yellow
                    //                    currentNode?.childNode(withName: virtualObj.objname, recursively: false)?.geometry?.firstMaterial?.emission.contents = UIColor.yellow
                    //                }
                else{
                    currentNode?.childNode(withName: virtualObj.objname, recursively: false)?.isHidden = false
                    currentNode?.childNode(withName: virtualObj.objname, recursively: false)?.geometry?.firstMaterial?.diffuse.contents = UIColor.gray
                    currentNode?.childNode(withName: virtualObj.objname, recursively: false)?.geometry?.firstMaterial?.emission.contents = UIColor.gray
                }
            }
        }
        selectNode?.geometry?.firstMaterial?.diffuse.contents = UIColor.red
        selectNode?.geometry?.firstMaterial?.emission.contents = UIColor.red
    }
    
    //btn update be effected schedule
    let dateComponentsFormatter = DateComponentsFormatter()
    @IBAction func btnSchedule(_ sender: Any) {
        var autoFormattedDifference = ""
        presentBeEffects()
        //取得目前db時間
//        queryObjInfo()
        
        dateComponentsFormatter.allowedUnits = [.day]
        
        formatter.dateFormat = "yyyy-MM-dd"
        
        if ObjInfo.isCheck == "0"{
            print (ObjInfo.objname)
            print (ObjInfo.dateStart)
            print (ObjInfo.dateEnd)
            
            let dateStart = formatter.date(from: ObjInfo.dateStart)
            let dateEnd = formatter.date(from: ObjInfo.dateEnd)
            //時間差計算
            autoFormattedDifference = dateComponentsFormatter.string(from: dateEnd!, to: now)!
            var calculatedDateEnd = Calendar.current.date(byAdding: .day, value: Int((autoFormattedDifference as! NSString).intValue), to: dateEnd!)
            ObjInfo.dateEnd = formatter.string(from: calculatedDateEnd!)
            print ("Over schedule Day : ")
            print(autoFormattedDifference)
            print(ObjInfo.dateEnd)
        }
        
        for virtualObj in self.virtualObjs{
            for effect in self.effects{
                if effect == virtualObj.id || virtualObj.code == ObjInfo.code
                {
                    print("__________effect Item : " + effect)
                    print("__________origin Start : " + virtualObj.dateStart)
                    print("__________origin End : " + virtualObj.dateEnd)
                    let dateStart = formatter.date(from: virtualObj.dateStart)
                    let dateEnd = formatter.date(from: virtualObj.dateEnd)
                    var calculatedDateStart = Calendar.current.date(byAdding: .day, value: Int((autoFormattedDifference as! NSString).intValue), to: dateStart!)
                    var calculatedDateEnd = Calendar.current.date(byAdding: .day, value: Int((autoFormattedDifference as! NSString).intValue), to: dateEnd!)
                    print(formatter.string(from: calculatedDateStart!))
                    print(formatter.string(from: calculatedDateEnd!))
                    virtualObj.dateStart = formatter.string(from: calculatedDateStart!)
                    virtualObj.dateEnd = formatter.string(from: calculatedDateEnd!)
                }
            }
            
        }
        
        updateAllInfo()
    }
    
    func updateAllInfo(){
        
        var jsons: [String: Any] = [String: Any]()
        var json: [[String: Any]] = [[String: Any]]()
        for virtualObj in self.virtualObjs {
            json.append(["ProjectName":virtualObj.objname ,"StartDate":virtualObj.dateStart, "EndDate":virtualObj.dateEnd])
        }
        jsons["Data"] = json
        print(jsons)
        print("-------------!!")
        //URL
        var request = URLRequest(url: URL(string: "http://140.118.5.33/xampp/updateAllDate_improvement.php")!)
        
        //Method
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        //Parameters
        //        let postString = "isStart=\(String(self.ObjInfo.isStart))&isCheck=\(String(self.ObjInfo.isCheck))&objName=\(String(self.ObjInfo.objname))"
        
        
        //        let jsonData = try? JSONSerialization.data(withJSONObject: jsons, options: [])
        //        print(jsonData)
        request.httpBody = try? JSONSerialization.data(withJSONObject: jsons, options: JSONSerialization.WritingOptions())
        //
        //        //Http request
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return
            }
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
            print(responseJSON)
            print("~~~~~~")
            OperationQueue.main.addOperation {
//                self.queryObjInfo()
            }
        }
        task.resume()
    }
    
    
//-------------------------------------------------------Obj info view end-----------------------------
    
//查驗項目---------------------------------------From btnShowCheck----------------------
    var checkNameJSONArray:[AnyObject] = [AnyObject]()
    var listCheckName:[String] = [String]()
    var checkStatusJSONArray:[AnyObject] = [AnyObject]()
    var listCheckStatus:[String] = [String]()
    var listCheckBool:[Bool] = [Bool]()
    @IBAction func btnCloseTable(_ sender: Any) {
        tableCheckItrm.isHidden = true
    }
    func queryCheckType(){
        //URL
        var request = URLRequest(url: URL(string: "http://140.118.5.33/xampp/getCheckInfo.php")!)
        
        //Method
        request.httpMethod = "POST"
        
        //Parameters
        print(self.ObjInfo.checkType)
        let postString = "checkNameType=\(String(self.ObjInfo.checkType))"
        request.httpBody = postString.data(using: .utf8)
        
        //Http request
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return
            }
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
            if let responseJSON = responseJSON as? [String: Any] {
//                print(responseJSON["checkName"])
//                print(responseJSON["checkStatus"])
                if let responseJSON = responseJSON["checkName"] as? [AnyObject] {
                    self.checkNameJSONArray = responseJSON as [AnyObject]
                }
                if let responseJSON = responseJSON["checkStatus"] as? [AnyObject] {
                    self.checkStatusJSONArray = responseJSON as [AnyObject]
                }
                OperationQueue.main.addOperation {
                    self.listCheckName.removeAll()
                    for checkItems in self.checkNameJSONArray{
                        if let checkItems = checkItems as? [String: Any]
                        {
                            for checkItem in checkItems{
                                if checkItem.key != "Id" {
                                    self.listCheckName.append(checkItem.value as! String)
                                }
                                print(self.listCheckName)
                            }
                        }
                    }
                    self.listCheckStatus.removeAll()
                    for checkItems in self.checkStatusJSONArray{
                        if let checkItems = checkItems as? [String: Any]
                        {
                            for checkItem in checkItems{
                                if checkItem.key != "Id" {
                                    self.listCheckStatus.append(checkItem.value as! String)
                                }
                                print(self.listCheckStatus)
                            }
                        }
                    }
//                    for checkStatus in self.listCheckStatus{
//                        if checkStatus == "1"{self.listCheckBool.append(true)}
//                        else{self.listCheckBool.append(false)}
//                    }
                    self.tableCheckItrm.reloadData()
                }
            }
            
        }
        task.resume()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listCheckName.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "Cell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        cell.textLabel?.text = listCheckName[indexPath.row] + listCheckStatus[indexPath.row]
        if listCheckStatus[indexPath.row] == "1"{cell.accessoryType = .checkmark}else{cell.accessoryType = .none}
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let optionMenu = UIAlertController(title: nil, message: "Waht do you want to do?", preferredStyle: .actionSheet)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        optionMenu.addAction(cancelAction)
        
        let checkAction = UIAlertAction(title: "Check", style: .default, handler: {
            (action: UIAlertAction!) -> Void in

            let cell = tableView.cellForRow(at: indexPath)
            cell?.accessoryType = .checkmark
//            self.listCheckBool[indexPath.row] = true
            self.listCheckStatus[indexPath.row] = "1"
            print(self.listCheckStatus)
            self.tableCheckItrm.reloadData()
        })
        optionMenu.addAction(checkAction)
        
//        let updateAction = UIAlertAction(title: "Update All Check Status", style: .default, handler: {
//            (action: UIAlertAction!) -> Void in
//            
//            
//        })
//        optionMenu.addAction(cancelAction)
        
        self.tableCheckItrm.reloadData()
        present(optionMenu, animated: true, completion: nil)
    }
    //----------------------------------------------
    
//------------------------------------------------------------------------------------------------------
}


extension ARViewController: ARSCNViewDelegate {
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        DispatchQueue.main.async {
            guard let imageAnchor = anchor as? ARImageAnchor,
                let imageName = imageAnchor.referenceImage.name else { return }
            
            // TODO: Comment out code
            let planeNode = self.getPlaneNode(withReferenceImage: imageAnchor.referenceImage)
            planeNode.opacity = 0.0
            planeNode.eulerAngles.x = -.pi / 2
            //                        planeNode.runAction(self.fadeAction)
            node.addChildNode(planeNode)
            
            // TODO: Overlay 3D Object
            let overlayNode = self.getNode(withImageName: imageName)
            overlayNode.opacity = 0
            overlayNode.runAction(self.fadeAction)
            node.addChildNode(overlayNode)
            
            //self.label.text = "Image detected: \"\(imageName)\""
        }
    }
    
    func getPlaneNode(withReferenceImage image: ARReferenceImage) -> SCNNode {
        let plane = SCNPlane(width: image.physicalSize.width,
                             height: image.physicalSize.height)
        let node = SCNNode(geometry: plane)
        return node
    }
    
    func getNode(withImageName name: String) -> SCNNode {
        var node = SCNNode()
        switch name {
        case "column":
            node = ColumnNode
            currentNode = ColumnNode
            //DataPicker()
        default:
            break
        }
        return node
    }
    
    func addBox() {
        
        let box = SCNBox(width: 0.1, height: 0.1, length: 0.1, chamferRadius: 0)
        
        let boxNode = SCNNode()
        boxNode.geometry = box
        boxNode.position = SCNVector3(0, 0, -0.2)
        
        let scene = SCNScene()
        scene.rootNode.addChildNode(boxNode)
        sceneView.scene = scene
        
    }
    
}
