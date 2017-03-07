//
//  FeedViewController.swift
//  Runner
//
//  Created by Thiago Heitling on 2017-02-14.
//  Copyright © 2017 Thiago Heitling. All rights reserved.
//

import UIKit
import CKCircleMenuView
import Firebase

class FeedViewController: UICollectionViewController, CKCircleMenuDelegate {
    
    var feedViewModel: FeedViewModel?
    
    var circleMenuView = CKCircleMenuView()
    
    let buttonRadius: CGFloat = 30
    
    lazy var plusButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("+", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 24)
        button.backgroundColor = UIColor(r: 0, g: 128, b: 255)
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = CGSize(width: 2, height: 2)
        button.layer.shadowOpacity = 0.5
        button.layer.shadowRadius = 5
        button.layer.cornerRadius = self.buttonRadius
        
        button.addTarget(self, action: #selector(plusButtonPressed), for: .touchUpInside)
        
        return button
    }()
    
    var plusButtonImages: [UIImage] = {
        
        var images = [UIImage]()
        
        if let runButtonImage = UIImage(named: "run-button"), let settingsButtonImage = UIImage(named: "settings-button"), let statsButtonImage = UIImage(named: "stats-button") {
            
            images = [runButtonImage, settingsButtonImage, statsButtonImage]
        }
        
        return images
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "FEED"
        
        if let feedVM = feedViewModel, let collectionView = feedViewModel?.collectionView {

            // CollectionView delegate and datasource are handled in the view model.
            self.collectionView?.delegate = feedVM
            self.collectionView?.dataSource = feedVM
            self.collectionView = collectionView
        }
        
        setupPlusButtonView()
        
        bind()
    }
    
    func bind() {
     
    }
    
    func setupPlusButtonView() {
        
        view.addSubview(plusButton)
        
        // x, y, width, height constraints
        plusButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -30).isActive = true
        plusButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -30).isActive = true
        plusButton.widthAnchor.constraint(equalToConstant: 2 * buttonRadius).isActive = true
        plusButton.heightAnchor.constraint(equalToConstant: 2 * buttonRadius).isActive = true
        
    }
    
    func plusButtonPressed() {

        animateButton()
        
        var tOptions = [String:AnyObject]()
        tOptions[CIRCLE_MENU_OPENING_DELAY] = 0.1 as AnyObject?
        tOptions[CIRCLE_MENU_MAX_ANGLE] = 90.0 as AnyObject?
        tOptions[CIRCLE_MENU_RADIUS] = 100.0 as AnyObject?
        tOptions[CIRCLE_MENU_DIRECTION] = Int(CircleMenuDirectionUp.rawValue) as AnyObject?
        tOptions[CIRCLE_MENU_BUTTON_BACKGROUND_NORMAL] = UIColor.init(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.4) as AnyObject?
        tOptions[CIRCLE_MENU_BUTTON_BACKGROUND_ACTIVE] = UIColor.init(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.8) as AnyObject?
        tOptions[CIRCLE_MENU_BUTTON_BORDER] = UIColor.white as AnyObject?
        tOptions[CIRCLE_MENU_DEPTH] = 1.0 as AnyObject?
        tOptions[CIRCLE_MENU_BUTTON_RADIUS] = 32 as AnyObject?
        tOptions[CIRCLE_MENU_BUTTON_BORDER_WIDTH] = 2.0 as AnyObject?
        tOptions[CIRCLE_MENU_TAP_MODE] = true as AnyObject?
        tOptions[CIRCLE_MENU_LINE_MODE] = false as AnyObject?
        tOptions[CIRCLE_MENU_BUTTON_TINT] = false as AnyObject?
        tOptions[CIRCLE_MENU_BACKGROUND_BLUR] = false as AnyObject?
        
        let tPoint = CGPoint(x: plusButton.frame.midX, y: plusButton.frame.midY)
        
        circleMenuView = CKCircleMenuView(atOrigin: tPoint, usingOptions: tOptions, withImageArray: self.plusButtonImages)
        view.addSubview(self.circleMenuView)
        circleMenuView.delegate = self
        circleMenuView.openMenu()
    }
    
    func animateButton() {

        UIView.animate(withDuration: 0.05, animations: {
            
            self.plusButton.transform = .init(scaleX: 0.8, y: 0.8)
        }) { _ in
            
            UIView.animate(withDuration: 0.05) {
                self.plusButton.transform = .identity
            }
        }
    }
    
    // MARK: Circle Menu Delegate
    
    func circleMenuActivatedButton(with anIndex: Int32) {
        
        switch anIndex {
        case 0:
            let runningVC = RunningViewController()
            runningVC.currentUser = feedViewModel?.currentUser
            navigationController?.present(runningVC, animated: true, completion: nil)
            break
        case 1:
            navigationController?.present(SettingsViewController(), animated: true, completion: nil)
            break
        case 2:
            navigationController?.present(RunningViewController(), animated: true, completion: nil)
            break
        default:
            // Do nothing
            break
        }
    }
    
    func circleMenuOpened() {
        // ...
    }
    
    func circleMenuClosed() {
        // ...
    }
}

extension UIView {
    
    func renderToImage() -> UIImage? {
        
        UIGraphicsBeginImageContext(self.frame.size)
        
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        self.layer.render(in: context)
        guard let image = UIGraphicsGetImageFromCurrentImageContext() else { return nil }
        UIGraphicsEndImageContext()
        return image
    }
}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
}
