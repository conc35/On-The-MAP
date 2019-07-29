//
//  APIudacity.swift
//  on the Map Wael
//
//  Created by Wael Yazqi on 2019-06-19.
//  Copyright © 2019 Wael. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation


class APIudacity {

// Identifications
    

    

// POSTing a Session
        
        static func login (_ username : String!, _ password : String!, completion: @escaping (Bool, String, Error?)->()) {
            
            var request = URLRequest(url: URL(string: "https://onthemap-api.udacity.com/v1/session")!)
            request.httpMethod = "POST"
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = "{\"udacity\": {\"username\": \"\(username!)\", \"password\": \"\(password!)\"}}".data(using: .utf8)
            
            
            
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                if error != nil {
                    // TODO: Call the completion handler and send the error so it can be handled on the UI, also call "return" so the code next to this block won't be executed
                    completion (false, "", error)
                    return
                }
                
                //Get the status code to check if the response is OK or not
                guard let statusCode = (response as? HTTPURLResponse)?.statusCode else {
                    
                    // TODO: Call the completion handler and send the error so it can be handled on the UI, also call "return" so the code next to this block won't be executed (you need to call return in let guard's else body anyway)
                    let statusCodeError = NSError(domain: NSURLErrorDomain, code: 0, userInfo: nil)
                    
                    completion (false, "", statusCodeError)
                    return
                }
                
                
                
                if statusCode >= 200  && statusCode < 300 {
                    
                    //Skipping the first 5 characters
                    let range = Range(5..<data!.count)
                    let newData = data?.subdata(in: range) /* subset response data! */

                    print (String(data: newData!, encoding: .utf8)!)

                    let loginJsonObject = try! JSONSerialization.jsonObject(with: newData!, options: [])

                    let loginDictionary = loginJsonObject as? [String : Any]
                    
                    //Get the unique key of the user
                    let accountDictionary = loginDictionary? ["account"] as? [String : Any]
                    let uniqueKey = accountDictionary? ["key"] as? String ?? " "
                    
                    Global.shared.loginKey = uniqueKey
                    
                    completion (true, uniqueKey, nil)
                } else {

                    completion (false, "", nil)
                }
            }
            task.resume()
        }
    
//===========================================================================
// DELETEing a Session
    static func DeleteSession (completion: @escaping (Error?)-> ())
    {
        var request = URLRequest(url: URL(string: "https://onthemap-api.udacity.com/v1/session")!)
        request.httpMethod = "DELETE"
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
        if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
        request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
        if error != nil {
            completion(error)
            return
        }
        let Newdata = data![5..<data!.count]
        
            print(String(data: Newdata, encoding: .utf8)!)
            completion(nil)
        }
        task.resume()
    }
//================================================================
//get Student Location
    static func getAllLocations (completion: @escaping ([StudentLocation]?, Error?) -> ()) {
        let url = "https://onthemap-api.udacity.com/v1/StudentLocation?limit=100&order=-updatedAt"
        
        var request = URLRequest(url: URL(string: url)!)
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
            
            let task = URLSession.shared.dataTask(with: request) {data, response, error in
                
                
                if error != nil {

                    completion (nil, error)
                    return
                }
                print (String(data: data!, encoding: .utf8)!)
                
                guard let statusCode = (response as? HTTPURLResponse)?.statusCode else {

                    let statusCodeError = NSError(domain: NSURLErrorDomain, code: 0, userInfo: nil)
                    
                    completion (nil, statusCodeError)
                    return
                }
                
                
                if statusCode >= 200 && statusCode < 300 {
                    
                    
                    let jsonObject = try! JSONSerialization.jsonObject(with: data!, options: [])

                    guard let jsonDictionary = jsonObject as? [String : Any] else {return}
 
                    let resultsArray = jsonDictionary["results"] as? [[String:Any]]

                    guard let array = resultsArray else {return}
                    print("array\(array)")
                    let dataObject = try! JSONSerialization.data(withJSONObject: array, options: .prettyPrinted)

                    let studentsLocations = try! JSONDecoder().decode([StudentLocation].self, from: dataObject)
                    print ("stutend \(studentsLocations)")
                    Global.shared.Studentlocations = studentsLocations
                    
                    completion (studentsLocations, nil)
                }
                
            }
        
            task.resume()
        }

//===========================================================================
    // GETting Public User Data
    static func GETtingPublicUserData(completion: @escaping (Error?) -> ())
    {
        let request = URLRequest(url: URL(string: "https://onthemap-api.udacity.com/v1/users/\(Global.shared.loginKey)")!)
        
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if error != nil {
                
                completion(error)
                return
            }
            
            let Newdata = data![5..<data!.count]
            
            guard let dictionary = try? JSONSerialization.jsonObject(with: Newdata, options: []) as? [String : Any] else {
                completion(error)
                return
            }
            Global.shared.FirstName = dictionary?["first_name"] as? String ?? ""
            Global.shared.LastName = dictionary?["last_name"] as? String ?? ""
            
        }
        task.resume ()
    }
    
    
//======================================================================================
// POSTing a Student Location
   static func PostingLocations (link:String, locationCoordinate:CLLocationCoordinate2D, locationName:String, completion: @escaping (Error?) -> ()) {
    
    var request = URLRequest(url: URL(string: "https://onthemap-api.udacity.com/v1/StudentLocation")!)
    request.httpMethod = "POST"
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    request.httpBody = "{\"uniqueKey\": \"\(Global.shared.loginKey)\", \"firstName\": \"\(Global.shared.FirstName)\", \"lastName\": \"\(Global.shared.LastName)\",\"mapString\": \"\(locationName)\", \"mediaURL\": \"\(link)\",\"latitude\": \(locationCoordinate.latitude), \"longitude\": \(locationCoordinate.longitude)}".data(using: .utf8)
    let session = URLSession.shared
    let task = session.dataTask(with: request) { data, response, error in
    if error != nil {
        completion(error)
        return
    }
    print(String(data: data!, encoding: .utf8)!)
     completion(nil)
    }
   task.resume()

    }
    }

//===========================================================================


        



