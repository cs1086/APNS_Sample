//
//  NotificationService.swift
//  NotificationService
//
//  Created by SJ on 2022/11/1.
//
import UserNotifications

class NotificationService: UNNotificationServiceExtension {
    var contentHandler: ((UNNotificationContent) -> Void)?
    var bestAttemptContent: UNMutableNotificationContent?
    
    override init() {
        HttpRequest.get("NotificationService.init")
//        ReconnectSip.register()
        initSip()
    }
    
    override func didReceive(_ request: UNNotificationRequest, withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void) {
        print("####notification 收到訊息")
        self.contentHandler = contentHandler
        bestAttemptContent = (request.content.mutableCopy() as? UNMutableNotificationContent)
        HttpRequest.get("NotificationService.didReceive")

        FileReadWrite.write("寫入NotificationService...")
        
        if let bestAttemptContent = bestAttemptContent {
            // Modify the notification content here...
            bestAttemptContent.title = "\(bestAttemptContent.title) [modified]"
            bestAttemptContent.title = "被service更換title"
            DispatchQueue.main.asyncAfter(deadline: .now() + 30) {contentHandler(bestAttemptContent)}
//            contentHandler(bestAttemptContent)
            
        }
        
    }
    
    override func serviceExtensionTimeWillExpire() {
        HttpRequest.get("NotificationService.serviceExtensionTimeWillExpire")
        
        // Called just before the extension will be terminated by the system.
        // Use this as an opportunity to deliver your "best attempt" at modified content, otherwise the original push payload will be used.
        if let contentHandler = contentHandler, let bestAttemptContent =  bestAttemptContent {
            contentHandler(bestAttemptContent)
        }
    }

}
