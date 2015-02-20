import UIKit

class LoginVC: UIViewController , UITableViewDelegate
{

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addWallet: UIButton!
    
    let observer :NSNotificationCenter = NSNotificationCenter.defaultCenter()
    
    var deviceManager :plistFileManager = plistFileManager()
    var dataManager :CoreDataManager = CoreDataManager()
    var apiManager :APIManager = APIManager()
    
    var wallets :[Wallet] = [Wallet]()
    var selectedIndex :Int  = -1
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
                
        wallets  = dataManager.getWallets()
        
        if State.fromVC != SegueToLoginVC
        {
            State.fromVC = SegueToLoginVC
        }
        
        State.currentVC = SegueToLoginVC
        
        self.tableView.tableFooterView = UIView(frame: CGRectZero)
        self.tableView.layer.cornerRadius = 5
        self.tableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 15)
        
        observer.addObserver(self, selector: "logIn:", name: "heartbeatSuccessed", object: nil)
        
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    
    
    @IBAction func addNewWallet(sender: AnyObject)
    {
        NSNotificationCenter.defaultCenter().postNotificationName("MenuPage", object: SegueToAddAccountVC )
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return wallets.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        var cell : WalletCell = self.tableView.dequeueReusableCellWithIdentifier("walletCell") as WalletCell
        var cellData  :Wallet = wallets[indexPath.row]
        cell.walletName.text = cellData.login as String
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        State.fromVC = SegueToLoginVC
        
        if State.currentServer != nil
        {
            State.currentWallet = wallets[indexPath.row]
            apiManager.heartbeat(State.currentServer!.protocolType, address: State.currentServer!.address, port: State.currentServer!.port)
            
            State.toVC = SegueToMessages
            NSNotificationCenter.defaultCenter().postNotificationName("MenuPage", object:SegueToDashboard )

        }
        else
        {
            State.toVC = SegueToServerVC
            NSNotificationCenter.defaultCenter().postNotificationName("MenuPage", object:SegueToServerVC )
        }
    }
    
    func logIn(notification: NSNotification)
    {
        if(notification.object  != nil)
        {
            var alert :UIAlertView = UIAlertView(title: "Status", message: "Login - Success", delegate: self, cancelButtonTitle: "OK")
            alert.message = (alert.message! + "\n" + "heartbeat - Success") as String
            
//            NSNotificationCenter.defaultCenter().postNotificationName("MenuPage", object:SegueToDashboard )

            //alert.show()

        }
    }
}