import UIKit
 
final class TabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let imagesListPresenter = ImagesListPresenter()
        let imagesListViewController = ImagesListViewController()
        imagesListViewController.presenter = imagesListPresenter
        imagesListViewController.tabBarItem = UITabBarItem(
            title: "",
            image: UIImage(named: "TabEditorialActive"),
            selectedImage: nil
        )
        imagesListPresenter.view = imagesListViewController
        
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
