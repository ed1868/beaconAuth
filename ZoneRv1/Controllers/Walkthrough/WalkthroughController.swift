//
//  ViewController.swift
//  WalkthroughOnboarding
//
//  Created by Florian Marcu on 8/16/18.
//  Copyright © 2018 Instamobile. All rights reserved.
//

import UIKit

class WalkthroughController: UIViewController,  ATCWalkthroughViewControllerDelegate{
  let walkthroughs = [
    ATCWalkthroughModel(title: "Beacon Overview", subtitle: "Quickly visualize beacon locations around your Zone. Discover your own world in real time.", icon: "zonezone"),
    ATCWalkthroughModel(title: "Analytics", subtitle: "Dive deep into charts to extract valuable insights and come up with data driven product initiatives, to boost the success of your business.", icon: "bars-icon"),
//    ATCWalkthroughModel(title: "Dashboard Feeds", subtitle: "View your sales feed, orders, customers, products and employees.", icon: "activity-feed-icon"),
    ATCWalkthroughModel(title: "Get Notified", subtitle: "Beacon notifications provide a different and unique experience while letting you discover your world and new bussinesses in a whole new way", icon: "bell-icon"),
  ]
  
  override func viewDidLoad() {
    super.viewDidLoad()
    navigationController?.navigationBar.isHidden = true
    navigationController?.navigationBar.barStyle = .black
    
    let walkthroughVC = self.walkthroughVC()
    walkthroughVC.delegate = self
    self.addChildViewControllerWithView(walkthroughVC)
  }
  
  func walkthroughViewControllerDidFinishFlow(_ vc: ATCWalkthroughViewController) {
    UIView.transition(with: self.view, duration: 1, options: .transitionFlipFromLeft, animations: {
      vc.view.removeFromSuperview()
      let viewControllerToBePresented = HomeController()
      self.view.addSubview(viewControllerToBePresented.view)
    }, completion: nil)
  }
  
  fileprivate func walkthroughVC() -> ATCWalkthroughViewController {
    let viewControllers = walkthroughs.map { ATCClassicWalkthroughViewController(model: $0, nibName: "ATCClassicWalkthroughViewController", bundle: nil) }
    return ATCWalkthroughViewController(nibName: "ATCWalkthroughViewController",
                                        bundle: nil,
                                        viewControllers: viewControllers)
  }
}
