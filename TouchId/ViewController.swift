//
//  ViewController.swift
//  TouchId
//
//  Created by Narendra Kumar R on 5/25/17.
//  Copyright © 2017 Narendra. All rights reserved.
//

import UIKit
import LocalAuthentication


class ViewController: UIViewController {

    @IBOutlet weak var statuLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        statuLabel.text = ""
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func authenticateMeAction(_ sender: UIButton) {
        authenticateUser { (success, error, message) in
            DispatchQueue.main.async {
                if success {
                    self.statuLabel.text = "You are authenticated"
                }else{
                    self.statuLabel.text = message
                    
                }
            }
        }        
    }
    
    
    func authenticateUser(completion: @escaping (_ success: Bool, _ error: Error?, _ message: String?) -> Void) {
        // Get the local authentication context.
        let context = LAContext()
        
        // Declare a NSError variable.
        var error: NSError?
        
        // Set the reason string that will appear on the authentication alert.
        let reasonString = "Authentication is needed to refresh your app login."
        
        // Check if the device can evaluate the policy.
        if context.canEvaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            context .evaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, localizedReason: reasonString, reply: { (success, evalPolicyError) in
                if success {
                    print("success validated passcode")
                    completion(true, nil, nil)
                }
                else{
                    let error = evalPolicyError as! LAError
                    print(error.localizedDescription)
                    
                    switch error.code {
                        
                    case LAError.systemCancel:
                        print("Authentication was cancelled by the system")
                        completion(false, error, "Authentication was cancelled by the system")
                        
                    case LAError.userCancel:
                        print("Authentication was cancelled by the user")
                        completion(false, error, "Authentication was cancelled by the user")
                        
                    case LAError.userFallback:
                        print("User selected to enter custom password")
                        completion(false, error, "User selected to enter custom password")
                        
                        //                        self.showPasswordAlert()
                        
                    default:
                        print("Authentication failed")
                        completion(false, error, "Authentication failed")
                        
                        //                        self.showPasswordAlert()
                    }
                }
                
            })
        }else{
            // If the security policy cannot be evaluated then show a short message depending on the error.
            switch error!.code{
                
            case LAError.touchIDNotEnrolled.rawValue:
                print("TouchID is not enrolled")
                completion(false, error, "TouchID is not enrolled")
                
            case LAError.passcodeNotSet.rawValue:
                print("A passcode has not been set")
                completion(false, error, "A passcode has not been set")
                
            default:
                // The LAError.TouchIDNotAvailable case.
                print("TouchID not available")
                completion(false, error, "TouchID not available")
                
            }
            
            // Optionally the error description can be displayed on the console.
            print(error?.localizedDescription ?? "Error, but no error description")
            completion(false, error, "Error, but no error description")
            
            // Show the custom alert view to allow users to enter the password.
            //            self.showPasswordAlert()
        }
    }


}

