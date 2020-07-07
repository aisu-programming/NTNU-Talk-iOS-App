//
//  TestViewController.swift
//  NTNU-talk
//
//  Created by aisu on 2020/7/3.
//  Copyright © 2020 aisu. All rights reserved.
//

import UIKit

class TestViewController: UIViewController {
    
    @IBAction func testButton(_ sender: Any) {
        let messageViewController = MessageViewController()
        messageViewController.modalPresentationStyle = .fullScreen
        
        self.navigationController?.pushViewController(messageViewController, animated: true)
    }
    
    override func viewDidLoad() {
    
        super.viewDidLoad()
    }
}
