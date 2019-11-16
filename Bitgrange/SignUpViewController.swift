//
//  SignUpViewController.swift
//  Bitgrange
//
//  Created by Shravan K on 4/28/18.
//  Copyright © 2018 Bitgrange. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class SignUpViewController: UIViewController, UITextFieldDelegate {


    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var nameField: UITextField!
    
    var signUpButton:WhiteButton!
    var activityView:UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addVerticalGradientLayer(topColor: primaryColor, bottomColor: secondaryColor)
        
        signUpButton = WhiteButton(frame: CGRect(x: 0, y: 0, width: 200, height: 50))
        signUpButton.setTitleColor(secondaryColor, for: .normal)
        signUpButton.setTitle("Sign In", for: .normal)
        signUpButton.titleLabel?.font = UIFont.systemFont(ofSize: 18.0, weight: UIFont.Weight.bold)
        signUpButton.center = CGPoint(x: view.center.x, y: view.frame.height - signUpButton.frame.height - 24)
        signUpButton.highlightedColor = UIColor(white: 1.0, alpha: 1.0)
        signUpButton.defaultColor = UIColor.white
        signUpButton.addTarget(self, action: #selector(handleSignUp), for: .touchUpInside)
        
        view.addSubview(signUpButton)
        setButton(enabled: false)
        
        activityView = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        activityView.color = secondaryColor
        activityView.frame = CGRect(x: 0, y: 0, width: 50.0, height: 50.0)
        activityView.center = signUpButton.center
        
        view.addSubview(activityView)
        
        nameField.delegate = self
        emailField.delegate = self
        passwordField.delegate = self
        
        nameField.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        emailField.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        passwordField.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        // Do any additional setup after loading the view.
    }
 
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        nameField.becomeFirstResponder()
        NotificationCenter.default.addObserver(self, selector:#selector(keyboardWillAppear), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        nameField.resignFirstResponder()
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
     Adjusts the center of the **continueButton** above the keyboard.
     - Parameter notification: Contains the keyboardFrame info.
     */
    
    @objc func keyboardWillAppear(notification: NSNotification){
        
        let info = notification.userInfo!
        let keyboardFrame: CGRect = (info[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        
        signUpButton.center = CGPoint(x: view.center.x,
                                        y: view.frame.height - keyboardFrame.height - 16.0 - signUpButton.frame.height / 2)
        activityView.center = signUpButton.center
    }
    
    /**
     Enables the continue button if the **username**, **email**, and **password** fields are all non-empty.
     
     - Parameter target: The targeted **UITextField**.
     */
    
    @objc func textFieldChanged(_ target:UITextField) {
        let username = nameField.text
        let email = emailField.text
        let password = passwordField.text
        let formFilled = username != nil && username != "" && email != nil && email != "" && password != nil && password != ""
        setButton(enabled: formFilled)
    }
    
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        // Resigns the target textField and assigns the next textField in the form.
        
        switch textField {
        case nameField:
            nameField.resignFirstResponder()
            emailField.becomeFirstResponder()
            break
        case emailField:
            emailField.resignFirstResponder()
            passwordField.becomeFirstResponder()
            break
        case passwordField:
            handleSignUp()
            break
        default:
            break
        }
        return true
    }
    
    /**
     Enables or Disables the **continueButton**.
     */
    
    func setButton(enabled:Bool) {
        if enabled {
            signUpButton.alpha = 1.0
            signUpButton.isEnabled = true
        } else {
            signUpButton.alpha = 0.5
            signUpButton.isEnabled = false
        }
    }
    
    
    @objc func handleSignUp() {
        guard let username = nameField.text else { return }
        guard let email = emailField.text else { return }
        guard let pass = passwordField.text else { return }
        
        setButton(enabled: false)
        signUpButton.setTitle("", for: .normal)
        activityView.startAnimating()
        
        Auth.auth().createUser(withEmail: email, password: pass) { user, error in
            if error == nil && user != nil {
                print("User created!")
                
                let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
                changeRequest?.displayName = username
                
                changeRequest?.commitChanges { error in
                    if error == nil {
                        print("User display name changed!")
                        self.performSegue(withIdentifier: "toTabSignUp", sender: self)
                    } else {
                        print("Error: \(error!.localizedDescription)")
                    }
                }
                
            } else {
                print("Error: \(error!.localizedDescription)")
                print("Error logging in: \(error!.localizedDescription)")
                // create the alert
                let alert = UIAlertController(title: "Failed To SignUp", message: "Error Signing Up in: \(error!.localizedDescription)" , preferredStyle: UIAlertControllerStyle.alert)
                // add an action (button)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                // show the alert
                self.present(alert, animated: true, completion: nil)
                self.activityView.stopAnimating()
                self.signUpButton.setTitle("Sign Up", for: .normal)
                self.setButton(enabled: true)
            }
        }
        
    }
}
