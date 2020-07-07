//
//  Request.swift
//  NTNU-talk
//
//  Created by aisu on 2020/6/30.
//  Copyright © 2020 aisu. All rights reserved.
//

import Foundation

func get(url: String, referer: String, parameters: Dictionary<String, Any>) {
    
    var url_text = url + "?"
    for parameter in parameters {
        url_text += parameter.key + "=" + (parameter.value as! String) + "&"
    }
    let url_URL = URL(string: url_text)!
    
    var request = URLRequest(url: url_URL)
    request.httpMethod = "GET"
    request.setValue(referer, forHTTPHeaderField: "Referer")
    request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
    
    let task = URLSession.shared.dataTask(with: request) { data, response, error in
        guard let data = data, error == nil else {
            print(error?.localizedDescription ?? "No data")
            return
        }
        let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
        if let responseJSON = responseJSON as? [String: String] {
            if let error = responseJSON["error"] {
                print(error)
            }
            else if let result = responseJSON["result"] {
                print(result)
            }
        }
    }
    
    task.resume()
}

func post(url: String, referer: String, parameters: Dictionary<String, Any>, completion: @escaping (_ responseJSON: Dictionary<String, Any>) -> Void) {
    
    let url = URL(string: url)!
    
    var json: String = ""
    for parameter in parameters {
        json += parameter.key + "=" + (parameter.value as! String) + "&"
    }
    let jsonData = json.data(using: String.Encoding.utf8)
    
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.setValue(referer, forHTTPHeaderField: "Referer")
    request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
    request.httpBody = jsonData
    
    let task = URLSession.shared.dataTask(with: request) { data, response, error in
        guard let data = data, error == nil else {
            print(error?.localizedDescription ?? "No data")
            return
        }
        let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
        if let responseJSON = responseJSON as? [String: Any] {
            if (parameters["action"] as! String) == "login" {
                if let error = responseJSON["error"] {
//                    print(error)
                }
                else if let result = responseJSON["result"] {
//                    print(result)
                    
                    KeychainWrapper.standard.set((parameters["user_id"] as! String), forKey: "user_id")
                    KeychainWrapper.standard.set((parameters["password"] as! String), forKey: "password")
                }
            }
//            else {
//                for item in responseJSON {
//                    print(item.key, ": ", item.value)
//                }
//            }
            completion(responseJSON)
        }
    }
    
    task.resume()
}
