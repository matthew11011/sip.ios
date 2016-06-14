import Foundation

class OutgoingCallController: UIViewController{

    override func viewDidLoad() {
        NSLog("OutgoingCallController.viewDidLoad()")
        
        let calleeAccount = "0702552519"
        linphone_core_invite(LinphoneManager.lc, calleeAccount)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        NSLog("OutgoingCallController.prepareForSegue()")
    }
    
    @IBAction func hangUp(){
        NSLog("OutgoingCallController.hangUp()")
        
        linphone_core_terminate_all_calls(LinphoneManager.lc)
        self.dismissViewControllerAnimated(true, completion: {});
    }
}