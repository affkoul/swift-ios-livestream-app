
//
//  AudienceViewController.swift
//  Live
//
//  Created by dimi anat on 20/6/1.
//  Copyright © 2020年 com.geniusandcourage. All rights reserved.
//

import UIKit
import SocketIOQ
import SVProgressHUD

class AudienceViewController: UIViewController {

    @IBOutlet weak var previewView: UIView!
    @IBOutlet weak var statusLabel: UILabel!
    
    var room: Room!
    
    
    var player: IJKFFMoviePlayerController!
//    let socket = SocketIOClient(socketURL: URL(string: Config.serverUrl)!, config: [.log(true), .forcePolling(true)])
    
    var overlayController: LiveOverlayViewController!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        let urlString = Config.rtmpPlayUrl + room.key
        player = IJKFFMoviePlayerController(contentURLString: urlString, with: IJKFFOptions.byDefault())  //contentURLStrint helps you making a complete stream at rooms with special characters.
        
        player.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        player.view.frame = previewView.bounds
        previewView.addSubview(player.view)

        player.prepareToPlay()
        
        SocketIOManager.sharedInstance.audSocket.on("connect") {[weak self] data, ack in
            self?.joinRoom()
        }
        
        statusLabel.textColor = .systemPink
        
    }
    
    func joinRoom() {
        SocketIOManager.sharedInstance.audSocket.emit("join_room", room.key)
        
        UserDefaults.standard.setIsAudCon(value: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        debugPrint("I fired 9999999999999999999999")
        if segue.identifier == "overlay" {
            overlayController = segue.destination as? LiveOverlayViewController
            overlayController.socket = SocketIOManager.sharedInstance.audSocket
            overlayController.room = room
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        player.play()
//        socket.connect()
        SocketIOManager.sharedInstance.establishAudConnection()
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name.IJKMPMoviePlayerLoadStateDidChange, object: player, queue: OperationQueue.main, using: { [weak self] notification in
            
            guard let this = self else {
                return
            }
            let state = this.player.loadState
            switch state {
            case IJKMPMovieLoadState.playable:
                this.statusLabel.text = "Playable"
            case IJKMPMovieLoadState.playthroughOK:
                this.statusLabel.text = "Playing"
            case IJKMPMovieLoadState.stalled:
                this.statusLabel.text = "Buffering"
                
            default:
                this.statusLabel.text = "Playing"
            }
        })

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        player.shutdown()
//        socket.disconnect()
        SocketIOManager.sharedInstance.closeAudConnection()
        NotificationCenter.default.removeObserver(self)
        
        UserDefaults.standard.setIsAudCon(value: false)
    }
    
    @IBAction func closeButtonPressed(_ sender: AnyObject) {
        presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
}
