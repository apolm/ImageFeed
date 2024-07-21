import UIKit
 
final class TabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let imagesListViewController = ImagesListViewController()
        imagesListViewController.tabBarItem = UITabBarItem(
            title: "",
            image: UIImage(named: "TabEditorialActive"),
            selectedImage: nil
        )
        
        let profilePresenter = ProfilePresenter()
        let profileViewController = ProfileViewController()
        profileViewController.presenter = profilePresenter
        profileViewController.tabBarItem = UITabBarItem(
            title: "",
            image: UIImage(named: "TabProfileActive"),
            selectedImage: nil
        )
        profilePresenter.view = profileViewController
        
        viewControllers = [imagesListViewController, profileViewController]
        
        let appearance = UITabBarAppearance()
        appearance.backgroundColor = .ypBlack
        tabBar.standardAppearance = appearance
        tabBar.tintColor = .ypWhite
    }
}
