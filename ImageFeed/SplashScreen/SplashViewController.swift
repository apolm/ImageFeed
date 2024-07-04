import UIKit

final class SplashViewController: UIViewController {
    // MARK: - Private Properties
    private lazy var logoImage: UIImageView = {
        let image = UIImageView(image: UIImage(named: "LaunchScreenLogo"))
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    private let tokenStorage = OAuthTokenStorage()
    private let profileService = ProfileService.shared
    private let profileImageService = ProfileImageService.shared
    
    // MARK: - Overridden Properties
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(logoImage)
        view.backgroundColor = .ypBlack
        setupConstraints()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let token = tokenStorage.token {
            fetchProfile(token)
        } else {
            let authViewController = AuthViewController()
            authViewController.delegate = self
            
            let navigationController = AuthNavigationController(rootViewController: authViewController)
            navigationController.modalPresentationStyle = .fullScreen
            
            present(navigationController, animated: true)
        }
    }
    
    // MARK: - Private Methods
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            logoImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImage.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func fetchProfile(_ token: String) {
        UIBlockingProgressHUD.show()
        
        profileService.fetchProfile(token) { [weak self] result in
            UIBlockingProgressHUD.dismiss()
            
            guard let self else { return }
            
            switch result {
            case .success(let profile):
                profileImageService.fetchProfileImageURL(username: profile.username) { imageResult in
                    if case .failure(let error) = imageResult {
                        ErrorHandler.printError(error, origin: "profileImageService.fetchProfileImageURL")
                    }
                }
                
                self.switchToTabBarController()
            case .failure(let error):
                ErrorHandler.printError(error, origin: "profileService.fetchProfile")
            }
        }
    }
    
    private func switchToTabBarController() {
        guard let window = UIApplication.shared.windows.first else {
            assertionFailure("Invalid window configuration")
            return
        }
           
        window.rootViewController = TabBarController()
    }
}

// MARK: - AuthViewControllerDelegate
extension SplashViewController: AuthViewControllerDelegate {
    func didAuthenticate(_ vc: AuthViewController) {
        vc.dismiss(animated: true)
        
        guard let token = tokenStorage.token else {
            return
        }
        
        fetchProfile(token)
    }
}
