//
//  ProfileViewController.swift
//  login
//
//  Created by Kai on 2018/12/9.
//  Copyright © 2018 AppCode. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    
    
    //label again don't copy instead connect
    @IBOutlet weak var labelUserName: UILabel!
    
    //button
    @IBAction func buttonLogout(_ sender: UIButton) {
        
        //removing values from default
        UserDefaults.standard.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
        UserDefaults.standard.synchronize()
        
        //switching to login screen
        let loginViewController = self.storyboard?.instantiateViewController(withIdentifier: "ViewController") as! ViewController
        self.navigationController?.pushViewController(loginViewController, animated: true)
        self.dismiss(animated: false, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //hiding back button
        let backButton = UIBarButtonItem(title: "", style: UIBarButtonItem.Style.plain, target: navigationController, action: nil)
        navigationItem.leftBarButtonItem = backButton
        
        //getting user data from defaults
        let defaultValues = UserDefaults.standard
        if let name = defaultValues.string(forKey: "username"){
            //setting the name to label
            labelUserName.text = name
        }else{
            //send back to login view controller
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
