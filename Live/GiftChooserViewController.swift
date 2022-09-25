//
//  GiftChooserViewController.swift
//  Live
//
//  Created by dimi anat on 20/6/1.
//  Copyright © 2020年 com.geniusandcourage. All rights reserved.
//

import UIKit
import SocketIOQ

class GiftChooserViewController: UIViewController {
    
    
    var socket: SocketIOClient!
    var room: Room!
    
    override func viewDidLoad() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(GiftChooserViewController.handleTap(_:)))
        view.addGestureRecognizer(tap)

    }
    
    @objc func handleTap(_ gesture: UITapGestureRecognizer) {
        guard gesture.state == .ended else {
            return
        }
        presentingViewController?.dismiss(animated: true, completion: nil)
    }

    @IBAction func giftButtonPressed(_ sender: UIButton) {
        
        socket.emit("gift", [
            "roomKey": room.key,
            "senderId": User.currentUser.id,
            "giftId": sender.tag,
            "giftCount": 1
        ])
        
        debugPrint("gift 33333333333333333333333333")
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
}
