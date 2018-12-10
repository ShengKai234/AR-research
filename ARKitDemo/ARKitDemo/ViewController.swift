//
//  ViewController.swift
//  SpaceShipMuseum
//
//  Created by Brian Advent on 09.06.18.
//  Copyright © 2018 Brian Advent. All rights reserved.
//
import UIKit
import ARKit
import CoreLocation

let uuidString = "B0702880-A295-A8AB-F734-031A98A512DE"
let identifier = "kCBAdvDataAppleBeaconKey"

class ViewController: UIViewController, CLLocationManagerDelegate  {
    
    let locationManager = CLLocationManager()
    
    @IBOutlet weak var sceneView: ARSCNView!
    @IBOutlet weak var label: UILabel!
    
    @IBOutlet var btn_pDate: UIButton!
    @IBOutlet var time_manager: UISlider!
    @IBOutlet var label_time: UILabel!
   
    @IBOutlet weak var beaconInformationLabel: UILabel!
    
    @IBOutlet weak var stateLabel: UILabel!
    //--------------------------------------------3D 物件初始化設定--------------------------------------------------------------//
    //--------------------------------------虛擬物件建立於場景中時間控制
    let fadeDuration: TimeInterval = 1
    let rotateDuration: TimeInterval = 3
    let waitDuration: TimeInterval = 3600
    var plane: [String: String] = [:]
    var wall_1: [String: String] = [:]
    var wall_2: [String: String] = [:]
    var wall_3: [String: String] = [:]
    var wall_4: [String: String] = [:]
    var column_1: [String: String] = [:]
    var column_2: [String: String] = [:]
    var column_3: [String: String] = [:]
    var column_4: [String: String] = [:]
    var plane_top: [String: String] = [:]
    var reinforce: [String: String] = [:]
    var falsework: [String: String] = [:]
    
    
    //var boxs = [box_1_Info, box_2_Info, box_3_Info, box_4_Info]
    func getData()
    {
        plane = ["name":"plane", "dateStart":"2018-11-17", "dateEnd":"2018-11-20", "isStart":"yes", "isCheck":"yes"]
        
        reinforce = ["name":"reinforce", "dateStart":"2018-11-20", "dateEnd":"2018-11-22", "isStart":"yes", "isCheck":"yes"]
        column_1 = ["name":"column-1", "dateStart":"2018-11-22", "dateEnd":"2018-11-25", "isStart":"yes", "isCheck":"no"]
        column_2 = ["name":"column-2", "dateStart":"2018-11-22", "dateEnd":"2018-11-25", "isStart":"yes", "isCheck":"no"]
        column_3 = ["name":"column-3", "dateStart":"2018-11-22", "dateEnd":"2018-11-25", "isStart":"yes", "isCheck":"no"]
        column_4 = ["name":"column-4", "dateStart":"2018-11-22", "dateEnd":"2018-11-25", "isStart":"yes", "isCheck":"no"]
        wall_1 = ["name":"wall-1", "dateStart":"2018-11-25", "dateEnd":"2018-11-28", "isStart":"no", "isCheck":"no"]
        wall_2 = ["name":"wall-2", "dateStart":"2018-11-25", "dateEnd":"2018-11-28", "isStart":"no", "isCheck":"no"]
        wall_3 = ["name":"wall-3", "dateStart":"2018-11-25", "dateEnd":"2018-11-28", "isStart":"no", "isCheck":"no"]
        wall_4 = ["name":"wall-4", "dateStart":"2018-11-25", "dateEnd":"2018-11-28", "isStart":"no", "isCheck":"no"]
        plane_top = ["name":"plane-top", "dateStart":"2018-11-30", "dateEnd":"2018-12-1", "isStart":"no", "isCheck":"no"]
    }
    func updateDate()
    {
        
    }
    
