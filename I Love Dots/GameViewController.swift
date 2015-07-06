//
//  GameViewController.swift
//  Dots!
//
//  Created by Chris Gilardi on 5/17/15.
//  Copyright (c) 2015 Chris Gilardi. All rights reserved.
//

import UIKit
import SpriteKit
import iAd
import GameKit
import GoogleMobileAds
import StoreKit


extension SKNode {
    class func unarchiveFromFile(file : String) -> SKNode? {
        if let path = NSBundle.mainBundle().pathForResource(file, ofType: "sks") {
            //let sceneData = NSData(contentsOfFile: path, options: .DataReadingMappedIfSafe, error: nil)
            let sceneData = NSData(contentsOfFile: path, options: NSDataReadingOptions.DataReadingMappedIfSafe, error: nil)
            let archiver = NSKeyedUnarchiver(forReadingWithData: sceneData!)
            
            archiver.setClass(self.classForKeyedUnarchiver(), forClassName: "SKScene")
            let scene = archiver.decodeObjectForKey(NSKeyedArchiveRootObjectKey) as! GameScene
            archiver.finishDecoding()
            return scene
        } else {
            return nil
        }
    }
}

class GameViewController: UIViewController, ADBannerViewDelegate, GKGameCenterControllerDelegate, GKMatchmakerViewControllerDelegate, GKMatchDelegate, SKPaymentTransactionObserver, SKProductsRequestDelegate, UIAlertViewDelegate {
    
    var localPlayer: GKLocalPlayer = GKLocalPlayer.localPlayer()
    var interstitial: GADInterstitial!
    let defaults = DotsCommon.userDefaults
    var product_id: NSString?
    
    //var bannerAd:ADBannerView = ADBannerView()
    var adBannerView: ADBannerView = ADBannerView()

