import UIKit
import WebKit

public protocol WebViewViewControllerProtocol: AnyObject {
    var presenter: WebViewPresenterProtocol? { get set }
    func load(request: URLRequest)
    func showProgress(_ newValue: Float)
    func hideProgress()
}

final class WebViewViewController: UIViewController & WebViewViewControllerProtocol {
    // MARK: - Public Properties
    weak var delegate: WebViewViewControllerDelegate?
    var presenter: WebViewPresenterProtocol?
    
    // MARK: - Private Properties
    private lazy var webView: WKWebView = {
        let webView = WKWebView()
        webView.accessibilityIdentifier = "UnsplashWebView"
        webView.backgroundColor = .ypWhite
        webView.translatesAutoresizingMaskIntoConstraints = false
        return webView
    }()
    private lazy var progressView: UIProgressView = {
        let progressView = UIProgressView(progressViewStyle: .bar)
        progressView.progressTintColor = .ypBlack
        progressView.translatesAutoresizingMaskIntoConstraints = false
        return progressView
    }()
    
    private var estimatedProgressObservation: NSKeyValueObservation?
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(webView)
        view.addSubview(progressView)
        setupConstraints()
        
        webView.navigationDelegate = self
        estimatedProgressObservation = webView.observe(\.estimatedProgress) { [weak self] _, _ in
            guard let self else { return }
            self.updateProgress()
        }
        
        presenter?.viewDidLoad()
    }
    
    // MARK: - WebViewViewControllerProtocol
    func load(request: URLRequest) {
        webView.load(request)
    }
    
    func showProgress(_ newValue: Float) {
        progressView.isHidden = false
        progressView.setProgress(newValue, animated: true)
    }
    
    func hideProgress() {
        progressView.isHidden = true
        progressView.progress = 0
    }
    
    // MARK: - Private Methods
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // Web View
            webView.topAnchor.constraint(equalTo: view.topAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            // Progress View
            progressView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            progressView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            progressView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    private func updateProgress() {
        presenter?.didUpdateProgressValue(webView.estimatedProgress)
    }
}

// MARK: - WKNavigationDelegate
extension WebViewViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView,
                 decidePolicyFor navigationAction: WKNavigationAction,
                 decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if let url = navigationAction.request.url,
           let code = presenter?.code(from: url) {
            delegate?.webViewViewController(self, didAuthenticateWithCode: code)
            decisionHandler(.cancel)
        } else {
            decisionHandler(.allow)
        }
    }
}
