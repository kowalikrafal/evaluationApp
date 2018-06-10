//
//  NetworkEngine.swift
//  evaluationApp
//
//  Created by Rafal Kowalik on 10.06.2018.
//  Copyright © 2018 rafkow. All rights reserved.
//

import UIKit

class NetworkEngine: NSObject {
    
    static func getJSON(forUrl: String, withCompletionHandler completionHandler: @escaping (_ success:[Any]) -> Void){
        let url = URL(string: forUrl)
        URLSession.shared.dataTask(with:url!) { (data, response, error) in
            if error != nil {
                print(error!)
            } else {
                do {
                    let parsedData = try JSONSerialization.jsonObject(with: data!) as! [Any]
                    completionHandler(parsedData);
                } catch let error as NSError {
                    print(error)
                }
            }
            
            }.resume()
    }
    
    static func getDataForDetailView(url: String,withCompletionHandler completionHandler: @escaping (_ success:[String: Any]) -> Void){
        let stringURL = "http://dev.tapptic.com/test/json.php?name=\(url)"
        let url = URL(string: stringURL)
        URLSession.shared.dataTask(with:url!) { (data, response, error) in
            if error != nil {
                print(error!)
            } else {
                do {
                    let parsedData = try JSONSerialization.jsonObject(with: data!) as! [String: Any]
                    completionHandler(parsedData);
                    
                } catch let error as NSError {
                    print(error)
                }
            }
            }.resume()
    }
    
}

