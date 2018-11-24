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
    let waitDuration: TimeInterval = 100
    var box_1_Info: [String: String] = ["name":"box_1", "dateStart":"2018-11-01", "dateEnd":"2018-11-09", "isStart":"yes", "isCheck":"yes"]
    var box_2_Info: [String: String] = [:]
    var box_3_Info: [String: String] = [:]
    var box_4_Info: [String: String] = [:]
    
    func getData()
    {
       // box_1_Info = ["name":"box_1", "dateStart":"2018-11-01", "dateEnd":"2018-11-09", "isStart":"yes", "isCheck":"yes"]
        box_2_Info = ["name":"box_2", "dateStart":"2018-11-01", "dateEnd":"2018-11-08", "isStart":"yes", "isCheck":"no"]
        box_3_Info = ["name":"box_3", "dateStart":"2018-11-05", "dateEnd":"2018-11-15", "isStart":"yes", "isCheck":"no"]
        box_4_Info = ["name":"box_4", "dateStart":"2018-11-16", "dateEnd":"2018-11-18", "isStart":"no", "isCheck":"no"]
    }
    
    //Date controller
    private var currentNode: SCNNode?
    private var virtualObject: VirtualObject?
    let now:Date = Date()
    let formatter = DateFormatter()
    @IBAction func DataPicker(_ sender: UIDatePicker)
    {
        
        var boxs = [box_1_Info, box_2_Info, box_3_Info, box_4_Info]
        
        formatter.dateFormat = "yyyy/MM/dd"
        label_time.text = formatter.string(from: sender.date)
        
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
        
//        let boxDateline1 = formatter.date(from: box_1_Info["dateStart"]!)
//        //if boxDateline1 older sender(select Date())
//        if  (sender.date.compare(boxDateline1!) == .orderedAscending)
//        {
////            currentNode?.childNode(withName: "box_1", recursively: false)?.isHidden = true
//            currentNode?.childNode(withName: "box_1", recursively: false)?.geometry?.firstMaterial?.diffuse.contents = UIColor.blue
//            currentNode?.childNode(withName: "box_1", recursively: false)?.geometry?.firstMaterial?.emission.contents = UIColor.blue
//        //else if sender(select Date()) older boxDateline1
//        }else if(boxs[0]["ischeck"] == "yes"){
////            currentNode?.childNode(withName: "box_1", recursively: false)?.isHidden = false
//            currentNode?.childNode(withName: "box_1", recursively: false)?.geometry?.firstMaterial?.diffuse.contents = UIColor.green
//            currentNode?.childNode(withName: "box_1", recursively: false)?.geometry?.firstMaterial?.emission.contents = UIColor.green
//        }else{
//            //            currentNode?.childNode(withName: "box_1", recursively: false)?.isHidden = false
//            currentNode?.childNode(withName: "box_1", recursively: false)?.geometry?.firstMaterial?.diffuse.contents = UIColor.red
//            currentNode?.childNode(withName: "box_1", recursively: false)?.geometry?.firstMaterial?.emission.contents = UIColor.red
//        }
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
            .fadeIn(duration: fadeDuration),
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

    lazy var ShipNode: SCNNode = {
        guard let scene = SCNScene(named: "ship.scn"),
            let node = scene.rootNode.childNode(withName: "ship", recursively: false) else { return SCNNode() }
        let scaleFactor  = 0.5
        node.scale = SCNVector3(scaleFactor, scaleFactor, scaleFactor)
        node.eulerAngles.x += -.pi / 2
        return node
    }()
    
    lazy var MountainNode: SCNNode = {
        guard let scene = SCNScene(named: "mountain.scn"),
            let node = scene.rootNode.childNode(withName: "mountain", recursively: false) else { return SCNNode() }
        let scaleFactor  = 0.25
        node.scale = SCNVector3(scaleFactor, scaleFactor, scaleFactor)
        node.eulerAngles.x += -.pi / 2
        return node
    }()
    
    lazy var BoxNode: SCNNode = {
        let box = SCNBox(width: 0.1, height: 0.1, length: 0.1, chamferRadius: 0)
        let boxNode = SCNNode()
        boxNode.geometry = box
        
        return boxNode
    }()
    
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
        
    }
    //------------------------------------------------

    
    //--------------------------------------點擊事件，刪除物件
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
        var boxs = [box_1_Info, box_2_Info, box_3_Info, box_4_Info]
        if segue.identifier == "ShowObjInfo" {
            let destinationController = segue.destination as! VirtualObjectViewController
            for box in boxs
            {
                if (selectNode?.name == box["name"]!)
                {
                    destinationController.name = (box["name"]!)
                    destinationController.dateStart = (box["dateStart"]!)
                    destinationController.dateEnd = (box["dateEnd"]!)
                    destinationController.isStart = (box["isStart"]!)
                    destinationController.isCheck = (box["isCheck"]!)
                }
            }
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
                        planeNode.runAction(self.fadeAction)
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
        case "Snow Mountain":
            node = MountainNode
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

