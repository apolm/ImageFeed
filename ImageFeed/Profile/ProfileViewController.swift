import UIKit

final class ProfileViewController: UIViewController {
    // MARK: - Private Properties
    private var avatarImage: UIImageView?
    private var logoutButton: UIButton?
    private var nameLabel: UILabel?
    private var loginLabel: UILabel?
    private var descriptionLabel: UILabel?
    
    // MARK: - Overridden Properties
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupAvatarImage()
        setupLogoutButton()
        setupNameLabel()
        setupLoginLabel()
        setupDescriptionLabel()
    }
    
    // MARK: - Private Methods
    private func setupAvatarImage() {
        let avatarImage = UIImageView(image: UIImage(named: "Avatar"))
        
        avatarImage.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(avatarImage)
        
        NSLayoutConstraint.activate([
            avatarImage.heightAnchor.constraint(equalToConstant: 70),
            avatarImage.widthAnchor.constraint(equalToConstant: 70),
            avatarImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
            avatarImage.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16)
        ])
        
        self.avatarImage = avatarImage
    }
    
    private func setupLogoutButton() {
        let logoutButton = UIButton.systemButton(
            with: UIImage(named: "Logout") ?? UIImage(),
            target: self,
            action: #selector(Self.logoutButtonDidTap))
        
        logoutButton.tintColor = .ypRed
        
        logoutButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(logoutButton)
        
        NSLayoutConstraint.activate([
            logoutButton.heightAnchor.constraint(equalToConstant: 44),
            logoutButton.widthAnchor.constraint(equalToConstant: 44),
            logoutButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16)
        ])
        if let avatarImage {
            logoutButton.centerYAnchor.constraint(equalTo: avatarImage.centerYAnchor).isActive = true
        }
        
        self.logoutButton = logoutButton
    }
    
    private func setupNameLabel() {
        let nameLabel = UILabel()
        
        nameLabel.text = "Екатерина Новикова"
        nameLabel.textColor = .ypWhite
        nameLabel.font = UIFont.systemFont(ofSize: 23, weight: .bold)
        
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(nameLabel)
        
        if let avatarImage {
            NSLayoutConstraint.activate([
                nameLabel.leadingAnchor.constraint(equalTo: avatarImage.leadingAnchor),
                nameLabel.topAnchor.constraint(equalTo: avatarImage.bottomAnchor, constant: 8)
            ])
        }
        
        self.nameLabel = nameLabel
    }
    
    private func setupLoginLabel() {
        let loginLabel = UILabel()
        
        loginLabel.text = "@ekaterina_nov"
        loginLabel.textColor = .ypGray
        loginLabel.font = UIFont.systemFont(ofSize: 13)
        
        loginLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(loginLabel)
        
        if let avatarImage {
            loginLabel.leadingAnchor.constraint(equalTo: avatarImage.leadingAnchor).isActive = true
        }
        if let nameLabel {
            loginLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8).isActive = true
        }
        
        self.loginLabel = loginLabel
    }
    
    private func setupDescriptionLabel() {
        let descriptionLabel = UILabel()
        
        descriptionLabel.text = "Hello, world!"
        descriptionLabel.textColor = .ypWhite
        descriptionLabel.font = UIFont.systemFont(ofSize: 13)
        
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(descriptionLabel)
        
        if let avatarImage {
            descriptionLabel.leadingAnchor.constraint(equalTo: avatarImage.leadingAnchor).isActive = true
        }
        if let loginLabel {
            descriptionLabel.topAnchor.constraint(equalTo: loginLabel.bottomAnchor, constant: 8).isActive = true
        }
        
        self.descriptionLabel = descriptionLabel
    }
    
    @objc
    private func logoutButtonDidTap() {
        
    }
}
