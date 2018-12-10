//
//  VirtualObjectViewController.swift
//  ARKitDemo
//
//  Created by Kai on 2018/11/10.
//  Copyright © 2018 AppCode. All rights reserved.
//

import UIKit

class VirtualObjectViewController: UIViewController {
    
    @IBOutlet var showName: UILabel!
    @IBOutlet var showdateStart: UILabel!
    @IBOutlet var showdateEnd: UILabel!
    @IBOutlet var showisStart: UILabel!
    @IBOutlet var showisCheck: UILabel!
    @IBOutlet var switchStart: UISwitch!
    @IBOutlet var switchCheck: UISwitch!
    @IBOutlet weak var textStart: UITextField!
    @IBOutlet weak var textEnd: UITextField!
    @IBOutlet weak var progress: UIProgressView!
    @IBOutlet weak var showProgress: UILabel!
    
    var name: String = ""
    var dateStart: String = ""
    var dateEnd: String = ""
    var isCheck: String = ""
    var isStart: String = ""
    var progressCount: Float = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.largeTitleDisplayMode = .never
        showName.text = name
        showdateStart.text = dateStart
        showdateEnd.text = dateEnd
        textStart.text = dateStart
        textEnd.text = dateEnd
        showisStart.text = isStart
        progress.progress = progressCount/10
        showProgress.text = String(100*progressCount/10)+"%"
        if (isStart == "yes")
        {
            switchStart.isOn = true
        }
        showisCheck.text = isCheck
        if (isCheck == "yes")
        {
            switchCheck.isOn = true
        }
        // Do any additional setup after loading the view.
    }

    @IBAction func switchStart(_ sender: UISwitch) {
        if sender.isOn == true {
            isStart = "yes"
            showisStart.text = isStart
        }else{
            isStart = "no"
            showisStart.text = isStart
        }
    }
    
    @IBAction func switchChecl(_ sender: UISwitch) {
        if sender.isOn == true {
            isCheck = "yes"
            showisCheck.text = isCheck
        }else{
            isCheck = "no"
            showisCheck.text = isCheck
        }
    }
   
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
