//
//  ViewController.swift
//  AR-417-Simulation
//
//  Created by Kai on 2019/6/2.
//  Copyright © 2019 AppCode. All rights reserved.
//

import UIKit
import ARKit
import Foundation


class ARViewController: UIViewController, UINavigationControllerDelegate {

    // 場景宣告
    @IBOutlet weak var sceneView: ARSCNView!
    var saveSceneView: ARSCNView!
    
    // 圖像辨識參數
    let fadeDuration: TimeInterval = 1
    let rotateDuration: TimeInterval = 3
    let waitDuration: TimeInterval = 3600
    
    // 模型
    private var currentNode: SCNNode?
    private var currentElectromechanicalNode: SCNNode?
    private var currentFurnitureNode: SCNNode?
    private var currentStructNode: SCNNode?
    
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
            let node = scene.rootNode.childNode(withName: "417-0622-orig", recursively: false) else { return SCNNode() }
        return node
    }()
    lazy var ElectromechanicalNode: SCNNode = {
        guard let scene = SCNScene(named: "417.scn"),
            let node = scene.rootNode.childNode(withName: "Electromechanical", recursively: false) else { return SCNNode() }
        return node
    }()
    lazy var FurnitureNode: SCNNode = {
        guard let scene = SCNScene(named: "417.scn"),
            let node = scene.rootNode.childNode(withName: "Furniture", recursively: false) else { return SCNNode() }
        return node
    }()
    lazy var StructNode: SCNNode = {
        guard let scene = SCNScene(named: "417.scn"),
            let node = scene.rootNode.childNode(withName: "Struct", recursively: false) else { return SCNNode() }
        return node
    }()
    
    // 模型工程進度物件
    var workSchedules: [WorkSchedule] = []
    var workSchedules_origin: [WorkSchedule] = []
    
    //--------------------------------------場景載入點＿1
    override func viewDidLoad() {
        super.viewDidLoad()
        sceneView.delegate = self
        sceneView.autoenablesDefaultLighting = true
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
    @IBAction func btn_downLoadData(_ sender: Any) {
        APIService.getModelSchedule(userCompletionHandler: { workSchedules, error in
            if let workSchedules = workSchedules {
                self.workSchedules = workSchedules
            }
        })
//        let txtbtn = APIService.fetchUser(userCompletionHandler: { error in
//            return responseData
//        })
    }
    
    @IBAction func btn_test(_ sender: Any) {
        for node in currentNode!.childNodes{
            print(node.key)
            print(node.actionKeys)
        }
    }
    
    
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
            
            // TODO: Overlay 3D Object, Main, Electromechanical,
            let overlayMainNode = self.getNode(withImageName: imageName, type: "MainModel")
            overlayMainNode.opacity = 0
            overlayMainNode.runAction(self.fadeAction)
            node.addChildNode(overlayMainNode)
            
            let overlayElectromechanicalNode = self.getNode(withImageName: imageName, type: "ElectromechanicalModel")
            overlayElectromechanicalNode.opacity = 0
            overlayElectromechanicalNode.runAction(self.fadeAction)
            node.addChildNode(overlayElectromechanicalNode)
            
            let overlayFurnitureNode = self.getNode(withImageName: imageName, type: "Furniture")
            overlayFurnitureNode.opacity = 0
            overlayFurnitureNode.runAction(self.fadeAction)
            node.addChildNode(overlayFurnitureNode)
            
            let overlayStructNode = self.getNode(withImageName: imageName, type: "Struct")
            overlayStructNode.opacity = 0
            overlayStructNode.runAction(self.fadeAction)
            node.addChildNode(overlayStructNode)
            
            //self.label.text = "Image detected: \"\(imageName)\""
        }
    }
    
    func getPlaneNode(withReferenceImage image: ARReferenceImage) -> SCNNode {
        let plane = SCNPlane(width: image.physicalSize.width,
                             height: image.physicalSize.height)
        let node = SCNNode(geometry: plane)
        return node
    }
    
    func getNode(withImageName name: String, type: String) -> SCNNode {
        var node = SCNNode()
        switch name {
        case "column":
            switch type {
            case "MainModel":
                node = ColumnNode
                currentNode = ColumnNode
                break
            case "ElectromechanicalModel":
                node = ElectromechanicalNode
                currentElectromechanicalNode = ElectromechanicalNode
                currentElectromechanicalNode?.isHidden = true
                break
            case "Furniture":
                node = FurnitureNode
                currentFurnitureNode = FurnitureNode
                currentFurnitureNode?.isHidden = true
                break
            case "Struct":
                node = StructNode
                currentStructNode = StructNode
                currentStructNode?.isHidden = true
                break
            default:
                break
            }
            break
        default:
            break
        }
        return node
    }
    
}
