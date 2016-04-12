//
//  ViewController.swift
//  Server Connection Test
//
//  Created by Scott on 3/12/16.
//  Copyright © 2016 Canderis. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var serverOutput: UILabel!
    @IBOutlet weak var dataToSend: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func establishConnection(sender: UIButton) {
        
        ajaxRequest(
            ["data":dataToSend.text!],
            url: "http://dev.canderis.com/ServerConnectionTest/conntection.php",
            success: { (response) -> () in
                print(response)
                self.serverOutput.text = "\(response["data"])"
            },
            failure:{ (error) -> () in
                self.serverOutput.text = "errorString = \(error)"
            }
        )
        
        /*
        let myUrl = NSURL(string: "http://dev.canderis.com/ServerConnectionTest/conntection.php");
        let request = NSMutableURLRequest(URL:myUrl!);
        request.HTTPMethod = "POST";
        
        // Compose a query string
        let postString = "data=\(dataToSend.text!)";
        
        request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding);
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
            data, response, error in
            
            var textField = ""

            if error != nil {
                textField = "error=\(error)"
                return
            }
            
            // You can print out response object
            //print("response = \(response)")
            
            // Print out response body
            //let responseString = NSString(data: data!, encoding: NSUTF8StringEncoding)
            //print("responseString = \(responseString)")
            
            //Let’s convert response sent from a server side script to a NSDictionary object:
            
            do {
                let myJSON = try NSJSONSerialization.JSONObjectWithData(data!, options: []) as! [String: AnyObject]
                if let text = myJSON["data"] {
                    textField = text as! String
                }
            } catch let error as NSError {
                textField = "Failed to load: \(error.localizedDescription)"
            }
            dispatch_async(dispatch_get_main_queue(), {
                self.serverOutput.text = textField
            })

            
        }
        task.resume()
        */
    }
    
    func ajaxRequest( params: Dictionary<String, String>, url: String, success: (([String:AnyObject])->())? = nil, failure: ((String)->())? = nil ) {
        
        let nsurl = NSURL(string: url)
        
        do {
            print(params)
            let jsonData = try NSJSONSerialization.dataWithJSONObject(params, options: NSJSONWritingOptions.PrettyPrinted)
            print(jsonData)
            
            // create post request
            let request = NSMutableURLRequest(URL: nsurl!)
            request.HTTPMethod = "POST"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            do {
                let decoded = try NSJSONSerialization.JSONObjectWithData(jsonData, options: []) as? [String:String]
                // here "decoded" is the dictionary decoded from JSON data
                print(decoded)
            } catch let error as NSError {
                print(error)
            }
            
            print (request)
            // insert json data to the request
            request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
            request.HTTPBody = jsonData
            
            print(request)
            
            let task = NSURLSession.sharedSession().dataTaskWithRequest(request) { data, response, error in
                if error != nil{
                    if failure == nil{
                        print("Error -> \(error)")

                    }
                    else {
                        dispatch_async(dispatch_get_main_queue(), {
                            failure!("\(error)")
                        })

                    }
                    return
                }
                
                do {
                    let result = try NSJSONSerialization.JSONObjectWithData(data!, options: []) as? [String:AnyObject]
                    
                    dispatch_async(dispatch_get_main_queue(), {
                        success?(result!)
                    })
                    
                } catch {
                    if failure == nil{
                        print("Error -> \(error)")
                    }
                    else {
                        dispatch_async(dispatch_get_main_queue(), {
                            failure!("\(error)")
                        })
                    }
                    return
                }
            }
            
            task.resume()
            
        }
        catch {
            if failure == nil{
                print("Error -> \(error)")
            }
            else {
                dispatch_async(dispatch_get_main_queue(), {
                    failure!("\(error)")
                })
            }
        }
    }

}

