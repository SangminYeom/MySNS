//
//  MainTabController.swift
//  MySNS
//
//  Created by SANGMIN YEOM on 2022/01/13.
//

import UIKit
import Firebase

class MainTabController: UITabBarController {
    
    private var user:User? {
        didSet {
            guard let user = user else { return }
            configureViewControllers(withUser: user)
        }
    }
    
    // MARK: - lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        checkIfUserIsLoggedIn()
        fetchUser()

    }
    
    // MARK: - API
    func fetchUser() {
        UserService.fetchUser { user in
            self.user = user
        }
    }
    
    func checkIfUserIsLoggedIn() {
        // auth는 background thread로 실행되므로... main thread에서 logincontroller 실행해 주어야 함..
        if Auth.auth().currentUser == nil {
            DispatchQueue.main.async {
                
                let controller = LoginController()
                
                // authenticate(login)이 완료되면 실행될 delegate 설정
                controller.delegate = self
                
                let nav = UINavigationController(rootViewController: controller)
                nav.modalPresentationStyle = .fullScreen
                self.present(nav, animated: true, completion: nil)
            }
        }
    }
    
    // MARK: - Helpers
    func configureViewControllers(withUser user: User) {
        view.backgroundColor = .white
        
        self.tabBar.backgroundColor = UIColor(red: 17.0/255.0, green: 70.0/255.0, blue: 95.0/255.0, alpha: 0.1)
        self.tabBar.tintColor = .black
        
        let layout = UICollectionViewFlowLayout()
        
        let feed = templateNavigationController(unselectedImage: UIImage(named: "home_unselected")!, selectedImage: UIImage(named: "home_selected")!, rootViewController: FeedController(collectionViewLayout: layout))
        
        let search =  templateNavigationController(unselectedImage: UIImage(named: "search_unselected")!, selectedImage: UIImage(named: "search_selected")!, rootViewController: SearchController())
        
        let imageSelector = templateNavigationController(unselectedImage: UIImage(named: "plus_unselected")!, selectedImage: UIImage(named: "plus_unselected")!, rootViewController: ImageSelectorController())
        
        let notifications = templateNavigationController(unselectedImage: UIImage(named: "like_unselected")!, selectedImage: UIImage(named: "like_selected")!, rootViewController: NotificationController())
       
        let profileController = ProfileController(user: user)
        let profile = templateNavigationController(unselectedImage: UIImage(named: "profile_unselected")!, selectedImage: UIImage(named: "profile_selected")!, rootViewController: profileController)
         
        self.viewControllers = [feed, search, imageSelector, notifications, profile]
    }
    
    func templateNavigationController(unselectedImage: UIImage, selectedImage: UIImage, rootViewController:UIViewController) -> UINavigationController {
        
        let nav = UINavigationController(rootViewController: rootViewController)
        nav.tabBarItem.image = unselectedImage
        nav.tabBarItem.selectedImage = selectedImage
        nav.navigationBar.tintColor = .black
        
        return nav
    }
}

// MARK: - AuthenticationDelegate
extension MainTabController : AuthenticationDelegate {
    func authenticationDidComplete() {
        
        fetchUser()
        
        self.dismiss(animated: true, completion: nil)
        
    }
}
