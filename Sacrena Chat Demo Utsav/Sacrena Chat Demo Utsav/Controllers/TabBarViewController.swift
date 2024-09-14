//
//  TabBarViewController.swift
//  Sacrena Chat Demo Utsav
//
//  Created by Utsav  on 11/09/24.
//

import UIKit

class TabBarViewController: UITabBarController {

    private let chatList: UIViewController
    
    init(chatList: UIViewController) {
        self.chatList = chatList
        super.init(nibName: nil, bundle: nil) // Initialize superclass
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViewControllers()
    }
    
    private func setUpViewControllers() {
        let settings = SettingsViewController()
        
        // Configure the first navigation controller
        let nav1 = UINavigationController(rootViewController: chatList)
        nav1.tabBarItem = UITabBarItem(title: "Chat", image: UIImage(systemName: "message"), tag: 0)
        nav1.navigationBar.barTintColor = UIColor.systemBackground // Set background color for nav1
        
        // Configure the second navigation controller
        let nav2 = UINavigationController(rootViewController: settings)
        nav2.tabBarItem = UITabBarItem(title: "Settings", image: UIImage(systemName: "gear"), tag: 1)
        nav2.navigationBar.barTintColor = UIColor(named: "CustomColor") // Set background color for nav2
        
        viewControllers = [nav1, nav2]
    }
}
