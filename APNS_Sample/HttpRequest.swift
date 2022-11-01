//
//  HttpRequest.swift
//  APNS_Sample
//
//  Created by SJ on 2022/11/7.
//

import Foundation
class HttpRequest {
    static func get(_ str:String){
        let semaphore = DispatchSemaphore (value: 0)
        var request = URLRequest(url: URL(string: "http://192.168.2.3:3000/\(str)")!,timeoutInterval: Double.infinity)
        request.httpMethod = "GET"
        let task = URLSession.shared.dataTask(with: request) {
            data, response, error in
            guard let data = data else {
                print(String(describing: error))
                semaphore.signal()
                return
            }
            print(String(data: data, encoding: .utf8)!)
            semaphore.signal()
        }
        task.resume()
        semaphore.wait()
    }
}
