//
//  ViewController.swift
//  APNS_Sample
//
//  Created by SJ on 2022/11/1.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var videoView: UIView!
    @IBAction func clickButton(_ sender: UIButton) {
        //ReconnectSip.init()
//        ReconnectSip.anser_ok()
//        let userDefaults = UserDefaults(suiteName: "group.pjsip")
//              userDefaults?.set(videoView, forKey: "videoView")
        uiView?.backgroundColor = .green
        //NotificationCenter.default.post(name: Notification.Name("NotificationIdentifier"), object: nil)
    }
    
    @IBOutlet weak var button: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }


}

