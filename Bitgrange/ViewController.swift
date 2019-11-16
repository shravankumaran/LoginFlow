//
//  ViewController.swift
//  Bitgrange
//
//  Created by Shravan K on 2/21/18.
//  Copyright © 2018 Bitgrange. All rights reserved.
//

import UIKit
import Firebase
import Foundation
import FirebaseAuth

class ViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var dismissButton: UIButton!
    
    var LoginButton:WhiteButton!
    var activityView:UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addVerticalGradientLayer(topColor: primaryColor, bottomColor: secondaryColor)
        
        LoginButton = WhiteButton(frame: CGRect(x: 0, y: 0, width: 200, height: 50))
        LoginButton.setTitleColor(secondaryColor, for: .normal)
        LoginButton.setTitle("Continue", for: .normal)
        LoginButton.titleLabel?.font = UIFont.systemFont(ofSize: 18.0, weight: UIFont.Weight.bold)
        LoginButton.center = CGPoint(x: view.center.x, y: view.frame.height - LoginButton.frame.height - 24)
        LoginButton.highlightedColor = UIColor(white: 1.0, alpha: 1.0)
        LoginButton.defaultColor = UIColor.white
        LoginButton.addTarget(self, action: #selector(handleSignIn), for: .touchUpInside)
        LoginButton.alpha = 0.5
        view.addSubview(LoginButton)
        setLoginButton(enabled: false)
        
        activityView = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        activityView.color = secondaryColor
        activityView.frame = CGRect(x: 0, y: 0, width: 50.0, height: 50.0)
        activityView.center = LoginButton.center
        
        view.addSubview(activityView)
        
        emailField.delegate = self
        passwordField.delegate = self
        
        emailField.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        passwordField.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
    }    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        emailField.becomeFirstResponder()
        NotificationCenter.default.addObserver(self, selector:#selector(keyboardWillAppear), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        emailField.resignFirstResponder()
        passwordField.resignFirstResponder()
        NotificationCenter.default.removeObserver(self)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        get {
            return .lightContent
        }
    }
    
    @IBAction func handleDismissButton(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
    
    /**
     Adjusts the center of the **LoginButton** above the keyboard.
     - Parameter notification: Contains the keyboardFrame info.
     */
    
    @objc func keyboardWillAppear(notification: NSNotification){
        
        let info = notification.userInfo!
        let keyboardFrame: CGRect = (info[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        
        LoginButton.center = CGPoint(x: view.center.x,
                                        y: view.frame.height - keyboardFrame.height - 16.0 - LoginButton.frame.height / 2)
        activityView.center = LoginButton.center
    }
    
    /**
     Enables the continue button if the **username**, **email**, and **password** fields are all non-empty.
     
     - Parameter target: The targeted **UITextField**.
     */
    
    @objc func textFieldChanged(_ target:UITextField) {
        let email = emailField.text
        let password = passwordField.text
        let formFilled = email != nil && email != "" && password != nil && password != ""
        setLoginButton(enabled: formFilled)
    }
    
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        // Resigns the target textField and assigns the next textField in the form.
        
        switch textField {
        case emailField:
            emailField.resignFirstResponder()
            passwordField.becomeFirstResponder()
            break
        case passwordField:
            handleSignIn()
            break
        default:
            break
        }
        return true
    }
    
    func setLoginButton(enabled:Bool) {
        if enabled {
            LoginButton.alpha = 1.0
            LoginButton.isEnabled = true
        } else {
            LoginButton.alpha = 0.5
            LoginButton.isEnabled = false
        }
    }
    
    @objc func handleSignIn() {
        guard let email = emailField.text else { return }
        guard let pass = passwordField.text else { return }
        
        setLoginButton(enabled: false)
        LoginButton.setTitle("", for: .normal)
        activityView.startAnimating()
        
        Auth.auth().signIn(withEmail: email, password: pass) { user, error in
            if error == nil && user != nil {
                self.performSegue(withIdentifier: "ToTabBar", sender: self)
                print("User Logged in successful!")
            } else {
                print("Error logging in: \(error!.localizedDescription)")
                // create the alert
                let alert = UIAlertController(title: "Failed To Login", message: "Error logging in: \(error!.localizedDescription) Please Retype the Username and Password whichever is wrong." , preferredStyle: UIAlertControllerStyle.alert)
                // add an action (button)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                // show the alert
                self.present(alert, animated: true, completion: nil)
                self.activityView.stopAnimating()
                self.LoginButton.setTitle("Sign In", for: .normal)
                self.setLoginButton(enabled: true)
            }
        }
    }
}