    override func viewDidLoad() {
        
        product_id = "DotsAdless"
        
        interstitial = AMCreateAd()
        
        localPlayer.authenticateHandler = {(ViewController, error) -> Void in if((ViewController) != nil) { self.presentViewController(ViewController!, animated: true, completion: nil) } }
        
        loadAds()
        super.viewDidLoad()

        //SKPaymentQueue.defaultQueue().addTransactionObserver(self)
        
        
        
        //Setup Notification Center Listeners
        
        //Ads//
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "showiAdBanner", name: "showiAdBanner", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "hideiAdBanner", name: "hideiAdBanner", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "AMCreateAd", name: "AMCreateAd", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "AMShowAds", name: "AMShowAds", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "VShowAds", name: "VShowAds", object: nil)
        //Game Center//
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "showLeaderboard", name: "showLeaderboard", object: nil)
        //Sharing Button//
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "showSharingView", name: "showSharingView", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "buyAdless", name: "buyAdless", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "restorePurchase", name: "buyAdless", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "hostMultiplayerGame", name: "hostMultiplayerGame", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "showAlertView", name: "showAlertView", object: nil)
        
        
        
        //NSNotificationCenter.defaultCenter().postNotificationName("showiAdBanner", object: nil)
        if let scene = GameScene.unarchiveFromFile("GameScene") as? GameScene {
            // Configure the view.
            let skView = self.view as! SKView
            skView.showsFPS = false
            skView.showsNodeCount = false
            
            
            /* Sprite Kit applies additional optimizations to improve rendering performance */
            skView.ignoresSiblingOrder = true
            
            /* Set the scale mode to scale to fit the window */
            scene.scaleMode = .AspectFill

            skView.presentScene(scene)
        }
        
    }
    

    override func shouldAutorotate() -> Bool {
        return false
    }

    override func supportedInterfaceOrientations() -> Int {
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            return Int(UIInterfaceOrientationMask.Portrait.rawValue)
        } else {
            return Int(UIInterfaceOrientationMask.Portrait.rawValue)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    func bannerViewDidLoadAd(banner: ADBannerView!) {
        adBannerView.hidden = true
    }
    
    func bannerView(banner: ADBannerView!, didFailToReceiveAdWithError error: NSError!) {
        adBannerView.hidden = true
    }
    
    func loadAds(){
        adBannerView = ADBannerView(frame: CGRect.zeroRect)
        adBannerView.center = CGPoint(x: adBannerView.center.x, y: view.bounds.size.height - adBannerView.frame.size.height / 2)
        adBannerView.delegate = self
        adBannerView.hidden = true
        adBannerView.layer.zPosition = 10
        view.addSubview(adBannerView)
    }
    
    func showiAdBanner() {
        if adBannerView.bannerLoaded {
            adBannerView.hidden = false
        }
    }
    
    func hideiAdBanner() {
        adBannerView.hidden = true
    }
    
    func gameCenterViewControllerDidFinish(gameCenterViewController: GKGameCenterViewController!) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    func showLeaderboard() {
        println("Trying to show GKLeaderboard")
        // declare the Game Center viewController
        if GKLocalPlayer.localPlayer().authenticated {
            var gcViewController: GKGameCenterViewController = GKGameCenterViewController()
            gcViewController.gameCenterDelegate = self
        
            gcViewController.viewState = GKGameCenterViewControllerState.Leaderboards
        
            // Remember to replace "Best Score" with your Leaderboard ID (which you have created in iTunes Connect)
            gcViewController.leaderboardIdentifier = "timetrial_20"
            // Finally present the Game Center ViewController
            self.showViewController(gcViewController, sender: self)
            self.navigationController?.pushViewController(gcViewController, animated: true)
            self.presentViewController(gcViewController, animated: true, completion: nil)
        } else {
            let alert = UIAlertView(title: "Game Center Not Logged In", message: "You need to have game center enabled to use the Leaderboards/Achievements feature.", delegate: self, cancelButtonTitle: "Close")
            alert.show()
        }
    }
    
    func AMCreateAd() -> GADInterstitial {
        var ad = GADInterstitial(adUnitID: "ca-app-pub-1206890352094684/4884623048")
        var request = GADRequest()
        request.testDevices = ["74c2d2e1ae6dd8683b0a5ce977872e80", "kGADSimulatorID"]
        ad.loadRequest(request)
        
        return ad
    }
    
    func AMShowAds() {
        if self.interstitial.isReady {
            self.interstitial.presentFromRootViewController(self)
            self.interstitial = AMCreateAd()
        }
    }
    
    func VShowAds(){
        var sdk = VungleSDK.sharedSDK()
        sdk.playAd(self, error: nil)
    }
    
    func showSharingView(){
        let textToShare = "Check out the Game, \"I Love Dots\" On the App Store!"
        println("Called: showSharingView()")
        
        if let myWebsite = NSURL(string: "https://docs.google.com/forms/d/1btnq1WLFOQhh6rQGPYjm9R9vN2Amwey_ViLgxdy7JWk/viewform")
        {
            let objectsToShare = [textToShare, myWebsite]
            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            activityVC.popoverPresentationController?.sourceView = self.view
            activityVC.popoverPresentationController?.sourceRect = CGRect(origin: CGPointMake(CGRectGetMidX(self.view.frame), CGRectGetMaxY(self.view.frame)/4 + 125), size: CGSize(width: 0, height: 0))
            activityVC.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection.Up
            println("Presenting Share VC")
            self.presentViewController(activityVC, animated: true, completion: nil)
        }
    }
    
    func buyAdless(){
        println("About to fetch the products");
        // We check that we are allow to make the purchase.
        if (SKPaymentQueue.canMakePayments())
        {
            var productID: NSSet = NSSet(object: self.product_id!);
            var productsRequest: SKProductsRequest = SKProductsRequest(productIdentifiers: productID as Set<NSObject>);
            productsRequest.delegate = self;
            productsRequest.start();
            println("Fething Products");
        }else{
            println("can't make purchases");
        }
    }
    
    func buyProduct(product: SKProduct){
        println("Sending the Payment Request to Apple");
        var payment = SKPayment(product: product)
        SKPaymentQueue.defaultQueue().addPayment(payment);
        
    }
    
    func productsRequest (request: SKProductsRequest, didReceiveResponse response: SKProductsResponse) {
        println("got the request from Apple")
        var count : Int = response.products.count
        if (count>0) {
            var validProducts = response.products
            var validProduct: SKProduct = response.products[0] as! SKProduct
            if (validProduct.productIdentifier == self.product_id) {
                println(validProduct.localizedTitle)
                println(validProduct.localizedDescription)
                println(validProduct.price)
                buyProduct(validProduct);
            } else {
                println(validProduct.productIdentifier)
            }
        } else {
            println("nothing")
        }
    }
    
    func request(request: SKRequest!, didFailWithError error: NSError!) {
        println("La vaina fallo");
    }
    
    func paymentQueue(queue: SKPaymentQueue!, updatedTransactions transactions: [AnyObject]!)    {
        println("Received Payment Transaction Response from Apple");
        
        for transaction:AnyObject in transactions {
            if let trans:SKPaymentTransaction = transaction as? SKPaymentTransaction{
                switch trans.transactionState {
                case .Purchased:
                    println("Product Purchased");
                    SKPaymentQueue.defaultQueue().finishTransaction(transaction as! SKPaymentTransaction)
                    DotsCommon.userDefaults.setBool(true, forKey: "adless")
                    break;
                case .Failed:
                    println("Purchased Failed");
                    SKPaymentQueue.defaultQueue().finishTransaction(transaction as! SKPaymentTransaction)
                    break;
                case .Restored:
                    println("Purchase Restored")
                    SKPaymentQueue.defaultQueue().finishTransaction(transaction as! SKPaymentTransaction)
                    DotsCommon.userDefaults.setBool(true, forKey: "adless")
                default:
                    break;
                }
            }
        }
        
    }
    
    func restorePurchase() {
        SKPaymentQueue.defaultQueue().restoreCompletedTransactions()
        DotsCommon.userDefaults.setBool(true, forKey: "adless")
    }
    
    
    func hostMultiplayerGame() {
        var request = GKMatchRequest()
        request.minPlayers = 2
        request.maxPlayers = 2
        request.defaultNumberOfPlayers = 2
        request.inviteMessage = GKLocalPlayer.localPlayer().displayName + " wants to go head-to-head!"
        
        let mmvc = GKMatchmakerViewController(matchRequest: request)
        mmvc.matchmakerDelegate = self
        self.showViewController(mmvc, sender: self)
        self.presentViewController(mmvc, animated: true, completion: nil)
    }

    func matchmakerViewControllerWasCancelled(viewController: GKMatchmakerViewController!) {
        println("Cancelling")
        viewController.dismissViewControllerAnimated(true, completion: nil)
        /*
        self.dismissViewControllerAnimated(true, completion: ({
            var gvc = GameViewController();
            self.presentViewController(gvc, animated: true, completion: nil)}))*/
    }
    
    func matchmakerViewController(viewController: GKMatchmakerViewController!, didFailWithError error: NSError!) {
        println("Could not connect: \(error.description)")
    }
    
    func showAlertView() {
        let alert = UIAlertView(title: "This is Beta!", message: "This feature will work in the release version of the game. For now, though, it does not", delegate: self, cancelButtonTitle: "Close")
        alert.show()
    }

}
