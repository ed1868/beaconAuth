//
//  HomeController.swift
//  ZoneRv1
//
//  Created by Eddie Ruiz on 10/3/20.
//  Copyright © 2020 AI Nomads. All rights reserved.
//

import UIKit
import Firebase
import WebKit
import MapKit
import EstimoteProximitySDK
import UserNotifications



class HomeController: UIViewController, UNUserNotificationCenterDelegate{
    
    //MARK - PROPERTIES
    var webView: WKWebView!
    
    var proximityObserver: ProximityObserver!

    private let mapView = MKMapView()
    private let locationManager = CLLocationManager()
    // MARK - LIFECYCLE
    
    // MARK - HELPERS
    override func  viewDidLoad() {
        super.viewDidLoad()
        checkIfUserIsLoggedIn()
        enableLocationServices()
        
        
        // MARK - NOTIFICATIONS AND ESTIMOTE SDK IMPLEMENTATION
        
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
        
        print("-------\(proximityObserver)---NIIIGEEH-------")
        
        
        let zone = ProximityZone(tag: "multiplenotifications-d31", range: ProximityRange.far)
        
        print("ey youuu----\(zone)")
        
        notificationCenter.requestAuthorization(options: [.alert, .sound]) { granted, error in
            print("notifications permission granted = \(granted), error = \(error?.localizedDescription ?? "(none)")")
        }
        
//        zone.onContextChange = { contexts in
//            let content = UNMutableNotificationContent()
//            print("1868-\(content)----")
//        }
        
        
                zone.onEnter = { context in
                
                    print("ENTROOOOOOOO")
                    let content = UNMutableNotificationContent()
                    content.title = "Welcome to Juans Restaurant"
                    content.body = "We see you are here, someeone will be right with you!"
        
                    content.sound = UNNotificationSound.default
                    let request = UNNotificationRequest(identifier: "enter", content: content, trigger: nil)
                    notificationCenter.add(request, withCompletionHandler: nil)
                }
        proximityObserver.startObserving([zone])
        
        // END OF USER NOTIFICATIONS AND ESTIMOTE BEACON INTERGRATIION
//        signOut()
        
    }
    
    // MARK - API
    
    func signOut(){
        do {
            try Auth.auth().signOut()
        } catch {
            print("DEBUG: ERRROORRR")
        }
    }

    
    func checkIfUserIsLoggedIn(){
        print("checking if user is logged in ")
        
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
            configureUI()
        }
    }

    
    // MARK HELPER FUNCTIONS
    
    func configureUI() {
        configureMapView()
      
    }
    
    func configureMapView(){
        view.addSubview(mapView)
        navigationController?.navigationBar.isHidden = true
        navigationController?.navigationBar.barStyle = .black
        mapView.frame = view.frame
        
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .follow
    }
}

// MARK - LOCATION SERVICES

extension HomeController : CLLocationManagerDelegate {


    func enableLocationServices(){
        
        locationManager.delegate = self
        
        switch CLLocationManager.authorizationStatus(){
        case .notDetermined:
        print("tryout")
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            break
        case .denied:
            break
        case .authorizedAlways:
            print("Varsity")
            locationManager.startUpdatingLocation()
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
        case .authorizedWhenInUse:
            print("Junior Varsity")
            locationManager.requestAlwaysAuthorization()
        @unknown default:
            break
        }
    }


    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            locationManager.requestAlwaysAuthorization()
        }
    }
}
