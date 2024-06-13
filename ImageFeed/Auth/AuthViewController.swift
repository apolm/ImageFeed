import UIKit

final class AuthViewController: UIViewController {
    // MARK: - Public Properties
    weak var delegate: AuthViewControllerDelegate?
    
    // MARK: - Private Properties
    private lazy var logoImage: UIImageView = {
        let image = UIImageView(image: UIImage(named: "UnsplashLogo"))
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    private lazy var loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Войти", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        button.setTitleColor(.ypBlack, for: .normal)
        button.backgroundColor = .ypWhite
        button.layer.cornerRadius = 16
        button.layer.masksToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(Self.loginButtonDidTap), for: .touchUpInside)
        return button
    }()
    private let showWebViewSegueIdentifier = "ShowWebView"
    
    // MARK: - Overridden Properties
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(logoImage)
        view.addSubview(loginButton)
        setupConstraints()
        
        configureBackButton()
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showWebViewSegueIdentifier {
            guard let viewController = segue.destination as? WebViewViewController else {
                assertionFailure("Invalid segue destination for ID: \(showWebViewSegueIdentifier)")
                return
            }
            viewController.delegate = self
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
    
    // MARK: - Private Methods
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            logoImage.heightAnchor.constraint(equalToConstant: 60),
            logoImage.widthAnchor.constraint(equalTo: logoImage.heightAnchor),
            logoImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImage.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            loginButton.heightAnchor.constraint(equalToConstant: 48),
            loginButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            loginButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            loginButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -90)
        ])
    }
    
    @objc
    private func loginButtonDidTap() {
        performSegue(withIdentifier: showWebViewSegueIdentifier, sender: nil)
    }
    
    private func configureBackButton() {
        navigationController?.navigationBar.backIndicatorImage = UIImage(named: "Backward")
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(named: "Backward")
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem?.tintColor = .ypBlack
    }
}

// MARK: - WebViewViewControllerDelegate
extension AuthViewController: WebViewViewControllerDelegate {
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String) {
        OAuthService.shared.fetchOAuthToken(code: code) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success:
                self.delegate?.didAuthenticate(self)
            case .failure(let failure):
                switch failure {
                case NetworkError.httpStatusCode(let code):
                    print("Error \(code) when receiving token.")
                default:
                    print(failure.localizedDescription)
                }
            }
        }
    }
}
