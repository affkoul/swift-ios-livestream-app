//
//  LiveOverlayViewController.swift
//  Live
//
//  Created by dimi anat on 20/6/1.
//  Copyright © 2020年 com.geniusandcourage. All rights reserved.
//

import UIKit
import SocketIOQ
import SwiftRichString


class LiveOverlayViewController: UIViewController {
    
    @IBOutlet var wholeView: UIView!
    @IBOutlet weak var emitterView: WaveEmitterView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var inputContainer: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var giftArea: GiftDisplayArea!
    
    
    var comments: [Comment] = []
    var room: Room!
    
    
    var socket: SocketIOClient!
    
    let connectedUsersCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.register(CustomCell.self, forCellWithReuseIdentifier: "collectionCell")
        cv.backgroundColor = .clear
        cv.layer.borderColor = .none
        cv.showsHorizontalScrollIndicator = false
        return cv
    }()
    
    let data = [
        CustomData(title: "The Islands!", url: "maxcodes.io/enroll", backgroundImage: UIImage(named: "Live")!),
        CustomData(title: "Subscribe!", url: "maxcodes.io/courses", backgroundImage: UIImage(named: "Live")!),
        CustomData(title: "StoreKit!", url: "maxcodes.io/courses", backgroundImage: UIImage(named: "Live")!),
        CustomData(title: "Collection!", url: "maxcodes.io/courses", backgroundImage: UIImage(named: "Live")!),
        CustomData(title: "MapKit!", url: "maxcodes.io/courses", backgroundImage: UIImage(named: "Live")!),
        CustomData(title: "The Islands!", url: "maxcodes.io/enroll", backgroundImage: UIImage(named: "Live")!),
        CustomData(title: "Subscribe!", url: "maxcodes.io/courses", backgroundImage: UIImage(named: "Live")!),
        CustomData(title: "StoreKit!", url: "maxcodes.io/courses", backgroundImage: UIImage(named: "Live")!),
        CustomData(title: "Collection!", url: "maxcodes.io/courses", backgroundImage: UIImage(named: "Live")!),
        CustomData(title: "MapKit!", url: "maxcodes.io/courses", backgroundImage: UIImage(named: "Live")!),
        CustomData(title: "The Islands!", url: "maxcodes.io/enroll", backgroundImage: UIImage(named: "Live")!),
        CustomData(title: "Subscribe to maxcodes boiiii!", url: "maxcodes.io/courses", backgroundImage: UIImage(named: "Live")!),
        CustomData(title: "StoreKit Course!", url: "maxcodes.io/courses", backgroundImage: UIImage(named: "Live")!),
        CustomData(title: "Collection Views!", url: "maxcodes.io/courses", backgroundImage: UIImage(named: "Live")!),
        CustomData(title: "MapKit!", url: "maxcodes.io/courses", backgroundImage: UIImage(named: "Live")!),
        CustomData(title: "The Islands!", url: "maxcodes.io/enroll", backgroundImage: UIImage(named: "Live")!),
        CustomData(title: "Subscribe to maxcodes boiiii!", url: "maxcodes.io/courses", backgroundImage: UIImage(named: "Live")!),
        CustomData(title: "StoreKit Course!", url: "maxcodes.io/courses", backgroundImage: UIImage(named: "Live")!),
        CustomData(title: "Collection Views!", url: "maxcodes.io/courses", backgroundImage: UIImage(named: "Live")!),
        CustomData(title: "MapKit!", url: "maxcodes.io/courses", backgroundImage: UIImage(named: "Live")!),
        CustomData(title: "The Islands!", url: "maxcodes.io/enroll", backgroundImage: UIImage(named: "Live")!),
        CustomData(title: "Subscribe to maxcodes boiiii!", url: "maxcodes.io/courses", backgroundImage: UIImage(named: "Live")!),
        CustomData(title: "StoreKit Course!", url: "maxcodes.io/courses", backgroundImage: UIImage(named: "Live")!),
        CustomData(title: "Collection Views!", url: "maxcodes.io/courses", backgroundImage: UIImage(named: "Live")!),
        CustomData(title: "MapKit!", url: "maxcodes.io/courses", backgroundImage: UIImage(named: "Live")!),
        CustomData(title: "The Islands!", url: "maxcodes.io/enroll", backgroundImage: UIImage(named: "Live")!),
        CustomData(title: "Subscribe to maxcodes boiiii!", url: "maxcodes.io/courses", backgroundImage: UIImage(named: "Live")!),
        CustomData(title: "StoreKit Course!", url: "maxcodes.io/courses", backgroundImage: UIImage(named: "Live")!),
        CustomData(title: "Collection Views!", url: "maxcodes.io/courses", backgroundImage: UIImage(named: "Live")!),
        CustomData(title: "MapKit!", url: "maxcodes.io/courses", backgroundImage: UIImage(named: "Live")!),
        CustomData(title: "The Islands!", url: "maxcodes.io/enroll", backgroundImage: UIImage(named: "Live")!),
        CustomData(title: "Subscribe to maxcodes boiiii!", url: "maxcodes.io/courses", backgroundImage: UIImage(named: "Live")!),
        CustomData(title: "StoreKit Course!", url: "maxcodes.io/courses", backgroundImage: UIImage(named: "Live")!),
        CustomData(title: "Collection Views!", url: "maxcodes.io/courses", backgroundImage: UIImage(named: "Live")!),
        CustomData(title: "MapKit!", url: "maxcodes.io/courses", backgroundImage: UIImage(named: "Live")!),
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        textField.delegate = self
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.estimatedRowHeight = CGFloat((view.frame.size.width / 3) - 20)
        tableView.rowHeight = UITableView.automaticDimension
        
        
        Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(LiveOverlayViewController.tick(_:)), userInfo: nil, repeats: true)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(LiveOverlayViewController.handleTap(_:)))
        view.addGestureRecognizer(tap)
        

        socket.on("upvote") {[weak self] data ,ack in
            self?.emitterView.emitImage(R.image.heart()!)
        }
        
        socket.on("comment") {[weak self] data ,ack in
            let comment = Comment(dict: data[0] as! [String: AnyObject])
            self?.comments.append(comment)
            self?.tableView.reloadData()
        }
        
        socket.on("gift") {[weak self] data ,ack in
            let event = GiftEvent(dict: data[0] as! [String: AnyObject])
            self?.giftArea.pushGiftEvent(event)
        }
        
        setupCollectionViewConstraints()
        connectedUsersCollectionView.delegate = self
        connectedUsersCollectionView.dataSource = self   
        
    }
    
    func setupCollectionViewConstraints() {
      view.addSubview(connectedUsersCollectionView)
      connectedUsersCollectionView.translatesAutoresizingMaskIntoConstraints = false
      connectedUsersCollectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: 70).isActive = true
      connectedUsersCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25).isActive = true
      connectedUsersCollectionView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.1).isActive = true
      connectedUsersCollectionView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5).isActive = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.contentInset.top = tableView.bounds.height
        tableView.reloadData()
        connectedUsersCollectionView.reloadData()
    }
    
    @objc func handleTap(_ gesture: UITapGestureRecognizer) {
        guard gesture.state == .ended else {
            return
        }
        textField.resignFirstResponder()
    }
    
    @objc func tick(_ timer: Timer) {
        guard comments.count > 0 else {
            return
        }
        if tableView.contentSize.height > tableView.bounds.height {
            tableView.contentInset.top = 0
        }
        tableView.scrollToRow(at: IndexPath(row: comments.count - 1, section: 0), at: UITableView.ScrollPosition.bottom, animated: true)
    }

    @IBAction func giftButtonPressed(_ sender: AnyObject) {
        let vc = R.storyboard.main.giftChooser()!
        vc.socket = socket
        vc.room = room
        vc.modalPresentationStyle = .custom
        present(vc, animated: true, completion: nil)
        
    }
    
    
    @IBAction func upvoteButtonPressed(_ sender: AnyObject) {
        socket.emit("upvote", room.key)
        debugPrint("tapped 5555555555555555555555")
    }
    
}

