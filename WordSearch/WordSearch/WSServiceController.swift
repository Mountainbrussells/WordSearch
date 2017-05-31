//
//  WSServiceController.swift
//  WordSearch
//
//  Created by BenRussell on 5/25/17.
//  Copyright © 2017 BenRussell. All rights reserved.
//

import Foundation

class WSServiceController: NSObject {
    let baseURL = "https://s3.amazonaws.com/duolingo-data/s3/js2/find_challenges.txt".addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)
    
    func downloadGrid(completion: @escaping (_ gridArray: Array<String>?, _ error: Error?) -> Void) {
        let url = URL(string: baseURL!)
        
        let sessionConfig = URLSessionConfiguration.default
        let session = URLSession(configuration: sessionConfig, delegate: nil, delegateQueue: nil)
        var request = URLRequest(url: url!)
        request.httpMethod = "GET"
        let task = session.dataTask(with: request, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) -> Void in
            if (error != nil) {
                completion(nil, error)
            }
            else {
                let dataString = String(data: data!, encoding: .utf8)
                let dataArray = dataString?.components(separatedBy: "\n")
                completion(dataArray, nil)
            }
        })
        task.resume()
    }
}
