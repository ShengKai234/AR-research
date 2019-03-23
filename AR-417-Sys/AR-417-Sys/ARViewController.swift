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


class ARViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    @IBOutlet weak var sceneView: ARSCNView!
    var saveSceneView: ARSCNView!
    
    @IBOutlet weak var permisonLabel: UILabel!
    @IBOutlet weak var ObjInfoView: UIView!
    
    let fadeDuration: TimeInterval = 1
    let rotateDuration: TimeInterval = 3
    let waitDuration: TimeInterval = 3600
    private var currentNode: SCNNode?
    var user = User(username: "", userid: 0, usersecurity: "",  usermail: "")
    var workSchedules: [WorkSchedule] = []
    var workSchedules_origin: [WorkSchedule] = []
    var modelType = "123"
    
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
        
        for workSchedule in self.workSchedules
        {
            let boxDateStart = formatter.date(from: workSchedule.startDate)
            let boxDateEnd = formatter.date(from: workSchedule.endDate)
            //if boxDateStart later sender(select Date())
            if(now.compare(boxDateStart!) == .orderedAscending && workSchedule.isStart == "0")
            {
                currentNode?.childNode(withName: workSchedule.modelName, recursively: false)?.isHidden = false
                currentNode?.childNode(withName: workSchedule.modelName, recursively: false)?.geometry?.firstMaterial?.diffuse.contents = UIColor.blue
                currentNode?.childNode(withName: workSchedule.modelName, recursively: false)?.geometry?.firstMaterial?.emission.contents = UIColor.blue
                if (sender.date < (boxDateStart!)) {
                    currentNode?.childNode(withName: workSchedule.modelName, recursively: false)?.isHidden = true
                }
                //else if sender(select Date()) later boxDateStart and is check
            }else if(workSchedule.isCheck == "1" && workSchedule.isStart == "1"){
                currentNode?.childNode(withName: workSchedule.modelName, recursively: false)?.isHidden = false
                currentNode?.childNode(withName: workSchedule.modelName, recursively: false)?.geometry?.firstMaterial?.diffuse.contents = UIColor.green
                currentNode?.childNode(withName: workSchedule.modelName, recursively: false)?.geometry?.firstMaterial?.emission.contents = UIColor.green
                //else if sender(select Date()) later boxDateStart and is start doing
            }else if((workSchedule.isStart == "1" && sender.date.compare(boxDateEnd!) == .orderedAscending) || (workSchedule.isStart == "1" && sender.date.compare(boxDateEnd!) == .orderedSame)){
                currentNode?.childNode(withName: workSchedule.modelName, recursively: false)?.isHidden = false
                currentNode?.childNode(withName: workSchedule.modelName, recursively: false)?.geometry?.firstMaterial?.diffuse.contents = UIColor.yellow
                currentNode?.childNode(withName: workSchedule.modelName, recursively: false)?.geometry?.firstMaterial?.emission.contents = UIColor.yellow
                //else sender(select Date()) later boxDateStart and is start doing and sender later boxDateEnd
            }else{
                currentNode?.childNode(withName: workSchedule.modelName, recursively: false)?.isHidden = false
                currentNode?.childNode(withName: workSchedule.modelName, recursively: false)?.geometry?.firstMaterial?.diffuse.contents = UIColor.red
                currentNode?.childNode(withName: workSchedule.modelName, recursively: false)?.geometry?.firstMaterial?.emission.contents = UIColor.red
            }
        }
    }
    
