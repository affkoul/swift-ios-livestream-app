//
//  HomeViewController.swift
//  Live
//
//  Created by dimi anat on 20/6/1.
//  Copyright © 2020年 com.geniusandcourage. All rights reserved.
//

import UIKit
import SVProgressHUD
import Toast_Swift
import SwiftRichString


class HomeViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var rooms: [Room] = []
    var timer = Timer()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
        
        let titleLabel = UILabel()
        titleLabel.font = SystemFonts.AmericanTypewriter.font(size:19)
        titleLabel.textColor = UIColor.white
        titleLabel.textAlignment = .center
        titleLabel.lineBreakMode = .byTruncatingMiddle
        
        if UserDefaults.standard.string(forKey: "LogUsername")?.count ?? 0 > 8  {
            let result = String("\(UserDefaults.standard.string(forKey: "LogUsername")!.prefix(4))... is")
            titleLabel.text = "\(result) on LiveD"
        } else {
            titleLabel.text = "\(UserDefaults.standard.string(forKey: "LogUsernameString") ?? "You are on ")LiveD"
        }
        
        self.navigationController?.navigationBar.topItem?.titleView = titleLabel
//        scheduledTimerWithTimeInterval()
        
        self.tableView.register(SubtitleTableViewCell.self, forCellReuseIdentifier: "cell")
        
    }
    
    
    func scheduledTimerWithTimeInterval(){
        // Scheduling timer to Call the function "updateCounting" with the interval of 1 seconds
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.refreshInstant), userInfo: nil, repeats: true)
    }
    
    @objc func printIt() {
        debugPrint(UserDefaults.standard.string(forKey: "LogEmail") ?? "logEmail")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        refresh()
    }
    
    @IBAction func newButtonPressed(_ sender: AnyObject) {
        createRoom()
    }
    
    @IBAction func refreshButtonPressed(_ sender: AnyObject) {
        refresh()
    }
    
    @IBAction func signoutButtonPressed(_ sender: AnyObject) {
        self.handleSignOut()
        self.loadLoginScreen()
    }
    //MARK: - load login screen
    func loadLoginScreen(){
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let logRegViewController = storyBoard.instantiateViewController(withIdentifier: "logReg") as! LogRegViewController
        logRegViewController.modalPresentationStyle = .fullScreen
        self.present(logRegViewController, animated: true, completion: nil)
    }
    
    func handleSignOut() {
        UserDefaults.standard.setIsLoggedIn(value: false)
    }
    
    @objc func refresh() {
        SVProgressHUD.show()
        let request = URLRequest(url: URL(string: "\(Config.serverUrl)/rooms")!)
        
//        NSURLConnection.sendAsynchronousRequest(request, queue: OperationQueue.main, completionHandler: { resp, data, err in
//            guard err == nil else {
//        //                SVProgressHUD.showError(withStatus: "Error")
//            SVProgressHUD.dismiss()
//            self.navigationController?.view.makeToast("Loading ...", duration: 2.0, position: .center, title: nil, image: UIImage(named: "sad"))
//            return
//
//            }
//            SVProgressHUD.dismiss()
//            let rooms = try! JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions()) as! [[String: AnyObject]]
//                    self.rooms = rooms.map {
//                        Room(dict: $0)
//            }
//            self.tableView.reloadData()
//
//        })
        
        let session = URLSession.shared
        session.dataTask(with: request) { (data, resp, err) in
            print("Entered the completionHandler of refresh")
            guard err == nil else {
//          SVProgressHUD.showError(withStatus: "Error")
            SVProgressHUD.dismiss()
            self.navigationController?.view.makeToast("Loading ...", duration: 2.0, position: .center, title: nil, image: UIImage(named: "sad"))
            return
            }
            SVProgressHUD.dismiss()
            let rooms = try! JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions()) as! [[String: AnyObject]]
                        self.rooms = rooms.map {
                            Room(dict: $0)
            }
//            self.tableView.reloadData()
            DispatchQueue.main.async { // Correct
                self.tableView.reloadData()
            }
        }.resume()
    }
    
    @objc func refreshInstant() {
        let request = URLRequest(url: URL(string: "\(Config.serverUrl)/rooms")!)
        
//        NSURLConnection.sendAsynchronousRequest(request, queue: OperationQueue.main, completionHandler: { resp, data, err in
//            guard err == nil else {
////                SVProgressHUD.showError(withStatus: "Error")
//                self.navigationController?.view.makeToast("Loading ...", duration: 2.0, position: .center, title: nil, image: UIImage(named: "sad"))
//                return
//            }
//            let rooms = try! JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions()) as! [[String: AnyObject]]
//            self.rooms = rooms.map {
//                Room(dict: $0)
//            }
//            self.tableView.reloadData()
//        })
        
        let session = URLSession.shared
        session.dataTask(with: request) { (data, resp, err) in
        print("Entered the completionHandler of refresh instant")
            guard err == nil else {
                self.navigationController?.view.makeToast("Loading ...", duration: 2.0, position: .center, title: nil, image: UIImage(named: "sad"))
                return
            }
            SVProgressHUD.dismiss()
            let rooms = try! JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions()) as! [[String: AnyObject]]
                        self.rooms = rooms.map {
                            Room(dict: $0)
            }
//            self.tableView.reloadData()
            DispatchQueue.main.async { // Correct
                self.tableView.reloadData()
            }
        }.resume()
    }
    
    func createRoom() {
        let vc = R.storyboard.main.broadcast()!
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true, completion: nil)
    }
    
    func joinRoom(_ room: Room) {
        let vc = R.storyboard.main.audience()!
        vc.room = room
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true, completion: nil)
    }
    
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rooms.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let room = rooms[(indexPath as NSIndexPath).row]
        cell.textLabel?.text = "Room: \(room.title != "" ? room.title : room.key)"
        cell.textLabel?.lineBreakMode = .byTruncatingMiddle
        let dataDecoded : Data = Data(base64Encoded: room.image, options: .ignoreUnknownCharacters)!
        let decodedImage = UIImage(data: dataDecoded)
        cell.imageView?.image = decodedImage
        cell.imageView?.frame.size.height = cell.frame.size.height
        cell.imageView?.frame.size.width = cell.frame.size.height
        cell.imageView?.layer.masksToBounds = true
        cell.imageView?.layer.cornerRadius = CGFloat(roundf(Float(cell.imageView!.frame.size.width / 2.0)))
        cell.detailTextLabel?.text = "\(room.viewers) watchers"
        debugPrint("\(room.viewers) GGGGGGGGGGGGGGGGGGGGGGGG")
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let room = rooms[(indexPath as NSIndexPath).row]
        joinRoom(room)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat((tableView.frame.size.width / 3) - 20);//Choose your custom row height
    }
    
}

class SubtitleTableViewCell: UITableViewCell {

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        self.initialize()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        self.initialize()
    }
    
    func initialize() {

    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.masksToBounds = true

    }

    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.textLabel?.text = nil
        self.textLabel?.lineBreakMode = .byTruncatingMiddle
        self.detailTextLabel?.text = nil
        self.imageView?.image = nil
    }
}
