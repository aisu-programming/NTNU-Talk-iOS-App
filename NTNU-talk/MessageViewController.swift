//
//  ViewController.swift
//  NTNU-talk
//
//  Created by aisu on 2020/6/29.
//  Copyright © 2020 aisu. All rights reserved.
//

import UIKit
import Foundation

class MessageViewController: UIViewController, UITextFieldDelegate {
    
    var target_id: String = ""
    var getMessageResult: Dictionary<String, Any> = [:]
    var Messages: Array<Dictionary<String, Any>> = []

    func alert(title: String, message: String) {
        let controller = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        controller.addAction(okAction)
        present(controller, animated: true, completion: nil)
    }
    
    func showMessage(text: String, send_by_me: Bool) {
        
        let label =  UILabel()
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 18)
        label.textColor = .white
        label.text = text

        let constraintRect = CGSize(width: 0.66 * self.view.frame.width,
                                    height: .greatestFiniteMagnitude)
        let boundingBox = text.boundingRect(with: constraintRect,
                                            options: .usesLineFragmentOrigin,
                                            attributes: [.font: label.font!],
                                            context: nil)
        label.frame.size = CGSize(width: ceil(boundingBox.width),
                                  height: ceil(boundingBox.height))

        let bubbleSize = CGSize(width: label.frame.width + 28,
                                     height: label.frame.height + 20)

        let bubbleView = BubbleView()
        bubbleView.frame.size = bubbleSize
        bubbleView.isIncoming = send_by_me
        bubbleView.backgroundColor = .clear
        bubbleView.center = self.view.center
        self.view.addSubview(bubbleView)

        label.center = self.view.center
        self.view.addSubview(label)
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        let sampleTextField =  UITextField(frame: CGRect(x: 0, y: self.view.bounds.size.height - 40, width: 300, height: 40))
        sampleTextField.placeholder = "Enter text here"
        sampleTextField.font = UIFont.systemFont(ofSize: 18)
        sampleTextField.borderStyle = UITextField.BorderStyle.roundedRect
        sampleTextField.autocorrectionType = UITextAutocorrectionType.no
        sampleTextField.keyboardType = UIKeyboardType.default
        sampleTextField.returnKeyType = UIReturnKeyType.done
        sampleTextField.clearButtonMode = UITextField.ViewMode.whileEditing
        sampleTextField.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
        sampleTextField.delegate = self
        self.view.addSubview(sampleTextField)
        
        post(url: "http://114.24.94.160:9478/api/chat.php",
        referer: "http://114.24.94.160:9478/chat.php",
        parameters: ["action": "getMessage",
                     "target_id": target_id],
        completion: {(responseJSON) in
            self.getMessageResult = responseJSON
            print(self.getMessageResult,
                  "\n--------------------------------------------------\n")
           
            if let error = responseJSON["error"] {
                DispatchQueue.main.async(execute: {
                    self.alert(title: "獲取聊天紀錄失敗", message: error as! String)
                })
            }
            else if responseJSON["result"] != nil {
            
                self.Messages = []
                let messages = responseJSON["messages"] as! Array<Any>
                for message in messages {
                    do {
                        let messageText = (message as! String).data(using: .utf8)
                        let messageJSON = try JSONSerialization.jsonObject(with: messageText!, options: []) as! [String: Any]
                        self.Messages.append(messageJSON)

                    } catch {
                        DispatchQueue.main.async(execute: {
                            self.alert(title: "解析聊天內容時發生錯誤", message: error.localizedDescription)
                        })
                    }
                }
                
                DispatchQueue.main.async(execute: {
                    self.showMessage(text: (self.Messages[1]["content"] as! String), send_by_me: (NSString(string: self.Messages[1]["send_by_me"] as! String).boolValue))
                })
            }
        })
    }
}
