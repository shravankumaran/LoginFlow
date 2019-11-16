//
//  MainViewController.swift
//  Bitgrange
//
//  Created by Shravan K on 4/28/18.
//  Copyright © 2018 Bitgrange. All rights reserved.
//

import UIKit
import FirebaseAuth

class MainViewController: UIViewController {

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
  
        view.addVerticalGradientLayer(topColor: primaryColor, bottomColor: secondaryColor)
        Auth.auth().addStateDidChangeListener { auth, user in
            if let user = user {
                self.performSegue(withIdentifier: "UserPage", sender: self)
                print("\(user)")
            } else {
            //User Not logged in
            }
        }
    }

    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        get {
            return .lightContent
        }
    }
}
