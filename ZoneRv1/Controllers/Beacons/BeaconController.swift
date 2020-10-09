//
//  BeaconController.swift
//  ZoneRv1
//
//  Created by Eddie Ruiz on 10/6/20.
//  Copyright © 2020 AI Nomads. All rights reserved.
//

import UIKit

import EstimoteProximitySDK
import UserNotifications
import WebKit
import Firebase

struct Content {
    let title: String
    let subtitle: String
 
}

class BeaconController: UICollectionViewController, UICollectionViewDelegateFlowLayout, UNUserNotificationCenterDelegate {

    var webView: WKWebView!
    
    var proximityObserver: ProximityObserver!

    var nearbyContent = [Content]()

    // IF YOU WANT TO REDIRECT USERS TO WEBSITE
    
//    override func loadView() {
//          let webConfiguration = WKWebViewConfiguration()
//          webView = WKWebView(frame: .zero, configuration: webConfiguration)
//          view = webView
//      }
    
    func checkIfUserIsLoggedIn(){
        print("checking if user is logged in ")
        print("\(String(describing: Auth.auth().currentUser?.uid))")
        if Auth.auth().currentUser?.uid == nil {
            print("entro")
            print("\(String(describing: Auth.auth().currentUser?.uid))")
            DispatchQueue.main.async {
                let nav = UINavigationController(rootViewController: LoginController())
                if #available(iOS 13.0, *) {
                    nav.isModalInPresentation = true
                }
                nav.modalPresentationStyle = .fullScreen
                self.present(nav, animated: true, completion: nil)
            }
            print("DEBUG: USER NOT LOGGED IN...")
        } else{
            print("nahhh nahhh")
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkIfUserIsLoggedIn()
        
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.delegate = self
        
        // Define the custom actions.
        let acceptAction = UNNotificationAction(identifier: "ACCEPT_ACTION",
              title: "Accept",
              options: UNNotificationActionOptions(rawValue: 0))
        
        
        print("-------------------\(acceptAction)--------------")
        let declineAction = UNNotificationAction(identifier: "DECLINE_ACTION",
              title: "Decline",
              options: UNNotificationActionOptions(rawValue: 0))
        // Define the notification type
        let meetingInviteCategory =
              UNNotificationCategory(identifier: "MEETING_INVITATION",
              actions: [acceptAction, declineAction],
              intentIdentifiers: [],
              hiddenPreviewsBodyPlaceholder: "",
              options: .customDismissAction)
        // Register the notification type.
        
        notificationCenter.setNotificationCategories([meetingInviteCategory])

        
        
        

        
        
        
        // MARK - ESTIMOTE CODE
        let estimoteCloudCredentials = CloudCredentials(appID: "multiplenotifications-d31", appToken: "98cc8787bd19cb1e591ab393be5c0a8b")

        proximityObserver = ProximityObserver(credentials: estimoteCloudCredentials, onError: { error in
            print("ProximityObserver error: \(error)")
        })

        let zone = ProximityZone(tag: "multiplenotifications-d31", range: ProximityRange.near)
        
        

               notificationCenter.requestAuthorization(options: [.alert, .sound]) { granted, error in
                   print("notifications permission granted = \(granted), error = \(error?.localizedDescription ?? "(none)")")
               }
        
        zone.onContextChange = { contexts in
            let content = UNMutableNotificationContent()
            
            self.nearbyContent = contexts.map {
                switch $0.attachments["multiplenotifications-d31/title"]! {
                case "livingroom":
                    
                
                    content.title = "Appetizer Deal"
                    content.body = "Would you like Calamari to start of? $12.99"
                    content.userInfo = ["MEETING_ID" : "123456789",
                                        "USER_ID" : "ABCD1234" ]
                    content.categoryIdentifier = "MEETING_INVITATION"
                    let request = UNNotificationRequest(identifier: "enter", content: content, trigger: nil)
                     notificationCenter.add(request, withCompletionHandler: nil)
             
//                                content.title = "AI Nomads Common Area"
//                                content.body = "Make sure to grab a beer on Tap or check out our library of books"
//
//                                content.sound = UNNotificationSound.default
//                                let request = UNNotificationRequest(identifier: "enter", content: content, trigger: nil)
//                                notificationCenter.add(request, withCompletionHandler: nil)
//
//                                let urlString = "https://ai-nomads.com/"
//
//                                let url = URL(string: urlString)
//
//
//
//                                let requestObject = URLRequest(url: url!)
//
//
//
//                                self.webView.load(requestObject)
                                

                    
                    return Content(title: $0.attachments["multiplenotifications-d31/title"]!, subtitle: $0.deviceIdentifier)
            
                case "juan" :
                    
                    content.title = "You are near juans restaurant"
                    content.body = "Would you like Calamari to start of? $12.99"
                    content.userInfo = ["MEETING_ID" : "123456789",
                                        "USER_ID" : "ABCD1234" ]
                    content.categoryIdentifier = "MEETING_INVITATION"
                    let request = UNNotificationRequest(identifier: "enter", content: content, trigger: nil)
                     notificationCenter.add(request, withCompletionHandler: nil)
                    
                    
                 return Content(title: $0.attachments["multiplenotifications-d31/title"]!, subtitle: $0.deviceIdentifier)
                    
                    
                    
                case "mint":
                                        content.title = "Need another drink?"
                                        content.body = "Would you like another mimosa??"
                                        content.userInfo = ["MEETING_ID" : "123456789",
                                                            "USER_ID" : "ABCD1234" ]
                                        content.categoryIdentifier = "MEETING_INVITATION"
                                        let request = UNNotificationRequest(identifier: "enter", content: content, trigger: nil)
                                         notificationCenter.add(request, withCompletionHandler: nil)
//                                content.title = "AI Nomads Terrace"
//                                content.body = "You have entered the terrace, would you like to order a drink?"
//
//                                content.sound = UNNotificationSound.default
//                                let request = UNNotificationRequest(identifier: "enter", content: content, trigger: nil)
//                                notificationCenter.add(request, withCompletionHandler: nil)
//
//                                let urlString = "https://www.ai-nomads.com/book-online"
//
//                                let url = URL(string: urlString)
//
//
//
//                                let requestObject = URLRequest(url: url!)
//                                self.webView.load(requestObject)
//
                    return Content(title: $0.attachments["multiplenotifications-d31/title"]!, subtitle: $0.deviceIdentifier)
                    
                default:
                    return Content(title: $0.attachments["multiplenotifications-d31/title"]!, subtitle: $0.deviceIdentifier)
                }
                
            }

            self.collectionView?.reloadSections(IndexSet(integer: 0))
        }

        
                zone.onEnter = { context in
                
                    print("ENTROOOOOOOO")
                    let content = UNMutableNotificationContent()
                    content.title = "Welcome to Juans Restaurant"
                    content.body = "We see you are here, someeone will be right with you!"
        
                    content.sound = UNNotificationSound.default
                    let request = UNNotificationRequest(identifier: "enter", content: content, trigger: nil)
                    notificationCenter.add(request, withCompletionHandler: nil)
                }
                zone.onExit = { context in
                    print("BYEEEEEE")
                    let content = UNMutableNotificationContent()
                    content.title = "Thank you for coming to Tap 42"
                    content.body = "Hope to see you soon"
                    content.sound = UNNotificationSound.default
                    let request = UNNotificationRequest(identifier: "exit", content: content, trigger: nil)
                    notificationCenter.add(request, withCompletionHandler: nil)
                }
        
        
        proximityObserver.startObserving([zone])
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return nearbyContent.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ContentCell", for: indexPath)

        let titleLabel = cell.viewWithTag(1) as! UILabel
        
        
        let subtitleLabel = cell.viewWithTag(2) as! UILabel

        let title = nearbyContent[indexPath.item].title
        let subtitle = nearbyContent[indexPath.item].subtitle

        cell.backgroundColor = Utils.color(forColorName: title)
        

        titleLabel.text = title
        subtitleLabel.text = subtitle
       
        if titleLabel.text == "livingroom" {
            titleLabel.text = "You are at Tap 42 outside area"
            subtitleLabel.text = "Deal of the day: Brunch Mimosas"
            
        }
        
        
       if titleLabel.text == "mint" {
           titleLabel.text = "Novechento"
           subtitleLabel.text = "Deal of the day: Pizza"
           
       }
    
        
        if titleLabel.text == "blueberry" {
            titleLabel.text = "Juans Restaurant"
            subtitleLabel.text = "Deal of the day: Steak"
            
        }

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let maxWidth = collectionView.frame.width - 20
        let maxHeight = collectionView.frame.height - (collectionView.layoutMargins.top + collectionView.layoutMargins.bottom)
        let singleCellHeight = maxHeight / CGFloat(nearbyContent.count) - (collectionViewLayout as! UICollectionViewFlowLayout).minimumLineSpacing

        return CGSize(width: maxWidth, height: singleCellHeight)
    }
}