extension LiveOverlayViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return data.count
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let collectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionCell", for: indexPath) as! CustomCell
        collectionCell.data = self.data[indexPath.item]
        collectionCell.lb.frame.size.height = collectionCell.frame.size.height * 0.2
        collectionCell.lb.frame.size.width = collectionCell.frame.size.height
        collectionCell.lb.textAlignment = .left
        collectionCell.lb.numberOfLines = 1
        collectionCell.lb.font = SystemFonts.AmericanTypewriter.font(size:5.0)
        collectionCell.lb.lineBreakMode = .byTruncatingMiddle
        collectionCell.lb.textColor = .cyan
        collectionCell.bg.contentMode = .scaleAspectFill
        collectionCell.bg.frame.size.height = collectionCell.frame.size.height * 0.8
        collectionCell.bg.frame.size.width = collectionCell.frame.size.height * 0.8
        collectionCell.bg.layer.cornerRadius = CGFloat(roundf(Float(collectionCell.bg.frame.size.width / 2.0)))
        collectionCell.bg.layer.masksToBounds = true
        return collectionCell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: CGFloat((collectionView.frame.size.width / 3) - 20), height: CGFloat((collectionView.frame.size.width / 3) - 20))
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
}

extension LiveOverlayViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string == "\n" {
            textField.resignFirstResponder()
            if let text = textField.text , text != "" {
                socket.emit("comment", [
                    "roomKey": room.key,
                    "text": text
                ])
            }
            textField.text = ""
            return false
        }
        return true
    }
    
}

extension LiveOverlayViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CommentCell
        cell.comment = comments[(indexPath as NSIndexPath).row]
        return cell
    }
    
}


class CommentCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var commentContainer: UIView!
    
    var comment: Comment! {
        didSet {
            updateUI()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        commentContainer.layer.cornerRadius = 3
    }
    
    func updateUI() {
        titleLabel.attributedText = comment.text.attributedComment()
    }
    
}

struct CustomData {
    var title: String
    var url: String
    var backgroundImage: UIImage
}

class CustomCell: UICollectionViewCell {
    
    var data: CustomData? {
        didSet {
            guard let data = data else { return }
            bg.image = data.backgroundImage
            lb.text = data.title
            
        }
    }
    
    fileprivate let bg: UIImageView = {
       let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    
    fileprivate let lb: UILabel = {
        let lv = UILabel()
        lv.translatesAutoresizingMaskIntoConstraints = false
        lv.textAlignment = .left
        lv.lineBreakMode = .byTruncatingMiddle
        lv.textColor = .cyan
        return lv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        contentView.addSubview(lb)
        contentView.addSubview(bg)
        
        lb.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        lb.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.2).isActive = true
        lb.widthAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.8).isActive = true

        bg.topAnchor.constraint(equalTo: lb.bottomAnchor).isActive = true
        bg.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.8).isActive = true
        bg.widthAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.8).isActive = true

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.masksToBounds = true

    }

    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.lb.text = nil
        self.lb.lineBreakMode = .byTruncatingMiddle
        self.lb.textAlignment = .left
        self.bg.image = nil
    }
}
