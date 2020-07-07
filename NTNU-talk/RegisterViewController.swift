//
//  ViewController.swift
//  NTNU-talk
//
//  Created by aisu on 2020/6/29.
//  Copyright © 2020 aisu. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController {
    
    var registerResult: Dictionary<String, Any> = [:]
    
    func alert(title: String, message: String) {
        let controller = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        controller.addAction(okAction)
        present(controller, animated: true, completion: nil)
    }
    
    @IBOutlet weak var userIdInput: UITextField!
    @IBOutlet weak var passwordInput: UITextField!
    @IBOutlet weak var checkPasswordInput: UITextField!
    @IBOutlet weak var nicknameInput: UITextField!
    
    @IBAction func registerButton(_ sender: Any) {
        
        if userIdInput.text!.isEmpty {
            alert(title: "請輸入帳號", message: "帳號不得為空")
        }
        else if userIdInput.text!.count != 9 {
            alert(title: "帳號錯誤", message: "帳號應使用長度為 9 的學號")
        }
        else if passwordInput.text!.isEmpty {
            alert(title: "請輸入密碼", message: "密碼不得為空")
        }
        else if checkPasswordInput.text!.isEmpty {
            alert(title: "請再次輸入密碼", message: "密碼驗證不得為空")
        }
        else if passwordInput.text! != checkPasswordInput.text! {
            alert(title: "密碼不相同", message: "密碼與密碼驗證不同")
        }
        else if nicknameInput.text!.isEmpty {
            alert(title: "請輸入暱稱", message: "暱稱不得為空")
        }
        else {
            
            post(url: "http://114.24.94.160:9478/api/register.php",
                 referer: "http://114.24.94.160:9478/register.php",
                 parameters: ["action": "register",
                              "user_id": userIdInput.text!,
                              "password": passwordInput.text!,
                              "nickname": nicknameInput.text!],
                 completion: {(responseJSON) in
                    self.registerResult = responseJSON
                    print(self.registerResult,
                          "\n--------------------------------------------------\n")
                    
                    if let error = responseJSON["error"] {
                       
                        DispatchQueue.main.async(execute: {
                            self.alert(title: "註冊失敗", message: error as! String)
                        })
                    }
                    else if let result = responseJSON["result"] {
                        
                        DispatchQueue.main.async(execute: {
                            
                            let chatRoomTableViewController = ChatRoomTableViewController()
                            chatRoomTableViewController.modalPresentationStyle = .fullScreen
                            
                            self.navigationController?.pushViewController(chatRoomTableViewController, animated: true)
                            
                            self.alert(title: "註冊成功", message: result as! String)
                            
                            KeychainWrapper.standard.set((self.userIdInput.text!), forKey: "user_id")
                            KeychainWrapper.standard.set((self.passwordInput.text!), forKey: "password")
                        })
                     }
                 })
        }
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(sender:)), name: UIResponder.keyboardWillShowNotification, object: nil);
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(sender:)), name: UIResponder.keyboardWillHideNotification, object: nil);
    }
    
    @objc func keyboardWillShow(sender: NSNotification) {
         self.view.frame.origin.y = -100 // Move view 150 points upward
    }

    @objc func keyboardWillHide(sender: NSNotification) {
         self.view.frame.origin.y = 0 // Move view to original position
    }
}
