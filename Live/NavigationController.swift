//
//  NavigationController.swift
//  Slowmo
//
//  Created by dimi anat on 20/6/1.
//  Copyright © 2020年 com.geniusandcourage. All rights reserved.
//

import UIKit

class NavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if isLoggedIn() {
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let homeViewController = storyBoard.instantiateViewController(withIdentifier: "homeVC") as! HomeViewController
            homeViewController.modalPresentationStyle = .fullScreen
            viewControllers = [homeViewController]
        } else {
            perform(#selector(showLoginViewController), with: nil, afterDelay: 0.01)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
    
    //MARK: - iS Logged In Method
    fileprivate func isLoggedIn() -> Bool {
        
        return UserDefaults.standard.isLoggedIn()
    }
    
    @objc func showLoginViewController() {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let logRegViewController = storyBoard.instantiateViewController(withIdentifier: "logReg") as! LogRegViewController
        logRegViewController.modalPresentationStyle = .fullScreen
        present(logRegViewController, animated: true, completion: {
            // perhaps we'll do something here later
        })
        
    }

}
