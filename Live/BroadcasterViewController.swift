//
//  BroadcasterViewController.swift
//  Live
//
//  Created by dimi anat on 20/6/1.
//  Copyright © 2020年 com.geniusandcourage. All rights reserved.
//

import UIKit
import SocketIOQ
import LFLiveKit
import SVProgressHUD

import Alamofire

class BroadcasterViewController: UIViewController {
//class BroadcasterViewController: UIViewController {
        
    @IBOutlet weak var previewView: UIView!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    
    @IBOutlet weak var titleTextField: TextField!
    @IBOutlet weak var inputTitleOverlay: UIVisualEffectView!
    @IBOutlet weak var inputContainer: UIView!
    
    @IBOutlet weak var setProfile: DesignableButton!
    @IBOutlet weak var startButton: DesignableButton!
    
    var cameraIsFront: Bool = true
    var cameraIsBack: Bool = false
    
    
//    let socket = SocketIOClient(socketURL: URL(string: Config.serverUrl)!, config: [.log(true), .forceWebsockets(true)])
    var watchers = 0

    lazy var session: LFLiveSession = {
        let audioConfiguration = LFLiveAudioConfiguration.defaultConfiguration(for: .low)
        let videoConfiguration = LFLiveVideoConfiguration.defaultConfiguration(for: .low1)
        let session = LFLiveSession(audioConfiguration: audioConfiguration, videoConfiguration: videoConfiguration)!
        
        session.delegate = self
        session.adaptiveBitrate = true
        session.beautyFace = true
        session.beautyLevel = 1.0
        session.brightLevel = 1.0
        session.showDebugInfo = true
        session.preView = self.previewView
        return session
    }()
    
    var room: Room!
    
    var roomImage: UIImage!
    
    var imagePicker: ImagePicker!
    
    var overlayController: LiveOverlayViewController!

    override func viewDidLoad() {
        super.viewDidLoad()
            // Do any additional setup after loading the view, typically from a nib.
        
        //Add Target for camera witch
        let recognizer = UILongPressGestureRecognizer(target: self, action: #selector(longPressHappened))
        view.addGestureRecognizer(recognizer)
        
        self.imagePicker = ImagePicker(presentationController: self, delegate: self)
        
        statusLabel.textColor = .systemPink
        infoLabel.textColor = .systemRed

    }
        
    @objc func longPressHappened() {
        // do something here
        if cameraIsFront {
           session.captureDevicePosition = .back
           cameraIsFront = false
           cameraIsBack = true
        } else {
            session.captureDevicePosition = .front
            cameraIsFront = true
            cameraIsBack = false
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        session.running = true
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        session.running = true
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        session.running = false
        stop()
        // logout
        AF.request(Config.URL_USER_LOGOUT)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "overlay" {
            overlayController = segue.destination as? LiveOverlayViewController
            overlayController.socket = SocketIOManager.sharedInstance.broadSocket
        }
    }

    func start() {
        let imageToUpload = roomImage ?? UIImage(named: "Live")! as UIImage
        let imageData:Data = imageToUpload.pngData()!
        let imageStr = imageData.base64EncodedString()

        room = Room(dict: [
            "title": titleTextField.text! as AnyObject,
            "key": String.random() as AnyObject,
            "image": imageStr as AnyObject,
            "viewers": watchers as AnyObject
        ])
        
        overlayController.room = room
        
        let stream = LFLiveStreamInfo()
        stream.url = "\(Config.rtmpPushUrl)\(room.key)"
        session.startLive(stream)
        
//        socket.connect()
        SocketIOManager.sharedInstance.establishBroadConnection()
        SocketIOManager.sharedInstance.broadSocket.once("connect") {[weak self] data, ack in
            guard let this = self else {
                return
            }
            SocketIOManager.sharedInstance.broadSocket.emit("create_room", this.room.toDict())
        }
        
        infoLabel.text = "Room: \(room.key)"
        
        UserDefaults.standard.setIsBroadCon(value: true)
    }
    
    func stop() {
        guard room != nil else {
            return
        }
        session.stopLive()
//        socket.disconnect()
        SocketIOManager.sharedInstance.closeBroadConnection()
        
        // logout
        AF.request(Config.URL_USER_LOGOUT)
        
        UserDefaults.standard.setIsBroadCon(value: false)
    }
    
    @IBAction func startButtonPressed(_ sender: AnyObject) {
        titleTextField.resignFirstResponder()
        SVProgressHUD.show()
        self.start()
        SVProgressHUD.dismiss()
        UIView.animate(withDuration: 0.2, animations: {
            self.inputTitleOverlay.alpha = 0
        }, completion: { finished in
            self.inputTitleOverlay.isHidden = true
        })
    }
        
    @IBAction func closeButtonPressed(_ sender: AnyObject) {
        presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func setProfileButtonTapped(_ sender: UIButton) {
        self.imagePicker.present(from: sender)
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
    
}

extension BroadcasterViewController: LFLiveSessionDelegate {
    
    func liveSession(_ session: LFLiveSession?, liveStateDidChange state: LFLiveState) {
        switch state {
        case .error:
            statusLabel.text = "error"
        case .pending:
            statusLabel.text = "pending"
        case .ready:
            statusLabel.text = "gettin' ready"
        case.start:
            statusLabel.text = "started"
        case.stop:
            statusLabel.text = "stopped"
        @unknown default:
            self.navigationController?.view.makeToast("Taking too long ...", duration: 2.0, position: .center, title: nil, image: UIImage(named: "sad"))
        }
    }
    
    func liveSession(_ session: LFLiveSession?, debugInfo: LFLiveDebug?) {
        
    }
    
    func liveSession(_ session: LFLiveSession?, errorCode: LFLiveSocketErrorCode) {
        print("error: \(errorCode)")
        
    }
    
}

extension BroadcasterViewController: ImagePickerDelegate {

    func didSelect(image: UIImage?) {
        roomImage = image
    }
}

