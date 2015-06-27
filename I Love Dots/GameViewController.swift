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

//TODO: Make "press button" clickable
//TODO: Fix Crashes if the player touches off the ball

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

class GameViewController: UIViewController, ADBannerViewDelegate, GKGameCenterControllerDelegate {
    
    var localPlayer: GKLocalPlayer = GKLocalPlayer.localPlayer()
    
    
    //var bannerAd:ADBannerView = ADBannerView()
    var adBannerView: ADBannerView = ADBannerView()

    override func viewDidLoad() {
        
        localPlayer.authenticateHandler = {(ViewController, error) -> Void in if((ViewController) != nil) { self.presentViewController(ViewController!, animated: true, completion: nil) } }
        
        loadAds()
        super.viewDidLoad()

        NSNotificationCenter.defaultCenter().addObserver(self, selector: "showiAdBanner", name: "showiAdBanner", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "showLeaderboard", name: "showLeaderboard", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "hideiAdBanner", name: "hideiAdBanner", object: nil)
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
        
        // declare the Game Center viewController
        var gcViewController: GKGameCenterViewController = GKGameCenterViewController()
        gcViewController.gameCenterDelegate = self
        
        gcViewController.viewState = GKGameCenterViewControllerState.Leaderboards
        
        // Remember to replace "Best Score" with your Leaderboard ID (which you have created in iTunes Connect)
        gcViewController.leaderboardIdentifier = "Dots_infinite"
        // Finally present the Game Center ViewController
        self.showViewController(gcViewController, sender: self)
        self.navigationController?.pushViewController(gcViewController, animated: true)
        self.presentViewController(gcViewController, animated: true, completion: nil)
    }


}
