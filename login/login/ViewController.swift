//
//  ViewController.swift
//  login
//
//  Created by Kai on 2018/12/9.
//  Copyright © 2018 AppCode. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    //The login script url make sure to write the ip instead of localhost
    //you can get the ip using ifconfig command in terminal
    let URL_USER_LOGIN = "http://140.118.5.33/xampp/login.php"
    
    //the defaultvalues to store user data
    let defaultValues = UserDefaults.standard
    
    private var permission:String = ""
    
    
    
    @IBOutlet weak var labelMessage: UILabel!
    @IBOutlet weak var textFieldUserName: UITextField!
    @IBOutlet weak var textFieldPassword: UITextField!
    @IBAction func buttonLogin(_ sender: UIButton) {
        userLogin()
    }
    
    func userLogin(){
        
        //URL
        var request = URLRequest(url: URL(string: "http://140.118.5.33/xampp/login.php")!)
        
        //Method
        request.httpMethod = "POST"
        
        //Parameters
        let postString = "username=\(textFieldUserName.text!)&password=\(textFieldPassword.text!)"
        request.httpBody = postString.data(using: .utf8)
        
        //Http request
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return
            }
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
            if let responseJSON = responseJSON as? [String: Any] {
                print(responseJSON["user"])
                if let user = responseJSON["user"] as? NSDictionary {
                    let userId = user["UserId"] as! Int
                    let userName = user["UserName"] as! String
                    let userSecurity = user["UserSecurity"] as! String
                    let userMail = user["UserMail"] as! String
                    
                    
                    self.permission = user["UserName"] as! String
                    //change label text
                    OperationQueue.main.addOperation {
                        self.labelMessage.text = self.permission + " Login!!"
                    }
                }else{
                    OperationQueue.main.addOperation {
                        self.labelMessage.text = "Login failed"
                    }
                }
            }
            
            
        }
        task.resume()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //hiding the navigation button
        let backButton = UIBarButtonItem(title: "", style: UIBarButtonItem.Style.plain, target: navigationController, action: nil)
        navigationItem.leftBarButtonItem = backButton
        
        // Do any additional setup after loading the view, typically from a nib.
        
        //if user is already logged in switching to profile screen
//        if defaultValues.string(forKey: "username") != nil{
//            let profileViewController = self.storyboard?.instantiateViewController(withIdentifier: "ProfileViewcontroller") as! ProfileViewController
//            self.navigationController?.pushViewController(profileViewController, animated: true)
//
//        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

