//
//  RegisterViewController.swift
//  TrackingTest
//
//  Created by fahmex on 27/01/2019.
//  Copyright © 2019 fahmi. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class RegisterViewController: UIViewController {

    @IBOutlet weak var username: UITextField!
        @IBOutlet weak var confirmPassword: UITextField!
        @IBOutlet weak var password: UITextField!
   
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func register(_ sender: Any) {
        if(valid()){
            registerUser()
        }else{
            let alert = UIAlertController(title: "Wrong data", message: "Verify your data", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func valid()->Bool{
        if((confirmPassword.text == password.text)&&(confirmPassword.text != "")&&(username.text != "")){
            return true
        }else{
            return false
        }
    }
    
    func registerUser(){
        let url = "http://\(AppDelegate.url)/users"
        let parametres = [
            "name": username.text!,
            "password": password.text!
            ]
        Alamofire.request(url, method: .post, parameters: parametres, encoding: JSONEncoding.default, headers: nil)
            .validate(statusCode: 200..<300)
            .responseJSON { response in
                
                switch response.result{
                case .failure(let error):
                    print(error)
                case .success(let _):
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "login") as! LoginViewController
                    self.present(vc, animated: true, completion: nil)
                }
        }
    }
}
