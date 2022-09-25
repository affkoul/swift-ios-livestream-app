//
//  SocketIOManager.swift
//  Live
//
//  Created by dimi anat on 2020/8/7.
//  Copyright © 2020 com.geniusandcourage. All rights reserved.
//

import UIKit
import SocketIOQ

class SocketIOManager: NSObject {
    static let sharedInstance = SocketIOManager()
    
    override init() {
        super.init()
    }
    
    
    var broadSocket: SocketIOClient = SocketIOClient(socketURL: URL(string: Config.serverUrl)!, config: [.log(true), .forceWebsockets(true)])
    
    var audSocket: SocketIOClient = SocketIOClient(socketURL: URL(string: Config.serverUrl)!, config: [.log(true), .forcePolling(true)])
    
    
    func establishBroadConnection() {
        broadSocket.connect()
    }
     
     
    func closeBroadConnection() {
        broadSocket.disconnect()
    }
    
    func establishAudConnection() {
        audSocket.connect()
    }
     
     
    func closeAudConnection() {
        audSocket.disconnect()
    }
    
}
