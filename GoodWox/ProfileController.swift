import Foundation
import UIKit

class ProfileController: UIViewController{
    
    @IBOutlet var nameLabel: UILabel!
    
    let authentication: Authentication = Authentication()

    lazy var graphClient: MSGraphClient = {
        let client = MSGraphClient.defaultClient()
        return client
    }()
    
    override func viewDidLoad(){

        MSGraphClient.setAuthenticationProvider(authentication.authenticationProvider)
        self.getMeInfo()
        
        self.navigationController?.navigationBar.barStyle = .Black
    }
    
    private func getMeInfo(){
        self.graphClient.me().request().getWithCompletion {
            (user: MSGraphUser?, error: NSError?) in
            if let graphError = error {
                print("Error:", graphError)
                dispatch_async(dispatch_get_main_queue(),{
                    NSLog("Graph Error")
                })
            }
            else {
                guard let userInfo = user else {
                    dispatch_async(dispatch_get_main_queue(),{
                        NSLog("User information loading failed.")
                    })
                    return
                }
                
                UserData.setGraphAccount(userInfo.mail)
                
                SipApiClient().getSipAccount()

                dispatch_async(dispatch_get_main_queue(),{
                    NSLog("User information loaded.")
                    self.nameLabel.text = userInfo.displayName
                    // userInfo.mail
                })
            }
        }
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
}

// MARK: Actions
private extension ProfileController{
    @IBAction func logout(sender: AnyObject){
        self.disconnect()
    }
}

// MARK: Graph Helper
private extension ProfileController{
    func disconnect(){
         authentication.disconnect()
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewControllerWithIdentifier("LoginController") as! LoginController
        self.presentViewController(vc, animated: true, completion: nil)
        
    }
}