extension ViewController: UNUserNotificationCenterDelegate {

    // Needs to be implemented to receive notifications both in foreground and background
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([UNNotificationPresentationOptions.alert, UNNotificationPresentationOptions.sound])
    }
    
    
    
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
           didReceive response: UNNotificationResponse,
           withCompletionHandler completionHandler:
             @escaping () -> Void) {
           
       // Get the meeting ID from the original notification.
       let userInfo = response.notification.request.content.userInfo
        
        
        
       let meetingID = userInfo["MEETING_ID"] as! String
       let userID = userInfo["USER_ID"] as! String
        
        
        if meetingID == "MINT_AI" {
                   switch response.actionIdentifier {
                   case "ACCEPT_ACTION":
                
                        print("THEY ACCEPTED MINT" )
                       
//                         let urlString = "https://ai-nomads.com/"
//
//                                                        let url = URL(string: urlString)
//
//
//
//                                                        let requestObject = URLRequest(url: url!)
//
//
//
//                                                        self.webView.load(requestObject)
                      break
                        
                   case "DECLINE_ACTION":
                    print("THEY DECLINED")
                    break
                        
                   // Handle other actions…
                 
                   default:
                      break
                   }
            
              completionHandler()
        }
        
        
       // Perform the task associated with the action.
       switch response.actionIdentifier {
       case "ACCEPT_ACTION":
    
            print("THEY ACCEPTED" )
           
//             let urlString = "https://ai-nomads.com/"
//
//                                            let url = URL(string: urlString)
//
//
//
//                                            let requestObject = URLRequest(url: url!)
//
//
//
//                                            self.webView.load(requestObject)
          break
            
       case "DECLINE_ACTION":
        print("THEY DECLINED")
        break
            
       // Handle other actions…
     
       default:
          break
       }
        
       // Always call the completion handler when done.
       completionHandler()
    }
    
    
    
    
    
}

