//
//  ATCClassicWalkthroughViewController.swift
//  DashboardApp
//
//  Created by Florian Marcu on 8/13/18.
//  Copyright © 2018 Instamobile. All rights reserved.
//

import UIKit

class ATCClassicWalkthroughViewController: UIViewController {
  @IBOutlet var containerView: UIView!
  @IBOutlet var imageContainerView: UIView!
  @IBOutlet var imageView: UIImageView!
  @IBOutlet var titleLabel: UILabel!
  @IBOutlet var subtitleLabel: UILabel!
  
  let model: ATCWalkthroughModel
  
  init(model: ATCWalkthroughModel,
       nibName nibNameOrNil: String?,
       bundle nibBundleOrNil: Bundle?) {
    self.model = model
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    navigationController?.navigationBar.isHidden = true
    navigationController?.navigationBar.barStyle = .black
    
    imageView.image = UIImage.localImage(model.icon, template: true)
    imageView.contentMode = .scaleAspectFill
    imageView.clipsToBounds = true
    imageView.tintColor = .white
    imageContainerView.backgroundColor = .clear
    
    titleLabel.text = model.title
    titleLabel.font = UIFont.boldSystemFont(ofSize: 20.0)
    titleLabel.textColor = .white
    
    subtitleLabel.attributedText = NSAttributedString(string: model.subtitle)
    subtitleLabel.font = UIFont.systemFont(ofSize: 14.0)
    subtitleLabel.textColor = .white
    
    
//        containerView.backgroundColor = UIColor(hexString: "#2aa348")
    containerView.backgroundColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
//    containerView.backgroundColor = #colorLiteral(red: 0.3788298006, green: 0.6222188498, blue: 0.2107681169, alpha: 1)
    

    
  }
}
