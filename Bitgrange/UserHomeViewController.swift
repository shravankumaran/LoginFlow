//
//  HomeViewController.swift
//  Bitgrange
//
//  Created by Shravan K on 4/28/18.
//  Copyright © 2018 Bitgrange. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class UserHomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func handleLogout(_ sender:Any) {
        try! Auth.auth().signOut()
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        
        let resultViewController = storyBoard.instantiateViewController(withIdentifier: "HomeStory") as! MainViewController
        
        self.present(resultViewController, animated:true, completion:nil)
    }

}