//---------------------------------操作DB撈取模型資訊-----------------------------------------
    func getObjDate()
    {
        self.workSchedules.removeAll()
        for objJSON in self.objJSONArray
        {
            if let objJSON = objJSON as? [String: Any]
            {
                //print(objJSON)
                self.workSchedules.append(WorkSchedule(id: objJSON["Id"] as! String,
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
        if (modelType=="origin"){
            self.workSchedules_origin = self.workSchedules
        }
        formatter.dateFormat = "yyyy/MM/dd"
        //        label_time.text = formatter.string(from: sender.date)
        
        for workSchedule in self.workSchedules
        {
            let boxDateStart = formatter.date(from: workSchedule.startDate)
            var boxDateEnd = formatter.date(from: workSchedule.endDate)
            boxDateEnd = Calendar.current.date(byAdding: .day, value: 1, to: boxDateEnd!)
//            print(boxDateEnd)
            //if boxDateStart later sender(select Date())
            currentNode?.childNode(withName: workSchedule.modelName, recursively: false)?.geometry?.firstMaterial?.transparency = 0.5
            if(now.compare(boxDateStart!) == .orderedAscending && workSchedule.isStart == "0")
            {
                currentNode?.childNode(withName: workSchedule.modelName, recursively: false)?.isHidden = false
                currentNode?.childNode(withName: workSchedule.modelName, recursively: false)?.geometry?.firstMaterial?.diffuse.contents = UIColor.blue
                currentNode?.childNode(withName: workSchedule.modelName, recursively: false)?.geometry?.firstMaterial?.emission.contents = UIColor.blue
                if (now.compare(boxDateStart!) == .orderedAscending) {
                    currentNode?.childNode(withName: workSchedule.modelName, recursively: false)?.isHidden = true
                }
                //else if sender(select Date()) later boxDateStart and is check
            }else if(workSchedule.isCheck == "1" && workSchedule.isStart == "1"){
                currentNode?.childNode(withName: workSchedule.modelName, recursively: false)?.isHidden = false
                currentNode?.childNode(withName: workSchedule.modelName, recursively: false)?.geometry?.firstMaterial?.diffuse.contents = UIColor.green
                currentNode?.childNode(withName: workSchedule.modelName, recursively: false)?.geometry?.firstMaterial?.emission.contents = UIColor.green
                //else if sender(select Date()) later boxDateStart and is start doing
            }else if((workSchedule.isStart == "1" && now.compare(boxDateEnd!) == .orderedAscending) || (workSchedule.isStart == "1" && now.compare(boxDateEnd!) == .orderedSame)){
                currentNode?.childNode(withName: workSchedule.modelName, recursively: false)?.isHidden = false
                currentNode?.childNode(withName: workSchedule.modelName, recursively: false)?.geometry?.firstMaterial?.diffuse.contents = UIColor.yellow
                currentNode?.childNode(withName: workSchedule.modelName, recursively: false)?.geometry?.firstMaterial?.emission.contents = UIColor.yellow
                //else sender(select Date()) later boxDateStart and is start doing and sender later boxDateEnd
            }else{
                currentNode?.childNode(withName: workSchedule.modelName, recursively: false)?.isHidden = false
                currentNode?.childNode(withName: workSchedule.modelName, recursively: false)?.geometry?.firstMaterial?.diffuse.contents = UIColor.red
                currentNode?.childNode(withName: workSchedule.modelName, recursively: false)?.geometry?.firstMaterial?.emission.contents = UIColor.red
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
    func queryObjInfo_dynamic()
    {
        //URL
        var request = URLRequest(url: URL(string: "http://140.118.5.33/xampp/getObjInfo_dynamic.php")!)
        
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
        self.modelType = "origin"
        queryObjInfo()
    }
    
    @IBAction func getObjInfo_dynamic(_ sender: Any) {
        self.modelType = "dynamic"
        queryObjInfo_dynamic()
    }
    
    
    @IBAction func btnTakePhoto(_ sender: Any) {
        
        

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
    
//-----------------------------------------------------------------------------------------------------

//Obj Info View----------------------------------------------------------------------------------------
    var ObjInfo: WorkSchedule = WorkSchedule(id: "", scheduleId: "", projectName: "", startDate: "", endDate: "", progress: "", superItem: "", duration: "", superModelGroupId: "", modelName: "", groupId: "", isStart: "", isCheck: "", checkTypeNo: "", superCheckNo: "")
    
    //受影響工項
    var effects:[String] = [String]()
    
    @IBAction func btnVewClose(_ sender: Any) {
        ObjInfoView.isHidden=true
        self.ObjInfo = WorkSchedule(id: "", scheduleId: "", projectName: "", startDate: "", endDate: "", progress: "", superItem: "", duration: "", superModelGroupId: "", modelName: "", groupId: "", isStart: "", isCheck: "", checkTypeNo: "", superCheckNo: "")
    }
    
    
    @IBOutlet weak var labelModelType: UILabel!
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
    
    //開啟相簿--------------------------------------------------------------------------------------------------------------
    @IBAction func btnSelectPhoto(_ sender: UIButton) {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        
        //設定顯示模式
        imagePicker.modalPresentationStyle = .popover
        let popover = imagePicker.popoverPresentationController
        //設定popover視窗與哪一個view元件關聯
        popover?.sourceView = sender
        
        //popoverㄐ的箭頭位置
        popover?.sourceRect = sender.bounds
        popover?.permittedArrowDirections = .any
        
        show(imagePicker, sender: self)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any])
    {
        let selectImage = info[.originalImage] as? UIImage
        
        print(selectImage as Any)
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
        var i = 0
        for workSchedule in self.workSchedules
        {
            if (selectNode?.name == workSchedule.modelName)
            {
                ObjInfo = workSchedule
                if (self.modelType == "origin"){
                    self.labelModelType.text = "原始進度"
                }else if (self.modelType == "dynamic"){
                    self.labelModelType.text = "動態進度"
                    //與原計劃時間比較
                    let boxDateEnd = formatter.date(from: workSchedules_origin[i].endDate)
                    print("__________123" + workSchedules_origin[i].endDate)
                    if (boxDateEnd!.compare(now) == .orderedAscending && workSchedule.isCheck=="0"){
                        let alertController = UIAlertController(title: "AR系统提示",
                                                                message: "該工項已經延遲於預定計畫！！", preferredStyle: .alert)
                        let okAction = UIAlertAction(title: "確定", style: .default, handler: {
                            action in
                        })
                        alertController.addAction(okAction)
                        self.present(alertController, animated: true, completion: nil)
                    }
                }
                
                self.ObjName.text = ObjInfo.modelName
                fieldStartDate.text = ObjInfo.startDate
                fieldEndDate.text = ObjInfo.endDate
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
                for effectSchedule in self.workSchedules{
                    if workSchedule.id == effectSchedule.superItem && !(self.effects.contains(effectSchedule.id)){
                        self.effects.append(effectSchedule.id)
                    }
                    if effectSchedule.id == workSchedule.id{
                        allCountSingle+=1
                        if effectSchedule.isCheck=="1"{
                            CountSingleCheck+=1
                        }
                    }
                    if effectSchedule.isCheck=="1"{
                        allCountCheck+=1
                    }
                }
                for effect in self.effects{
                    for effectSchedule in self.workSchedules{
                        if effectSchedule.id==effect{
                            for other_effectSchedule in self.workSchedules{
                                if effectSchedule.id == other_effectSchedule.superItem && !(self.effects.contains(other_effectSchedule.id)){
                                    print (other_effectSchedule.id)
                                    self.effects.append(other_effectSchedule.id)
                                }
                            }
                        }
                    }
                }
                progressSingle.progress = Float(CountSingleCheck/allCountSingle)
                progressAll.progress = Float(allCountCheck/Float(self.workSchedules.count))
                effectItem.text = self.effects.joined(separator:",")
                
                break
            }else{
                ObjName.text = "Nothing"
            }
            i+=1
        }
    }
    
    //---------------------------模型資訊上傳、更新------------------------
    @IBAction func btnUpdateInfo(_ sender: Any) {
        updateInfo()
    }
    func updateInfo(){
        
        //URL
        var request = URLRequest(url: URL(string: "http://140.118.5.33/xampp/updateCheckStatus_origin.php")!)
        
        //Method
        request.httpMethod = "POST"
        //print(self.ObjInfo.objname)
        //print(self.ObjInfo.isStart)
        //print(self.ObjInfo.isCheck)
        //Parameters
        let postString = "isStart=\(String(self.ObjInfo.isStart))&isCheck=\(String(self.ObjInfo.isCheck))&id=\(String(self.ObjInfo.scheduleId))"
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
        for workSchedule in self.workSchedules{
            for effect in self.effects
            {
                if effect == workSchedule.id
                {
                    currentNode?.childNode(withName: workSchedule.modelName, recursively: false)?.isHidden = false
                    currentNode?.childNode(withName: workSchedule.modelName, recursively: false)?.geometry?.firstMaterial?.diffuse.contents = UIColor.orange
                    currentNode?.childNode(withName: workSchedule.modelName, recursively: false)?.geometry?.firstMaterial?.emission.contents = UIColor.orange
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
                    currentNode?.childNode(withName: workSchedule.modelName, recursively: false)?.isHidden = false
                    currentNode?.childNode(withName: workSchedule.modelName, recursively: false)?.geometry?.firstMaterial?.diffuse.contents = UIColor.gray
                    currentNode?.childNode(withName: workSchedule.modelName, recursively: false)?.geometry?.firstMaterial?.emission.contents = UIColor.gray
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
            print (ObjInfo.modelName)
            print (ObjInfo.startDate)
            print (ObjInfo.endDate)
            
            let dateStart = formatter.date(from: ObjInfo.startDate)
            let dateEnd = formatter.date(from: ObjInfo.endDate)
            //時間差計算
            autoFormattedDifference = dateComponentsFormatter.string(from: dateEnd!, to: now)!
            var calculatedDateEnd = Calendar.current.date(byAdding: .day, value: Int((autoFormattedDifference as! NSString).intValue), to: dateEnd!)
            ObjInfo.endDate = formatter.string(from: calculatedDateEnd!)
            print ("Over schedule Day : ")
            print(autoFormattedDifference)
            print(ObjInfo.endDate)
        }
        
        for workSchedule in self.workSchedules{
            for effect in self.effects{
                if effect == workSchedule.id || workSchedule.id == ObjInfo.id
                {
                    print("__________effect Item : " + effect)
                    print("__________origin Start : " + workSchedule.startDate)
                    print("__________origin End : " + workSchedule.endDate)
                    let dateStart = formatter.date(from: workSchedule.startDate)
                    let dateEnd = formatter.date(from: workSchedule.endDate)
                    var calculatedDateStart = Calendar.current.date(byAdding: .day, value: Int((autoFormattedDifference as! NSString).intValue), to: dateStart!)
                    var calculatedDateEnd = Calendar.current.date(byAdding: .day, value: Int((autoFormattedDifference as! NSString).intValue), to: dateEnd!)
                    print(formatter.string(from: calculatedDateStart!))
                    print(formatter.string(from: calculatedDateEnd!))
                    workSchedule.startDate = formatter.string(from: calculatedDateStart!)
                    workSchedule.endDate = formatter.string(from: calculatedDateEnd!)
                }
            }
            
        }
        if(user.usersecurity=="supervision" && self.modelType=="origin"){
            let alertController = UIAlertController(title: "AR系统提示",
                                                    message: "您确定要更新" + self.labelModelType.text! + "嗎？", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
            let okAction = UIAlertAction(title: "更新", style: .default, handler: {
                action in
                self.updateInfo_origin()
            })
            alertController.addAction(cancelAction)
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
            
        }
        else if (user.usersecurity=="engineer" && self.modelType=="dynamic"){
            let alertController = UIAlertController(title: "AR系统提示",
                                                    message: "您确定要更新" + self.labelModelType.text! + "嗎？", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
            let okAction = UIAlertAction(title: "更新", style: .default, handler: {
                action in
                self.updateInfo_dynamic()
            })
            alertController.addAction(cancelAction)
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
            
        }
        
        
    }
    
    func updateInfo_origin(){
        
        var jsons: [String: Any] = [String: Any]()
        var json: [[String: Any]] = [[String: Any]]()
        for workSchedule in self.workSchedules {
            json.append(["Id":workSchedule.superCheckNo ,"StartDate":workSchedule.startDate, "EndDate":workSchedule.endDate])
        }
        jsons["Data"] = json
        print(jsons)
        print("-------------!!")
        //URL
        var request = URLRequest(url: URL(string: "http://140.118.5.33/xampp/updateInfo_origin.php")!)
        
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
                let alertController = UIAlertController(title: "AR系统提示",
                                                        message: "更新完成", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "確認", style: .default, handler: {
                    action in
                })
                alertController.addAction(okAction)
                self.present(alertController, animated: true, completion: nil)
//                self.queryObjInfo()
            }
        }
        task.resume()
    }
    
    func updateInfo_dynamic(){
        
        var jsons: [String: Any] = [String: Any]()
        var json: [[String: Any]] = [[String: Any]]()
        for workSchedule in self.workSchedules {
            json.append(["Id":workSchedule.id ,"StartDate":workSchedule.startDate, "EndDate":workSchedule.endDate])
        }
        jsons["Data"] = json
        print(jsons)
        print("-------------!!")
        //URL
        var request = URLRequest(url: URL(string: "http://140.118.5.33/xampp/updateInfo_dynamic.php")!)
        
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
                let alertController = UIAlertController(title: "AR系统提示",
                                                        message: "更新完成", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "確認", style: .default, handler: {
                    action in
                })
                alertController.addAction(okAction)
                self.present(alertController, animated: true, completion: nil)
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
        print(self.ObjInfo.checkTypeNo)
        let postString = "checkNameType=\(String(self.ObjInfo.checkTypeNo))"
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
        let optionMenu = UIAlertController(title: nil, message: "請選擇要執行的動作", preferredStyle: .actionSheet)
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
        let photoLibraryAction = UIAlertAction(title: "照片庫", style: .default , handler: {
            (ACTION)in
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
                let imagePicker = UIImagePickerController()
                imagePicker.allowsEditing = false
                imagePicker.sourceType = .photoLibrary
                
                self.present(imagePicker, animated: true, completion: nil)
            }
        })
        optionMenu.addAction(photoLibraryAction)
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