    //Date controller
    private var currentNode: SCNNode?
    private var virtualObject: VirtualObject?
    let now:Date = Date()
    let formatter = DateFormatter()
    @IBAction func DataPicker(_ sender: UIDatePicker)
    {
        
        var boxs = [plane, wall_1, wall_2, wall_3, wall_4, reinforce, column_1, column_2, column_3, column_4, plane_top]
        
        formatter.dateFormat = "yyyy/MM/dd"
//        label_time.text = formatter.string(from: sender.date)
        
        for box in boxs
        {
            let boxDateStart = formatter.date(from: box["dateStart"]!)
            let boxDateEnd = formatter.date(from: box["dateEnd"]!)
            //if boxDateStart later sender(select Date())
            if  (now.compare(boxDateStart!) == .orderedAscending && box["isStart"] == "no")
            {
                currentNode?.childNode(withName: box["name"]!, recursively: false)?.isHidden = false
                currentNode?.childNode(withName: box["name"]!, recursively: false)?.geometry?.firstMaterial?.diffuse.contents = UIColor.blue
                currentNode?.childNode(withName: box["name"]!, recursively: false)?.geometry?.firstMaterial?.emission.contents = UIColor.blue
                if (sender.date < (boxDateStart!)) {
                    currentNode?.childNode(withName: box["name"]!, recursively: false)?.isHidden = true
                }
                //else if sender(select Date()) later boxDateStart and is check
            }else if(box["isCheck"] == "yes" && box["isStart"] == "yes"){
                currentNode?.childNode(withName: box["name"]!, recursively: false)?.isHidden = false
                currentNode?.childNode(withName: box["name"]!, recursively: false)?.geometry?.firstMaterial?.diffuse.contents = UIColor.green
                currentNode?.childNode(withName: box["name"]!, recursively: false)?.geometry?.firstMaterial?.emission.contents = UIColor.green
                //else if sender(select Date()) later boxDateStart and is start doing
            }else if((box["isStart"] == "yes" && sender.date.compare(boxDateEnd!) == .orderedAscending) || (box["isStart"] == "yes" && sender.date.compare(boxDateEnd!) == .orderedSame)){
                currentNode?.childNode(withName: box["name"]!, recursively: false)?.isHidden = false
                currentNode?.childNode(withName: box["name"]!, recursively: false)?.geometry?.firstMaterial?.diffuse.contents = UIColor.yellow
                currentNode?.childNode(withName: box["name"]!, recursively: false)?.geometry?.firstMaterial?.emission.contents = UIColor.yellow
                //else sender(select Date()) later boxDateStart and is start doing and sender later boxDateEnd
            }else{
                currentNode?.childNode(withName: box["name"]!, recursively: false)?.isHidden = false
                currentNode?.childNode(withName: box["name"]!, recursively: false)?.geometry?.firstMaterial?.diffuse.contents = UIColor.red
                currentNode?.childNode(withName: box["name"]!, recursively: false)?.geometry?.firstMaterial?.emission.contents = UIColor.red
            }
        }
    }
    
    func DataPicker()
    {
        
        var boxs = [plane, wall_1, wall_2, wall_3, wall_4,reinforce, column_1, column_2, column_3, column_4, plane_top]
        let sender = now
        formatter.dateFormat = "yyyy/MM/dd"
        //        label_time.text = formatter.string(from: sender.date)
        
        for box in boxs
        {
            let boxDateStart = formatter.date(from: box["dateStart"]!)
            let boxDateEnd = formatter.date(from: box["dateEnd"]!)
            //if boxDateStart later sender(select Date())
            if  (now.compare(boxDateStart!) == .orderedAscending && box["isStart"] == "no")
            {
                currentNode?.childNode(withName: box["name"]!, recursively: false)?.isHidden = false
                currentNode?.childNode(withName: box["name"]!, recursively: false)?.geometry?.firstMaterial?.diffuse.contents = UIColor.blue
                currentNode?.childNode(withName: box["name"]!, recursively: false)?.geometry?.firstMaterial?.emission.contents = UIColor.blue
                if (sender < (boxDateStart!)) {
                    currentNode?.childNode(withName: box["name"]!, recursively: false)?.isHidden = true
                }
                //else if sender(select Date()) later boxDateStart and is check
            }else if(box["isCheck"] == "yes" && box["isStart"] == "yes"){
                currentNode?.childNode(withName: box["name"]!, recursively: false)?.isHidden = false
                currentNode?.childNode(withName: box["name"]!, recursively: false)?.geometry?.firstMaterial?.diffuse.contents = UIColor.green
                currentNode?.childNode(withName: box["name"]!, recursively: false)?.geometry?.firstMaterial?.emission.contents = UIColor.green
                //else if sender(select Date()) later boxDateStart and is start doing
            }else if((box["isStart"] == "yes" && sender.compare(boxDateEnd!) == .orderedAscending) || (box["isStart"] == "yes" && sender.compare(boxDateEnd!) == .orderedSame)){
                currentNode?.childNode(withName: box["name"]!, recursively: false)?.isHidden = false
                currentNode?.childNode(withName: box["name"]!, recursively: false)?.geometry?.firstMaterial?.diffuse.contents = UIColor.yellow
                currentNode?.childNode(withName: box["name"]!, recursively: false)?.geometry?.firstMaterial?.emission.contents = UIColor.yellow
                //else sender(select Date()) later boxDateStart and is start doing and sender later boxDateEnd
            }else{
                currentNode?.childNode(withName: box["name"]!, recursively: false)?.isHidden = false
                currentNode?.childNode(withName: box["name"]!, recursively: false)?.geometry?.firstMaterial?.diffuse.contents = UIColor.red
                currentNode?.childNode(withName: box["name"]!, recursively: false)?.geometry?.firstMaterial?.emission.contents = UIColor.red
            }
        }
        
    }
    
    
    @IBAction func TimeController(_ sender: UISlider) {
//        label_time.text = String(sender.value)
        if (sender.value > 0.3){
            currentNode?.childNode(withName: "reinforce", recursively: false)?.isHidden = false
            currentNode?.childNode(withName: "reinforce", recursively: false)?.geometry?.firstMaterial?.normal.contents = UIColor.red
            currentNode?.childNode(withName: "reinforce", recursively: false)?.geometry?.firstMaterial?.diffuse.contents = UIColor.red
            currentNode?.childNode(withName: "reinforce", recursively: false)?.geometry?.firstMaterial?.emission.contents = UIColor.red
        }else
        {
            currentNode?.childNode(withName: "reinforce", recursively: false)?.isHidden = true
        }
        if (sender.value > 0.5){
            currentNode?.childNode(withName: "concrete", recursively: false)?.isHidden = false
        }else
        {
            currentNode?.childNode(withName: "concrete", recursively: false)?.isHidden = true
        }
        
        if (sender.value > 0.6){
            currentNode?.childNode(withName: "reinforce_2", recursively: false)?.isHidden = false
        }else
        {
            currentNode?.childNode(withName: "reinforce_2", recursively: false)?.isHidden = true
        }
        if (sender.value > 0.7){
            currentNode?.childNode(withName: "concrete_2", recursively: false)?.isHidden = false
        }else
        {
            currentNode?.childNode(withName: "concrete_2", recursively: false)?.isHidden = true
        }
    }
    
