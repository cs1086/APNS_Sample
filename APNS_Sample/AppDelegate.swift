//
//  AppDelegate.swift
//  APNS_Sample
//
//  Created by SJ on 2022/11/1.
//
import PushKit
import UIKit
import CallKit
var status: pj_status_t?
var tokenId:String=""
var uiView:UIView?
@main
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate, PKPushRegistryDelegate {

    var bestAttemptContent: UNMutableNotificationContent?
    var semaphore = DispatchSemaphore (value: 0)
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FileReadWrite.write("AppDelegate init...")
        
        let mainQueue = DispatchQueue.main
        let voipRegistry: PKPushRegistry = PKPushRegistry(queue: mainQueue)
        voipRegistry.delegate = self
        voipRegistry.desiredPushTypes = [PKPushType.voIP]
        //ReconnectSip.register()
        // Override point for customization after application launch.
        UNUserNotificationCenter.current().delegate=self
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert,.sound,.badge]) { success, _ in
            guard success else{
                return
            }
            print("####apns success")
        }
        application.registerForRemoteNotifications()
        ReconnectSip.register()
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        print("Token: ", deviceToken)
        
     // let chars = UnsafePointer<CChar>((deviceToken as NSData).bytes)
      var token = ""

      for i in 0..<deviceToken.count {
    //token += String(format: "%02.2hhx", arguments: [chars[i]])
       token = token + String(format: "%02.2hhx", arguments: [deviceToken[i]])
      }

      print("Registration succeeded!")
      print("Token: ", token)
        tokenId=token
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0) {
            HttpRequest.get("tokenId=\(tokenId)")
        }
     }
    
    //前景收到apns推播
    func userNotificationCenter(_ center: UNUserNotificationCenter,  willPresent notification: UNNotification, withCompletionHandler   completionHandler: @escaping (_ options:   UNNotificationPresentationOptions) -> Void) {
            print("Handle push from foreground")
            // custom code to handle push while app is in the foreground
            print("\(notification.request.content.userInfo)")
        ReconnectSip.register()
            HttpRequest.get("recieve.foreground")
    }

    //背景收到apns推播
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
            print("Handle push from background or closed")
            // if you set a member variable in didReceiveRemoteNotification, you  will know if this is from closed or background
            print("\(response.notification.request.content.userInfo)")
            
            HttpRequest.get("recieve.background")
    }
    func pushRegistry(_ registry: PKPushRegistry, didUpdate credentials: PKPushCredentials, for type: PKPushType) {
        print(credentials.token)
        FileReadWrite.write("Handle updated push credentials...")
        let deviceToken = credentials.token.map { String(format: "%02x", $0) }.joined()
        print("#### flutter plugin deviceToken = \(deviceToken)")

        let voipTokenStr = credentials.token.reduce("") { $0 + String(format: "%02X", $1) }
        print("#### flutter plugin VoIP Token: \(voipTokenStr)")
    }

    func pushRegistry(_ registry: PKPushRegistry, didInvalidatePushTokenFor type: PKPushType) {
        
    }
}

func initSip(){
    ReconnectSip.initPjsip()
    //uiView?.layer.backgroundColor=UIColor.red
}
