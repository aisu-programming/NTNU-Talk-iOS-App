//
//  ViewController.swift
//  NTNU-talk
//
//  Created by aisu on 2020/6/29.
//  Copyright © 2020 aisu. All rights reserved.
//

import UIKit

class ChatRoomTableViewController: UITableViewController {
    
    var getAllChatRoomResult: Dictionary<String, Any> = [:]
    var ChatRooms: Array<Dictionary<String, Any>> = []
    
    func alert(title: String, message: String) {
        let controller = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        controller.addAction(okAction)
        present(controller, animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.register(ChatRoomsTableViewCell.self, forCellReuseIdentifier: "cellId")
        
        post(url: "http://114.24.94.160:9478/api/chat.php",
        referer: "http://114.24.94.160:9478/chat.php",
        parameters: ["action": "getAllChatRoom"],
        completion: {(responseJSON) in
            self.getAllChatRoomResult = responseJSON
            print(self.getAllChatRoomResult,
                  "\n--------------------------------------------------\n")
           
            if let error = responseJSON["error"] {
                DispatchQueue.main.async(execute: {
                    self.alert(title: "獲取所有聊天室失敗", message: error as! String)
                })
            }
            else if responseJSON["result"] != nil {
            
                self.ChatRooms = []
                let chatRooms = responseJSON["chat_rooms"] as! Array<Any>
                for chatRoom in chatRooms {
                    do {
                        let chatRoomText = (chatRoom as! String).data(using: .utf8)
                        let chatRoomJSON = try JSONSerialization.jsonObject(with: chatRoomText!, options: []) as! [String: Any]
                        self.ChatRooms.append(chatRoomJSON)
                        
                    } catch {
                        DispatchQueue.main.async(execute: {
                            self.alert(title: "解析聊天室時發生錯誤", message: error.localizedDescription)
                        })
                    }
                }
                
                DispatchQueue.main.async(execute: {
                    self.tableView.reloadData()
                })
            }
        })
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let chatRoom = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath) as! ChatRoomsTableViewCell
        let chatRoomJSON = ChatRooms[indexPath.row]
        chatRoom.chatRoomJSON = chatRoomJSON
        chatRoom.loadAvatar()
        return chatRoom
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ChatRooms.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let messageViewController = MessageViewController()
        messageViewController.target_id = ChatRooms[indexPath.row]["uid"] as! String
        messageViewController.modalPresentationStyle = .fullScreen
        
        self.navigationController?.pushViewController(messageViewController, animated: true)
    }
}
