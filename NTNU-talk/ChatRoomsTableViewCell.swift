//
//  CustomTableViewCell.swift
//  NTNU-talk
//
//  Created by aisu on 2020/7/2.
//  Copyright © 2020 aisu. All rights reserved.
//

import UIKit
class ChatRoomsTableViewCell : UITableViewCell {
 
    var chatRoomJSON : Dictionary<String, Any>? {
        didSet {
            chatRoomNicknameLabel.text = chatRoomJSON?["nickname"] as? String
            if Int(chatRoomJSON?["send_by_me"] as! String)! == 1 {
                chatRoomMessageLabel.text = "你: " + ((chatRoomJSON?["preview"] as? String)!)
            }
            else {
                chatRoomMessageLabel.text = chatRoomJSON?["preview"] as? String
            }
        }
    }

    private let chatRoomAvatarImage : UIImageView = {
        let imgView = UIImageView()
        imgView.contentMode = .scaleAspectFit
        imgView.clipsToBounds = true
        return imgView
    }()
    
    private let chatRoomNicknameLabel : UILabel = {
        let lbl = UILabel()
        lbl.textColor = .black
        lbl.font = UIFont.boldSystemFont(ofSize: 20)
        lbl.textAlignment = .left
        return lbl
    }()

    private let chatRoomMessageLabel : UILabel = {
        let lbl = UILabel()
        lbl.textColor = .black
        lbl.font = UIFont.systemFont(ofSize: 14)
        lbl.textAlignment = .left
        lbl.numberOfLines = 1
        return lbl
    }()


    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(chatRoomAvatarImage)
        addSubview(chatRoomNicknameLabel)
        addSubview(chatRoomMessageLabel)

        chatRoomAvatarImage.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: nil, paddingTop: 5, paddingLeft: 15, paddingBottom: 5, paddingRight: 0, width: 50, height: 50, enableInsets: false)
        chatRoomNicknameLabel.anchor(top: topAnchor, left: chatRoomAvatarImage.rightAnchor, bottom: nil, right: nil, paddingTop: 8, paddingLeft: 10, paddingBottom: 0, paddingRight: 0, width: frame.size.width * 2 / 3, height: 0, enableInsets: false)
        chatRoomMessageLabel.anchor(top: chatRoomNicknameLabel.bottomAnchor, left: chatRoomAvatarImage.rightAnchor, bottom: nil, right: nil, paddingTop: 4, paddingLeft: 10, paddingBottom: 0, paddingRight: 0, width: frame.size.width * 2 / 3, height: 0, enableInsets: false)
    }
    
    func loadAvatar() {
        let urlText = (chatRoomJSON?["avatar"] as! String).replacingOccurrences(of: "\\", with: "")
        let url = URL(string: urlText)
        chatRoomAvatarImage.load(url: url!)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
 
}
