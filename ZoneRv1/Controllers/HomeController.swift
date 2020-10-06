//
//  HomeController.swift
//  ZoneRv1
//
//  Created by Eddie Ruiz on 10/3/20.
//  Copyright © 2020 AI Nomads. All rights reserved.
//

import UIKit
import Firebase
import MapKit

class HomeController: UIViewController{
    
    //MARK - PROPERTIES
    private let mapView = MKMapView()
    private let locationManager = CLLocationManager()
    // MARK - LIFECYCLE
    
    // MARK - HELPERS
    
    override func  viewDidLoad() {
        super.viewDidLoad()
        checkIfUserIsLoggedIn()
        enableLocationServices()
//        signOut()
        
    }
    // MRK - API
    
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
