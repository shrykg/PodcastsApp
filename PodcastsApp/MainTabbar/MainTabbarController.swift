//
//  MainTabbarController.swift
//  PodcastsApp
//
//  Created by Shreyak Godala on 15/06/21.
//

import UIKit

class MainTabbarController: UITabBarController {
    
    var maximizedConstraint: NSLayoutConstraint!
    var minimizedConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        
        tabBar.tintColor = .purple
        viewControllers = [
            generateNavController(for: PodcastSearchController(), title: "Search", image: "magnifyingglass"),
            generateNavController(for: ViewController(), title: "Favorites", image: "play.circle.fill"),
            generateNavController(for: ViewController(), title: "Downloads", image: "rectangle.stack.fill")
        ]
        
        setUpPlayerView()
        
    }
    
    var pv = PlayerDetailsView()
    
    func setUpPlayerView() {
        
//        pv = PlayerDetailsView()
        pv.translatesAutoresizingMaskIntoConstraints = false
        view.insertSubview(pv, belowSubview: tabBar)
        
        pv.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        pv.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        maximizedConstraint = pv.topAnchor.constraint(equalTo: view.topAnchor, constant: view.frame.height)
        maximizedConstraint.isActive = true
        minimizedConstraint = pv.topAnchor.constraint(equalTo: tabBar.topAnchor,constant: -64)
        minimizedConstraint.isActive = false
//        pv.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        pv.heightAnchor.constraint(equalToConstant: view.frame.height).isActive = true
        
    }
    
    func minimizePlayer() {
        
        maximizedConstraint.isActive = false
        minimizedConstraint.isActive = true
        

        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseInOut) {
            self.view.layoutIfNeeded()
            self.pv.miniStack.alpha = 1
            self.pv.mainStack.alpha = 0
            self.tabBarController?.tabBar.frame.origin.y = self.view.frame.size.height - self.tabBar.frame.height
        }

        
    }
    
    func maximizePlayer(episode: Episode?) {
        
        maximizedConstraint.constant = 0
        maximizedConstraint.isActive = true
        minimizedConstraint.isActive = false
        if episode != nil {
            pv.episode = episode
        }
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseInOut) {
            self.view.layoutIfNeeded()
            self.pv.miniStack.alpha = 0
            self.pv.mainStack.alpha = 1
            self.tabBar.frame.origin.y = self.view.frame.size.height
        }
        
    }
    
    
    fileprivate func generateNavController(for rootViewController: UIViewController, title: String, image: String) -> UINavigationController {
        
        let navController = UINavigationController(rootViewController: rootViewController)
        rootViewController.navigationItem.title = title
        navController.navigationBar.prefersLargeTitles = true
        navController.tabBarItem.title = title
        navController.tabBarItem.image = UIImage(systemName: image)
        return navController
        
    }
    
}
