//
//  GoLiveViewController.swift
//  TeacherStream
//
//  Created by dimi anat on 2020/7/4.
//  Copyright © 2020 geniusandcourage. All rights reserved.
//

import UIKit
import Alamofire
import Toast_Swift
import SwiftyJSON

//Defined a constant that holds the URL for our web service
let URL_USER_REGISTER = "https://server IP:500/signup"
let URL_USER_LOGIN = "https://server IP:500/login"

enum AMLoginSignupViewMode {
    case login
    case signup
}

class LogRegViewController: UIViewController {
    
    
    let animationDuration = 0.25
    var mode:AMLoginSignupViewMode = .signup
    
    
    //MARK: - background image constraints
    @IBOutlet weak var backImageLeftConstraint: NSLayoutConstraint!
    @IBOutlet weak var backImageBottomConstraint: NSLayoutConstraint!
    
    
    //MARK: - login views and constrains
    @IBOutlet weak var loginView: UIView!
    @IBOutlet weak var loginContentView: UIView!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var loginButtonVerticalCenterConstraint: NSLayoutConstraint!
    @IBOutlet weak var loginButtonTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var loginWidthConstraint: NSLayoutConstraint!
    
    
    //MARK: - signup views and constrains
    @IBOutlet weak var signupView: UIView!
    @IBOutlet weak var signupContentView: UIView!
    @IBOutlet weak var signupButton: UIButton!
    @IBOutlet weak var signupButtonVerticalCenterConstraint: NSLayoutConstraint!
    @IBOutlet weak var signupButtonTopConstraint: NSLayoutConstraint!
    
    
    //MARK: - logo and constrains
    @IBOutlet weak var logoView: UIView!
    @IBOutlet weak var logoTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var logoHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var logoBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var logoButtomInSingupConstraint: NSLayoutConstraint!
    @IBOutlet weak var logoCenterConstraint: NSLayoutConstraint!
   
    
//    @IBOutlet weak var forgotPassTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var socialsView: UIView!
    
    
    //MARK: - input views
    @IBOutlet weak var loginEmailInputView: AMInputView!
    @IBOutlet weak var loginPasswordInputView: AMInputView!
    @IBOutlet weak var signupEmailInputView: AMInputView!
    @IBOutlet weak var signupPasswordInputView: AMInputView!
    @IBOutlet weak var signupPasswordConfirmInputView: AMInputView!
    
    
    
