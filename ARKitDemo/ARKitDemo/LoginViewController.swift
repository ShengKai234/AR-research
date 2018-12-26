//
//  LoginViewController.swift
//  ARKitDemo
//
//  Created by Kai on 2018/12/13.
//  Copyright © 2018 AppCode. All rights reserved.
//

import Foundation
import UIKit

class LoginViewController: UIViewController{
    @IBAction func Butt(_ sender: Any) {
        performSegue(withIdentifier: "ARView", sender: nil)

    }
    
}
