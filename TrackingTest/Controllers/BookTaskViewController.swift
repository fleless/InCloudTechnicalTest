//
//  BookTaskViewController.swift
//  TrackingTest
//
//  Created by fahmex on 25/01/2019.
//  Copyright © 2019 fahmi. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class BookTaskViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var hrs: UITextField!
    @IBOutlet weak var mns: UITextField!
    @IBOutlet weak var scs: UITextField!
    @IBOutlet weak var titleEditText: UITextField!
    @IBOutlet weak var saveBtn: UIButton!
    @IBOutlet weak var desc: UITextView!
    @IBOutlet weak var startDateTextField: UITextField!
    @IBOutlet weak var endDateTextField: UITextField!
    
    var editableTiming: Bool! = nil
    var hours: String! = "00"
    var minutes: String! = "00"
    var seconds: String! = "00"
    var startDate: Date! = nil
    var endDate: Date! = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        if(startDate != nil){
        self.startDateTextField.text = formatDate(theDate: self.startDate)
        self.endDateTextField.text = formatDate(theDate: self.endDate)
        }
        self.hrs.text = hours
        self.mns.text = minutes
        self.scs.text = seconds
        if(!editableTiming){
            self.endDateTextField.isEnabled = false
            self.startDateTextField.isEnabled = false
            self.hrs.isEnabled = false
            self.scs.isEnabled = false
            self.mns.isEnabled = false
        }
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.hrs.delegate = self
        self.mns.delegate = self
        self.scs.delegate = self
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = UIDatePicker.Mode.dateAndTime
        datePicker.addTarget(self, action: #selector(self.datePickerValueChanged(sender:)), for: UIControl.Event.valueChanged)
        self.startDateTextField.inputView = datePicker
        self.endDateTextField.inputView = datePicker
    }
    
    @objc func datePickerValueChanged(sender: UIDatePicker){
        if(self.startDateTextField.isEditing){
        self.startDateTextField.text = formatDate(theDate: sender.date)
        }else{
            endDateTextField.text = formatDate(theDate: sender.date)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
        let allowedCharacters = CharacterSet.decimalDigits
        let characterSet = CharacterSet(charactersIn: string)
        if(textField.tag == 101){
            return (allowedCharacters.isSuperset(of: characterSet))
        }else{
        return ((allowedCharacters.isSuperset(of: characterSet))&&(updatedText.count <= 2))
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        //clearOnBeginEditing
        textField.text = ""
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if(textField.text == ""){textField.text = "00"}
        let nbr = Int(textField.text!)
        if((!(0...60 ~= nbr!))&&(textField.tag != 101)){
            textField.text = "00"
        }
        if(textField.text?.count == 1){
            textField.text = "0"+textField.text!
        }
    }
    
    @IBAction func save(_ sender: Any) {
        if(valid()){
            saveTask()
        }else{
            let alert = UIAlertController(title: "Data missing", message: "fill the data", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func formatDate(theDate: Date)-> String{
     let dateFormatter = DateFormatter()
     dateFormatter.dateFormat = "dd/MM/yyyy, H:mm:ss"
     let date = dateFormatter.string(from: theDate)
     return date
     }
    
    func formatStringToDate(theDate: String)-> Date{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy, H:mm:ss"
        let date = dateFormatter.date(from: theDate)
        return date!
    }

    func valid()->Bool{
        if((titleEditText.text != "")&&(desc.text != "")&&(startDateTextField.text != "")&&(endDateTextField.text != "")&&((hrs.text != "00")||(scs.text != "00")||(mns.text != "00"))&&(titleEditText.text != "")){
            return true
        }else{
            return false
        }
    }
    
    func saveTask(){
        let url = "http://\(AppDelegate.url)/tasks"
        let parametres = [
            "description": self.desc.text!,
            "startDate": self.startDateTextField.text!,
            "endDate": self.endDateTextField.text!,
            "time": self.hrs.text!+"H"+self.mns.text!+"M"+self.scs.text!+"S",
            "title": self.titleEditText.text!,
            "idUser": AppDelegate.currentUser?.idUser
        ]
        Alamofire.request(url, method: .post, parameters: parametres, encoding: JSONEncoding.default, headers: nil)
            .validate(statusCode: 200..<300)
            .responseJSON { response in
                print(AppDelegate.currentUser?.idUser)
                switch response.result{
                case .failure(let error):
                    print(error)
                case .success(let _):
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "tabBarId") as! UITabBarController
                    self.present(vc, animated: true, completion: nil)
                }
        }
    }
}