    //MARK: - controller
    override func viewDidLoad() {
        super.viewDidLoad()
    
        // set view to login mode
        toggleViewMode(animated: false)
        
        //add keyboard notification
         NotificationCenter.default.addObserver(self, selector: #selector(keyboarFrameChange(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: - load login screen
    func loadLoginScreen(){
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let logRegViewController = storyBoard.instantiateViewController(withIdentifier: "logReg") as! LogRegViewController
        logRegViewController.modalPresentationStyle = .fullScreen
        self.present(logRegViewController, animated: true, completion: nil)
    }
    
    //MARK: - load my live screen
    func loadHomeScreen(){
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let navigationController = storyBoard.instantiateViewController(withIdentifier: "nvc") as! NavigationController
        navigationController.modalPresentationStyle = .fullScreen
        
        UserDefaults.standard.setIsLoggedIn(value: true)
        
        self.present(navigationController, animated: true, completion: nil)
    }
    
    func createFile() {
        let fileName = "loginJSON"
        let documentDirURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        let fileURL = documentDirURL.appendingPathComponent(fileName).appendingPathExtension("txt")
        print("File PAth: \(fileURL.path)")
    }
 
    
    //MARK: - button actions
    @IBAction func loginButtonTouchUpInside(_ sender: AnyObject) {
   
        if mode == .signup {
             toggleViewMode(animated: true)
        
        }else{
        
            //TODO: login by this data
//            NSLog("Email:\(loginEmailInputView.textFieldView.text) Password:\(loginPasswordInputView.textFieldView.text)")
            
            guard let myString = loginEmailInputView.textFieldView.text, !myString.isEmpty else {
                print("Email is nil or empty.")
                self.view.makeToast("Missing required field(s)", duration: 3.0, position: .center)
                return // or break, continue, throw
            }
            guard let myString2 = loginPasswordInputView.textFieldView.text, !myString2.isEmpty else {
                print("Password is nil or empty.")
                self.view.makeToast("Missing required field(s)", duration: 3.0, position: .center)
                return // or break, continue, throw
            }
            
            //creating parameters for the post request
            let parameters: Parameters=[
                "email":loginEmailInputView.textFieldView.text!,
                "password":loginPasswordInputView.textFieldView.text!
            ]
            
            let sv = UIViewController.displaySpinner(onView: self.view)
            AF.request(URL_USER_LOGIN, method: .post, parameters: parameters).responseJSON
                            {
                                response in

                                switch response.result {
                                case .success(let value):
                                    debugPrint(value)
                                    let json = JSON(value)
                                    debugPrint(json)
                                    // authenticate success
                                    if let mysqlRes = json["message"].string {
                                        debugPrint(mysqlRes)
                                        if mysqlRes == "Login successful." {
                                            
                                            let em = json["data"].arrayValue.map{$0["email"].stringValue}
                                            let pass = json["data"].arrayValue.map{$0["password"].stringValue}
                                            let nm = json["data"].arrayValue.map{$0["name"].stringValue}
                                            // save log user name and password to user defaults
                                            UserDefaults.standard.setLogCreds(logEmail: em[0], logPassword: pass[0], logUsername: nm[0], logUsernameString: "\(nm[0]) is on ")
                                            
                                            self.view.makeToast("Good to go!", duration: 3.0, position: .center, image: UIImage(imageLiteralResourceName: "smile"))
                                            // navigate to broadcaster
                                            self.loadHomeScreen()
                                            UIViewController.removeSpinner(spinner: sv)
                                        }
                                    }
                                    // authenticate failure
                                    if let mysqlRes = json["message"].string {
                                        debugPrint(mysqlRes)
                                        if mysqlRes == "Wrong Credentials." {
                                            self.view.makeToast("Password incorrect", duration: 3.0, position: .center, image: UIImage(imageLiteralResourceName: "sad"))
                                            self.loginEmailInputView.textFieldView.text = ""
                                            self.loginPasswordInputView.textFieldView.text = ""
                                            UIViewController.removeSpinner(spinner: sv)
                                        }
                                    }
                                    // user not found
                                    if let mysqlRes = json["message"].string {
                                        debugPrint(mysqlRes)
                                        if mysqlRes == "User does not exists" {
                                            self.view.makeToast("User not found", duration: 3.0, position: .center, image: UIImage(imageLiteralResourceName: "sad"))
                                            self.loginEmailInputView.textFieldView.text = ""
                                            self.loginPasswordInputView.textFieldView.text = ""
                                            UIViewController.removeSpinner(spinner: sv)
                                        }
                                    }

                                case .failure(let error):
                                    debugPrint(error)
                                    let json = JSON(error)
                                    if !json["message"].exists() {
                                        debugPrint("json object EMPTY")
                                        self.view.makeToast("Oops ... Network issue!", duration: 3.0, position: .center, image: UIImage(imageLiteralResourceName: "frown"))
                                        UIViewController.removeSpinner(spinner: sv)
                                    } else {
                                        debugPrint("json object NOT empty")
                                    }
                                }
                            }
        }
    }
    
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    public func isValidPassword(_ pass: String) -> Bool {
        let passwordRegex = "^(?=.*\\d)(?=.*[a-z])(?=.*[A-Z])[0-9a-zA-Z!@#$%^&*()\\-_=+{}|?>.<,:;~`’]{8,}$"
//        let passwordRegex = "(?:(?:(?=.*?[0-9])(?=.*?[-!@#$%&*ˆ+=_])|(?:(?=.*?[0-9])|(?=.*?[A-Z])|(?=.*?[-!@#$%&*ˆ+=_])))|(?=.*?[a-z])(?=.*?[0-9])(?=.*?[-!@#$%&*ˆ+=_]))[A-Za-z0-9-!@#$%&*ˆ+=_]{6,15}"
        return NSPredicate(format: "SELF MATCHES %@", passwordRegex).evaluate(with: pass)
    }
    
    @IBAction func signupButtonTouchUpInside(_ sender: AnyObject) {
   
        if mode == .login {
            toggleViewMode(animated: true)
        }else{
                 
            // Check for empty fields
            guard let myString = signupEmailInputView.textFieldView.text, !myString.isEmpty else {
                print("Email is nil or empty.")
                self.view.makeToast("Missing required field(s)", duration: 3.0, position: .center)
                return // or break, continue, throw
            }
            guard let myString2 = signupPasswordInputView.textFieldView.text, !myString2.isEmpty else {
                print("Password is nil or empty.")
                self.view.makeToast("Missing required field(s)", duration: 3.0, position: .center)
                return // or break, continue, throw
            }
            guard let myString3 = signupPasswordConfirmInputView.textFieldView.text, !myString3.isEmpty else {
                print("Username is nil or empty.")
                self.view.makeToast("Missing required field(s)", duration: 3.0, position: .center)
                return // or break, continue, throw
            }
            
            
            //creating parameters for the post request
            let parameters: Parameters=[
                "email":signupEmailInputView.textFieldView.text!,
                "password":signupPasswordInputView.textFieldView.text!,
                "username": signupPasswordConfirmInputView.textFieldView.text!
            ]
            
            if isValidEmail(signupEmailInputView.textFieldView.text!) {
                
                if isValidPassword(signupPasswordInputView.textFieldView.text!) {

            let sv = UIViewController.displaySpinner(onView: self.view)
                AF.request(URL_USER_REGISTER, method: .post, parameters: parameters).responseJSON
                {
                    response in

                    switch response.result {
                    case .success(let value):
                        debugPrint(value)
                        let json = JSON(value)
                        // user register success
                        if let mysqlRes = json["message"].string {
                            debugPrint(mysqlRes)
                            if mysqlRes == "Your account has been created successfully" {
                                self.view.makeToast("Way to go!", duration: 3.0, position: .center, image: UIImage(imageLiteralResourceName: "smile"))
                                self.signupEmailInputView.textFieldView.text = ""
                                self.signupPasswordInputView.textFieldView.text = ""
                                self.signupPasswordConfirmInputView.textFieldView.text = ""
                                self.toggleViewMode(animated: true)
                                UIViewController.removeSpinner(spinner: sv)
                            }
                        }
                        // user exists
                        if let mysqlRes = json["message"].string {
                            debugPrint(mysqlRes)
                            if mysqlRes == "User Exists" {
                                self.view.makeToast("User already exists!", duration: 3.0, position: .center, image: UIImage(imageLiteralResourceName: "sad"))
                                self.signupEmailInputView.textFieldView.text = ""
                                self.signupPasswordInputView.textFieldView.text = ""
                                self.signupPasswordConfirmInputView.textFieldView.text = ""
                                UIViewController.removeSpinner(spinner: sv)
                            }
                        }
                        
                    case .failure(let error):
                        debugPrint(error)
                        let json = JSON(error)
                        if !json["message"].exists() {
                            debugPrint("json object EMPTY")
                            self.view.makeToast("Oops ... Network issue!", duration: 3.0, position: .center, image: UIImage(imageLiteralResourceName: "frown"))
                            UIViewController.removeSpinner(spinner: sv)
                        } else {
                            debugPrint("json object NOT empty")
                        }
                    }
                    
                }
                } else {
                    self.view.makeToast("Password: Min 8 characters with at least a capital letter and a number", duration: 3.0, position: .center, image: UIImage(imageLiteralResourceName: "frown"))
                }
            
            } else {
                self.view.makeToast("Email Invalid!", duration: 3.0, position: .center, image: UIImage(imageLiteralResourceName: "frown"))
            }
        }
            
    }
    
    
    
    //MARK: - toggle view
    func toggleViewMode(animated:Bool){
    
        // toggle mode
        mode = mode == .login ? .signup:.login
        
        
        // set constraints changes
        backImageLeftConstraint.constant = mode == .login ? 0:-self.view.frame.size.width
        
        
        loginWidthConstraint.isActive = mode == .signup ? true:false
        logoCenterConstraint.constant = (mode == .login ? -1:1) * (loginWidthConstraint.multiplier * self.view.frame.size.width)/2
//        loginButtonVerticalCenterConstraint.priority = UILayoutPriority(rawValue: RawValue(mode == .login ? 300:900))
//        signupButtonVerticalCenterConstraint.priority = UILayoutPriority(rawValue: RawValue(mode == .signup ? 300:900))
        
        loginButtonVerticalCenterConstraint.priority = UILayoutPriority(rawValue: mode == .login ? 300:900)
        signupButtonVerticalCenterConstraint.priority = UILayoutPriority(rawValue: mode == .signup ? 300:900)
        
        
        //animate
        self.view.endEditing(true)
        
        UIView.animate(withDuration:animated ? animationDuration:0) {
            
            //animate constraints
            self.view.layoutIfNeeded()
            
            //hide or show views
            self.loginContentView.alpha = self.mode == .login ? 1:0
            self.signupContentView.alpha = self.mode == .signup ? 1:0
            
            
            // rotate and scale login button
            let scaleLogin:CGFloat = self.mode == .login ? 1:0.4
            let rotateAngleLogin:CGFloat = self.mode == .login ? 0:CGFloat(-Double.pi/2)
            
            var transformLogin = CGAffineTransform(scaleX: scaleLogin, y: scaleLogin)
            transformLogin = transformLogin.rotated(by: rotateAngleLogin)
            self.loginButton.transform = transformLogin
            
            
            // rotate and scale signup button
            let scaleSignup:CGFloat = self.mode == .signup ? 1:0.4
            let rotateAngleSignup:CGFloat = self.mode == .signup ? 0:CGFloat(-Double.pi/2)
            
            var transformSignup = CGAffineTransform(scaleX: scaleSignup, y: scaleSignup)
            transformSignup = transformSignup.rotated(by: rotateAngleSignup)
            self.signupButton.transform = transformSignup
        }
        
    }
    
    
    //MARK: - keyboard
    @objc func keyboarFrameChange(notification:NSNotification){
        
        let userInfo = notification.userInfo as! [String:AnyObject]
        
        // get top of keyboard in view
        let topOfKetboard = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue .origin.y
        
        
        // get animation curve for animate view like keyboard animation
        var animationDuration:TimeInterval = 0.25
        var animationCurve:UIView.AnimationCurve = .easeOut
        if let animDuration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber {
            animationDuration = animDuration.doubleValue
        }
        
        if let animCurve = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber {
            animationCurve =  UIView.AnimationCurve.init(rawValue: animCurve.intValue)!
        }
        
        
        // check keyboard is showing
        let keyboardShow = topOfKetboard != self.view.frame.size.height
        
        
        //hide logo in little devices
        let hideLogo = self.view.frame.size.height < 667
        
        // set constraints
        backImageBottomConstraint.constant = self.view.frame.size.height - topOfKetboard
        
        logoTopConstraint.constant = keyboardShow ? (hideLogo ? 0:20):50
        logoHeightConstraint.constant = keyboardShow ? (hideLogo ? 0:40):60
        logoBottomConstraint.constant = keyboardShow ? 20:32
        logoButtomInSingupConstraint.constant = keyboardShow ? 20:32
        
//        forgotPassTopConstraint.constant = keyboardShow ? 30:45
        
        loginButtonTopConstraint.constant = keyboardShow ? 25:30
        signupButtonTopConstraint.constant = keyboardShow ? 23:35
        
        loginButton.alpha = keyboardShow ? 1:0.7
        signupButton.alpha = keyboardShow ? 1:0.7
        
        
        
        // animate constraints changes
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationDuration(animationDuration)
        UIView.setAnimationCurve(animationCurve)
        
        self.view.layoutIfNeeded()
        
        UIView.commitAnimations()
        
    }
    
    //MARK: - hide status bar in swift3
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}

extension UIViewController {
 class func displaySpinner(onView : UIView) -> UIView {
     let spinnerView = UIView.init(frame: onView.bounds)
     spinnerView.backgroundColor = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
    let ai = UIActivityIndicatorView.init(style: .whiteLarge)
     ai.startAnimating()
     ai.center = spinnerView.center

     DispatchQueue.main.async {
         spinnerView.addSubview(ai)
         onView.addSubview(spinnerView)
     }

     return spinnerView
 }

 class func removeSpinner(spinner :UIView) {
     DispatchQueue.main.async {
         spinner.removeFromSuperview()
     }
 }
}


