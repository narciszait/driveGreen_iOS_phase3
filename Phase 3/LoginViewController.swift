//
//  ViewController.swift
//  Phase 1
//
//  Created by Narcis Zait on 04/02/2019.
//  Copyright © 2019 Narcis Zait. All rights reserved.
//

import UIKit
import GoogleMaps
import Alamofire

class LoginViewController: UIViewController {
    
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }
    
    @IBAction func loginAction(_ sender: Any) {
        if (emailTextField.text == "") || (passwordTextField.text == "") {
            self.showAlerts(title: "Error", message: "Username and/or password cannot be empty");
        }
        
        if (passwordTextField.text != "" && (emailTextField.text?.contains("@drivegreen.com") != false)) {
            guard let email = emailTextField.text, let password = passwordTextField.text else { return }
            let basicAuthString = "\(email):\(password)"
            
            AF.request("https://driveg.vapor.cloud/api/users/login", method: .post, parameters: nil, encoding: JSONEncoding.default, headers: ["Content-Type":"application/json; charset=utf-8",
                                                                                                                                               "Authorization":"Basic \(basicAuthString.toBase64())"])
                .validate(statusCode: 200..<300)
                .responseJSON { response in
                    if (response.error == nil) {
                        if let returnedData = try? JSONDecoder().decode(LoginResponseData.self, from: response.data!) {
                            UserDefaults.standard.set(returnedData.token, forKey: "token")
                            self.performSegue(withIdentifier: "loginSegue", sender: nil)
                        }
                    }
                    else {
                        debugPrint("HTTP Request failed: \(response.error)")
                    }
            }
        } else {
            self.showAlerts(title: "Error", message: "Wrong username and/or password");
        }
    }
}

extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailTextField {
            textField.resignFirstResponder()
            passwordTextField.becomeFirstResponder()
        } else if textField == passwordTextField {
            textField.resignFirstResponder()
        }
        
        return true
    }
    
    func showAlerts(title: String, message: String) {
        let alert = UIAlertController(title: "\(title)", message: "\(message)", preferredStyle: UIAlertController.Style.alert);
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil));
        self.present(alert, animated: true, completion: nil);
    }
}

