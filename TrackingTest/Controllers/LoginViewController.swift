//
//  LoginViewController.swift
//  TrackingTest
//
//  Created by fahmex on 27/01/2019.
//  Copyright © 2019 fahmi. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class LoginViewController: UIViewController {

    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func login(_ sender: Any) {
        let url = "http://\(AppDelegate.url)/users/findUser"
        
        let parametres = [
            "name": self.username.text!,
            "password":self.password.text!
        ]
        
        Alamofire.request(url, method: .post, parameters: parametres, encoding: JSONEncoding.default, headers: nil)
            .validate(statusCode: 200..<300)
            .responseJSON { response in
                
                switch response.result{
                case .failure(let error):
                    print(error)
                case .success(let value):
                    let json = JSON(value)
                    let id = json[0]["idUser"].int
                    let username = json[0]["name"].string
                    let password = json[0]["password"].string
                    if (json[0]["name"] != JSON.null){
                        let currentuser = User(id: String(id!), name: username!, password: password!)
                        AppDelegate.currentUser = currentuser
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "tabBarId") as! UITabBarController
                        self.present(vc, animated: true, completion: nil)
                    }else{
                        let alert = UIAlertController(title: "Wrong datas", message: "Verify your data", preferredStyle: UIAlertController.Style.alert)
                        alert.addAction(UIAlertAction(title: "Retry", style: UIAlertAction.Style.default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                    }
                }
        }
    }
}
