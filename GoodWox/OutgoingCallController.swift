import Foundation

var outgoingCallController: OutgoingCallController?

enum CallPhoneType {
    case SIP
    case NONSIP
}

var outgoingCallStateChanged: LinphoneCoreCallStateChangedCb = {
    (lc: COpaquePointer, call: COpaquePointer, callSate: LinphoneCallState,  message) in
    
    switch callSate{
    case LinphoneCallConnected:
        NSLog("outgoingCallStateChanged: LinphoneCallConnected")
        outgoingCallController?.statusLabel.text = "Connected"
        
    case LinphoneCallError: /**<The call encountered an error*/
        NSLog("outgoingCallStateChanged: LinphoneCallError")
        outgoingCallController?.dismissViewControllerAnimated(true, completion: nil)
        
    case LinphoneCallEnd:
        NSLog("outgoingCallStateChanged: LinphoneCallEnd")
        outgoingCallController?.dismissViewControllerAnimated(true, completion: nil)
        
    default:
        NSLog("outgoingCallStateChanged: Default call state")
    }
}

class OutgoingCallController: UIViewController{
    
    var phoneNumber: String?
    var calleeName: String?
    var phoneType: CallPhoneType = .SIP
    
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var statusLabel: UILabel!
    @IBOutlet var sipIcon: UIImageView!
    @IBOutlet var avatarImage: UIImageView!
    
    var lct: LinphoneCoreVTable = LinphoneCoreVTable()
    
    override func viewDidLoad() {
        NSLog("OutgoingCallController.viewDidLoad()")
        
        outgoingCallController = self
        
        self.navigationItem.hidesBackButton = true
        
        
        switch phoneType {
        case .SIP:
            sipIcon.hidden = false
            statusLabel.text = "SIP Dialing..."
            
        case .NONSIP:
            sipIcon.hidden = true
            statusLabel.text = "Dialing to \(phoneNumber!)..."
        }
        
        if let phone = phoneNumber {
            nameLabel.text = calleeName!
            linphone_core_invite(LinphoneManager.getLc(), phone)
            
            if let contact = ContactDbHelper.getContactBySip(phone){
                
                if contact.type == ContactType.COMPANY.hashValue {
                    let url = NSURL(string: String(format: MicrosoftGraphApi.userPhotoURL, contact.email!))
                    let request = NSMutableURLRequest(URL: url!)
                    
                    let authentication: Authentication = Authentication()
                    MSGraphClient.setAuthenticationProvider(authentication.authenticationProvider)
                    authentication.authenticationProvider?.appendAuthenticationHeaders(request, completion: { (request, error) in
                        
                        let token = request.valueForHTTPHeaderField("Authorization")!
                        let fetcher = BearerHeaderNetworkFetcher<UIImage>(URL: url!, token: token)
                        
                        self.avatarImage.hnk_setImageFromFetcher(fetcher)
                        
                        // Circular image
                        self.avatarImage.layer.cornerRadius = 60
                        self.avatarImage.clipsToBounds = true
                        
                    })
                }
                
            }
        }
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        NSLog("OutgoingCallController.prepareForSegue()")
    }
    
    @IBAction func hangUp(){
        NSLog("OutgoingCallController.hangUp()")
        finish()
        
    }
    
    func finish(){
        let call = linphone_core_get_current_call(LinphoneManager.getLc())
        if call != nil {
            let result = linphone_core_terminate_call(LinphoneManager.getLc(), call)
            NSLog("Terminated call result(outgoing): \(result)")
        }
        self.dismissViewControllerAnimated(false, completion: nil)
    }
    
    override func viewWillAppear(animated: Bool) {
        lct.call_state_changed = outgoingCallStateChanged
        linphone_core_add_listener(LinphoneManager.getLc(),  &lct)
    }
    
    override func viewDidDisappear(animated: Bool) {
        linphone_core_remove_listener(LinphoneManager.getLc(), &lct)
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
}
