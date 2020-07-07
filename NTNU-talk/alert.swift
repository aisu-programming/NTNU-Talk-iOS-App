//
//  alert.swift
//  NTNU-talk
//
//  Created by aisu on 2020/7/1.
//  Copyright © 2020 aisu. All rights reserved.
//

import UIKit

// 這可以是一個自由函式（free function），亦即它不需要被放在任何型別裡面。
func presentAlert(_ alertController: UIAlertController) {
    // 創造一個 UIWindow 的實例。
    let alertWindow = UIWindow()
    // UIWindow 預設的背景色是黑色，但我們想要 alertWindow 的背景是透明的。
    alertWindow.backgroundColor = nil
    // 將 alertWindow 的顯示層級提升到最上方，不讓它被其它視窗擋住。
    alertWindow.windowLevel = .alert
    // 指派一個空的 UIViewController 給 alertWindow 當 rootViewController。
    alertWindow.rootViewController = UIViewController()
    // 將 alertWindow 顯示出來。由於我們不需要使 alertWindow 變成主視窗，所以沒有必要用 alertWindow.makeKeyAndVisible()。
    alertWindow.isHidden = false
    // 使用 alertWindow 的 rootViewController 來呈現警告。
    alertWindow.rootViewController?.present(alertController, animated: true)
}
