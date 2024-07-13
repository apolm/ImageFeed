import UIKit
import Kingfisher

final class ProfileViewController: UIViewController {
    // MARK: - Private Properties
    private lazy var avatarImage: UIImageView = {
        let image = UIImageView(image: UIImage(named: "StubAvatar"))
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    private lazy var logoutButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "Logout"), for: .normal)
        button.addTarget(self, action: #selector(Self.logoutButtonDidTap), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .ypWhite
        label.font = UIFont.systemFont(ofSize: 23, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private lazy var loginLabel: UILabel = {
        let label = UILabel()
        label.textColor = .ypGray
        label.font = UIFont.systemFont(ofSize: 13)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.textColor = .ypWhite
        label.font = UIFont.systemFont(ofSize: 13)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let profileService = ProfileService.shared
    private let profileImageService = ProfileImageService.shared
    private var profileImageServiceObserver: NSObjectProtocol?
    private var logoutService = ProfileLogoutService.shared
    
    // MARK: - Overridden Properties
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(avatarImage)
        view.addSubview(logoutButton)
        view.addSubview(nameLabel)
        view.addSubview(loginLabel)
        view.addSubview(descriptionLabel)
        view.backgroundColor = .ypBlack
        
        setupConstraints()
        
        if let profile = profileService.profile {
            updateProfileDetails(profile: profile)
        }
        
        profileImageServiceObserver = NotificationCenter.default.addObserver(
            forName: ProfileImageService.didChangeNotification,
            object: nil,
            queue: .main) { [weak self] _ in
                guard let self else { return }
                self.updateAvatar()
            }
        updateAvatar()
    }
    
    // MARK: - Private Methods
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            avatarImage.heightAnchor.constraint(equalToConstant: 70),
            avatarImage.widthAnchor.constraint(equalToConstant: 70),
            avatarImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
            avatarImage.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            
            logoutButton.heightAnchor.constraint(equalToConstant: 44),
            logoutButton.widthAnchor.constraint(equalToConstant: 44),
            logoutButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            logoutButton.centerYAnchor.constraint(equalTo: avatarImage.centerYAnchor),
            
            nameLabel.leadingAnchor.constraint(equalTo: avatarImage.leadingAnchor),
            nameLabel.topAnchor.constraint(equalTo: avatarImage.bottomAnchor, constant: 8),
            
            loginLabel.leadingAnchor.constraint(equalTo: avatarImage.leadingAnchor),
            loginLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            
            descriptionLabel.leadingAnchor.constraint(equalTo: avatarImage.leadingAnchor),
            descriptionLabel.topAnchor.constraint(equalTo: loginLabel.bottomAnchor, constant: 8)
        ])
    }
    
    private func updateProfileDetails(profile: Profile) {
        nameLabel.text = profile.name
        loginLabel.text = profile.loginName
        if let bio = profile.bio {
            descriptionLabel.text = bio
        }
    }
    
    private func updateAvatar() {
        guard let avatarURL = profileImageService.avatarURL,
              let url = URL(string: avatarURL) else { return }
        
        let processor = RoundCornerImageProcessor(cornerRadius: 61)
        avatarImage.kf.setImage(with: url,
                                placeholder: UIImage(named: "StubAvatar"),
                                options: [.processor(processor),
                                          .cacheSerializer(FormatIndicatedCacheSerializer.png)])
    }
    
    @objc
    private func logoutButtonDidTap() {
        let alertController = UIAlertController(title: "Пока, пока!",
                                                message: "Уверены что хотите выйти?",
                                                preferredStyle: .alert)
        let yesAction = UIAlertAction(title: "Да", style: .default) { [weak self] _ in
            self?.logoutService.logout()
            
            if let window = UIApplication.shared.windows.first {
                window.rootViewController = SplashViewController()
            }
        }
        alertController.addAction(yesAction)
        
        let noAction = UIAlertAction(title: "Нет", style: .default)
        alertController.addAction(noAction)
        
        self.present(alertController, animated: true)
    }
}
