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
            [
                "one": dataToSend.text!,
                "two": "2",
                "three": "testing",
                "four": "blah",
            
            ],
            url: "connection.php",
            success: { (response) -> () in
                print(response)
                self.serverOutput.text = "\(response["data"])"
            },
            failure:{ (error) -> () in
                self.serverOutput.text = "errorString = \(error)"
            }
        )
    }
    
}