    lazy var fadeAndSpinAction: SCNAction = {
        return .sequence([
            //.fadeIn(duration: fadeDuration),
//            .rotateBy(x: 0, y: 0, z: CGFloat.pi * 360 / 180, duration: rotateDuration)
            
            ])
    }()
    
    lazy var fadeAction: SCNAction = {
        return .sequence([
            .fadeOpacity(by: 0.8, duration: fadeDuration),
            .wait(duration: waitDuration),
            .fadeOut(duration: fadeDuration)
            ])
    }()
    
    //--------------------------------------物件建立於場景的初始化，以及影像辨識對應的物件
    lazy var ColumnNode: SCNNode = {
        guard let scene = SCNScene(named: "cube.scn"),
            let node = scene.rootNode.childNode(withName: "box_node", recursively: false) else { return SCNNode() }
        return node
    }()

    //--------------------------------------場景加載（1）
    override func viewDidLoad() {
        super.viewDidLoad()
        sceneView.delegate = self
        sceneView.autoenablesDefaultLighting = true
//        configureLighting()
        addTapGestureToSceneView()
        getData()
        locationManager.delegate = self
        
        if CLLocationManager.isMonitoringAvailable(for: CLBeaconRegion.self){
            if CLLocationManager.authorizationStatus() != CLAuthorizationStatus.authorizedAlways{
                locationManager.requestAlwaysAuthorization()
            }
        }
    }
        //場景加載（2）
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        resetTrackingCongiguration()
    }
        //場景加載（3）
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        sceneView.session.pause()
    }
    //------------------------------------------------

    
    //--------------------------------------光線設定
    func configureLighting() {
        sceneView.autoenablesDefaultLighting = true
        sceneView.automaticallyUpdatesLighting = true
    }
    //------------------------------------------------
    
    //--------------------------------------重置按鈕呼叫方法
    @IBAction func resetButtonDidTouch(_ sender: UIBarButtonItem) {
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
        label.text = "Move Camera around tp detect images"
        DataPicker()
        
    }
    //------------------------------------------------

    
    //--------------------------------------點擊事件，參數傳遞
    private var selectNode: SCNNode?
    func addTapGestureToSceneView()
    {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ViewController.didTap(withGestureRecognizer:)))
        sceneView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc func didTap(withGestureRecognizer recognizer: UIGestureRecognizer)
    {
        let tapLocation = recognizer.location(in: sceneView)
        let hitTestResults = sceneView.hitTest(tapLocation)
        guard let node = hitTestResults.first?.node else { return }
        selectNode = node
        performSegue(withIdentifier: "ShowObjInfo", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        var boxs = [plane, wall_1, wall_2, wall_3, wall_4,reinforce, column_1, column_2, column_3, column_4, plane_top]
        if segue.identifier == "ShowObjInfo" {
            let destinationController = segue.destination as! VirtualObjectViewController
            var progressCount: Float = 0
            for box in boxs
            {
                if (box["isCheck"] == "yes") {
                   progressCount += 1.0
                }
            }
            for box in boxs
            {
                if (selectNode?.name == box["name"]!)
                {
                    destinationController.name = (box["name"]!)
                    destinationController.dateStart = (box["dateStart"]!)
                    destinationController.dateEnd = (box["dateEnd"]!)
                    destinationController.isStart = (box["isStart"]!)
                    destinationController.isCheck = (box["isCheck"]!)
                    destinationController.progressCount = progressCount
                    print (box)
                    break
                }
            }
        }
    }
    
    //------------------------------------------------
    
    //回傳---------------------------------------------
    
    @IBAction func unwind (for segue: UIStoryboardSegue, sender: Any?)
    {
        var boxs = [plane, wall_1, wall_2, wall_3, wall_4,reinforce, column_1, column_2, column_3, column_4, plane_top]
        let destinationController = segue.source as! VirtualObjectViewController
        if segue.identifier == "updateInfo" {
            
            print(destinationController.name)
            print(plane["name"]!)
            if destinationController.name == plane["name"]!{
                plane["dateStart"]! = destinationController.dateStart
                plane["dateEnd"]! = destinationController.dateEnd
                plane["isStart"]! = destinationController.isStart
                plane["isCheck"]! = destinationController.isCheck
                print("success")
            }
            if destinationController.name == wall_1["name"]!{
                wall_1["dateStart"]! = destinationController.textStart.text!
                wall_1["dateEnd"]! = destinationController.textEnd.text!
                wall_1["isStart"]! = destinationController.isStart
                wall_1["isCheck"]! = destinationController.isCheck
                print("success")
            }
            if destinationController.name == wall_2["name"]!{
                wall_2["dateStart"]! = destinationController.dateStart
                wall_2["dateEnd"]! = destinationController.dateEnd
                wall_2["isStart"]! = destinationController.isStart
                wall_2["isCheck"]! = destinationController.isCheck
                print("success")
            }
            if destinationController.name == wall_3["name"]!{
                wall_3["dateStart"]! = destinationController.dateStart
                wall_3["dateEnd"]! = destinationController.dateEnd
                wall_3["isStart"]! = destinationController.isStart
                wall_3["isCheck"]! = destinationController.isCheck
                print("success")
            }
            if destinationController.name == wall_4["name"]!{
                wall_4["dateStart"]! = destinationController.dateStart
                wall_4["dateEnd"]! = destinationController.dateEnd
                wall_4["isStart"]! = destinationController.isStart
                wall_4["isCheck"]! = destinationController.isCheck
                print("success")
            }
            if destinationController.name == reinforce["name"]!{
                reinforce["dateStart"]! = destinationController.dateStart
                reinforce["dateEnd"]! = destinationController.dateEnd
                reinforce["isStart"]! = destinationController.isStart
                reinforce["isCheck"]! = destinationController.isCheck
                print("success")
            }
            if destinationController.name == column_1["name"]!{
                column_1["dateStart"]! = destinationController.dateStart
                column_1["dateEnd"]! = destinationController.dateEnd
                column_1["isStart"]! = destinationController.isStart
                column_1["isCheck"]! = destinationController.isCheck
                print("success")
            }
            if destinationController.name == column_2["name"]!{
                column_2["dateStart"]! = destinationController.dateStart
                column_2["dateEnd"]! = destinationController.dateEnd
                column_2["isStart"]! = destinationController.isStart
                column_2["isCheck"]! = destinationController.isCheck
                print("success")
            }
            if destinationController.name == column_3["name"]!{
                column_3["dateStart"]! = destinationController.dateStart
                column_3["dateEnd"]! = destinationController.dateEnd
                column_3["isStart"]! = destinationController.isStart
                column_3["isCheck"]! = destinationController.isCheck
                print("success")
            }
            if destinationController.name == column_4["name"]!{
                column_4["dateStart"]! = destinationController.dateStart
                column_4["dateEnd"]! = destinationController.dateEnd
                column_4["isStart"]! = destinationController.isStart
                column_4["isCheck"]! = destinationController.isCheck
                print("success")
            }
            if destinationController.name == plane_top["name"]!{
                plane_top["dateStart"]! = destinationController.dateStart
                plane_top["dateEnd"]! = destinationController.dateEnd
                plane_top["isStart"]! = destinationController.isStart
                plane_top["isCheck"]! = destinationController.isCheck
                print("success")
            }
            
//            for var box in boxs
//            {
//                if (destinationController.name == box["name"]!)
//                {
//                    box["dateStart"] = destinationController.dateStart
//                    box["dateEnd"] = destinationController.dateEnd
//                    box["isStart"] = destinationController.isStart
//                    box["isCheck"] = "no"
//
//                }
//            }
        }
    }
    
    //------------------------------------------------
    
    
    
    //Beacon -----------------------------------------
    @IBAction func monitorIBeacon(_ sender: UIButton) {
        
        if sender.currentTitle == "搜尋"{
            registerBeaconRegionWithUUID(uuidString: uuidString, identifier: identifier, isMonitor: true)
            sender.setTitle("暫停", for: .normal)
        }else{
            sender.setTitle("搜尋", for: .normal)
            registerBeaconRegionWithUUID(uuidString: uuidString, identifier: identifier, isMonitor: false)
        }
    }
    
    func registerBeaconRegionWithUUID(uuidString: String, identifier: String, isMonitor: Bool){
        
        let region = CLBeaconRegion(proximityUUID: UUID(uuidString: uuidString)!, identifier: identifier)
        region.notifyOnEntry = true //預設就是true
        region.notifyOnExit = true //預設就是true
        
        if isMonitor{
            locationManager.startMonitoring(for: region) //建立region後，開始monitor region
        }else{
            locationManager.stopMonitoring(for: region)
            locationManager.stopRangingBeacons(in: region)
            beaconInformationLabel.text = "Beacon狀態"
            stateLabel.text = "是否在region內?"
        }
        
    }
    
    //開始monitor region後，呼叫此delegate函數
    func locationManager(_ manager: CLLocationManager, didStartMonitoringFor region: CLRegion) {
        //To check whether the user is already inside the boundary of a region
        //delivers the results to the location manager’s delegate "didDetermineState"
        manager.requestState(for: region)
    }
    
    //The location manager calls this method whenever there is a boundary transition for a region.
    func locationManager(_ manager: CLLocationManager, didDetermineState state: CLRegionState, for region: CLRegion) {
        if state == CLRegionState.inside{
            if CLLocationManager.isRangingAvailable(){
                manager.startRangingBeacons(in: (region as! CLBeaconRegion))
                stateLabel.text = "已在region中"
            }else{
                print("不支援ranging")
            }
        }else{
            manager.stopRangingBeacons(in: (region as! CLBeaconRegion))
        }
    }
    
    //The location manager calls this method whenever there is a boundary transition for a region.
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        
        if CLLocationManager.isRangingAvailable(){
            manager.startRangingBeacons(in: (region as! CLBeaconRegion))
        }else{
            print("不支援ranging")
        }
        stateLabel.text = "進入region"
    }
    
    //The location manager calls this method whenever there is a boundary transition for a region.
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        manager.stopRangingBeacons(in: (region as! CLBeaconRegion))
        stateLabel.text = "離開region"
    }
    
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        
        if (beacons.count > 0){
            if let nearstBeacon = beacons.first{
                
                var proximity = ""
                switch nearstBeacon.proximity {
                case CLProximity.immediate:
                    proximity = "Very close"
                    
                case CLProximity.near:
                    proximity = "Near"
                    
                case CLProximity.far:
                    proximity = "Far"
                    
                default:
                    proximity = String(beacons.count)
                }
                
                beaconInformationLabel.text = "Proximity: \(proximity)\n Accuracy: \(nearstBeacon.accuracy) meter \n RSSI: \(nearstBeacon.rssi)"
            }
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
    
    
    func locationManager(_ manager: CLLocationManager, monitoringDidFailFor region: CLRegion?, withError error: Error) {
        print(error.localizedDescription)
    }
    
    
    func locationManager(_ manager: CLLocationManager, rangingBeaconsDidFailFor region: CLBeaconRegion, withError error: Error) {
        print(error.localizedDescription)
    }
    //------------------------------------------------
    
}

extension ViewController: ARSCNViewDelegate {
    
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
            
            self.label.text = "Image detected: \"\(imageName)\""
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
            DataPicker()
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

//亮顯動畫
var imageHighlightAction: SCNAction {
    return .sequence([
        .wait(duration: 0.25),
        .fadeOpacity(to: 0.85, duration: 0.25),
        .fadeOpacity(to: 0.15, duration: 0.25),
        .fadeOpacity(to: 0.85, duration: 0.25),
        .fadeOut(duration: 0.5),
        .removeFromParentNode()
        ])
}

