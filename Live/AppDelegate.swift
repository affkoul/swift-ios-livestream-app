//
//  AppDelegate.swift
//  Live
//
//  Created by dimi anat on 20/6/1.
//  Copyright © 2020年 com.geniusandcourage. All rights reserved.
//

import UIKit
//import TextAttributes
import SwiftRichString
import IQKeyboardManagerSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    var theHourG = 0;
    var theMinsG = 0;
    var theHourC = 0;
    var theMinsC = 0;


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        setupAppearance()
        
        IQKeyboardManager.shared.enable = true
        
        UserDefaults.standard.setIsBroadCon(value: false)
        UserDefaults.standard.setIsBroadCon(value: false)
        
        return true
    }
    
    fileprivate func setupAppearance() {
        let navigationBar = UINavigationBar.appearance();
        navigationBar.tintColor = UIColor.white
        navigationBar.barTintColor = UIColor.primaryColor()
        navigationBar.isTranslucent = false
        
        let titleAttrs = Style {
            $0.font = SystemFonts.AmericanTypewriter.font(size:CGFloat((navigationBar.frame.size.width / 3) - 20) / 2) // just pass a string, one of the SystemFonts or an UIFont
    //      $0.color = "#0433FF" // you can use UIColor or HEX string!
            $0.color = UIColor.white
            $0.underline = (.patternDot, UIColor.red)
            $0.alignment = .center
            
        }
        navigationBar.titleTextAttributes = titleAttrs.attributes

        let barButtonItem = UIBarButtonItem.appearance()
        let barButtonAttrs = Style {
            $0.font = SystemFonts.AmericanTypewriter.font(size:CGFloat((barButtonItem.width / 3) - 20) / 3) // just pass a string, one of the SystemFonts or an UIFont
    //      $0.color = "#0433FF" // you can use UIColor or HEX string!
            $0.color = UIColor.white
            $0.underline = (.patternDot, UIColor.red)
            $0.alignment = .center
            
        }
        barButtonItem.setTitleTextAttributes(barButtonAttrs.attributes, for: .normal)
        barButtonItem.setTitleTextAttributes(barButtonAttrs.attributes, for: .highlighted)
        
    }


    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
        let date = Date()
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)
        theHourG = hour
        let minutes = calendar.component(.minute, from: date)
        theMinsG = minutes
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
//        if UserDefaults.standard.isAudCon() {
//            SocketIOManager.sharedInstance.closeAudConnection()
//        }
//        
//        if UserDefaults.standard.isBroadCon() {
//            SocketIOManager.sharedInstance.closeBroadConnection()
//        }
        
        let date = Date()
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)
        theHourG = hour
        let minutes = calendar.component(.minute, from: date)
        theMinsG = minutes
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
        
        // take time parameters
        let date = Date()
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)
        theHourC = hour
        let minutes = calendar.component(.minute, from: date)
        theMinsC = minutes
        
        // above 2 mins, ask to re-log
        if theHourC == theHourG && (theMinsC - theMinsG) >= 3 {
            UserDefaults.standard.setIsLoggedIn(value: false)
            debugPrint("Logged Out")
            
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let logRegViewController = storyBoard.instantiateViewController(withIdentifier: "logReg") as! LogRegViewController
            if let navigationController = self.window?.rootViewController as? UINavigationController {
                logRegViewController.modalPresentationStyle = .fullScreen
                navigationController.present(logRegViewController, animated: true) {
                    // might do smth. later
                }
            }
        }
        
        // hour passed, ask to re-log
        if theHourC != theHourG {
            UserDefaults.standard.setIsLoggedIn(value: false)
            debugPrint("Logged Out")
            
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let logRegViewController = storyBoard.instantiateViewController(withIdentifier: "logReg") as! LogRegViewController
            if let navigationController = self.window?.rootViewController as? UINavigationController {
                logRegViewController.modalPresentationStyle = .fullScreen
                navigationController.present(logRegViewController, animated: true) {
                    // might do smth. later
                }
            }
        }
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        
//        if UserDefaults.standard.isAudCon() {
//            SocketIOManager.sharedInstance.establishAudConnection()
//        }
//
//        if UserDefaults.standard.isBroadCon() {
//            SocketIOManager.sharedInstance.establishBroadConnection()
//        }
        
        // take time parameters
        let date = Date()
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)
        theHourC = hour
        let minutes = calendar.component(.minute, from: date)
        theMinsC = minutes
        
        // hour passed, ask to re-log
        if theHourC == theHourG && (theMinsC - theMinsG) >= 3 {
            UserDefaults.standard.setIsLoggedIn(value: false)
            debugPrint("Logged Out")
            
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let logRegViewController = storyBoard.instantiateViewController(withIdentifier: "logReg") as! LogRegViewController
            if let navigationController = self.window?.rootViewController as? UINavigationController {
                logRegViewController.modalPresentationStyle = .fullScreen
                navigationController.present(logRegViewController, animated: true) {
                    // might do smth. later
                }
            }
        }
        
        // hour passed, ask to re-log
        if theHourC != theHourG {
            UserDefaults.standard.setIsLoggedIn(value: false)
            debugPrint("Logged Out")
            
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let logRegViewController = storyBoard.instantiateViewController(withIdentifier: "logReg") as! LogRegViewController
            if let navigationController = self.window?.rootViewController as? UINavigationController {
                logRegViewController.modalPresentationStyle = .fullScreen
                navigationController.present(logRegViewController, animated: true) {
                    // might do smth. later
                }
            }
        }
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        UserDefaults.standard.setIsLoggedIn(value: false)
        debugPrint("Logged Out")
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let logRegViewController = storyBoard.instantiateViewController(withIdentifier: "logReg") as! LogRegViewController
        if let navigationController = self.window?.rootViewController as? UINavigationController {
            logRegViewController.modalPresentationStyle = .fullScreen
            navigationController.present(logRegViewController, animated: true) {
                // might do smth. later
            }
        }
    }


}
