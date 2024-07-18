import UIKit

public protocol WebViewPresenterProtocol {
    var view: WebViewViewControllerProtocol? { get set }
    func viewDidLoad()
    func didUpdateProgressValue(_ newValue: Double)
    func code(from url: URL) -> String?
}

final class WebViewPresenter: WebViewPresenterProtocol {
    weak var view: WebViewViewControllerProtocol?
    var helper: AuthHelperProtocol
    
    init(authHelper: AuthHelperProtocol) {
        self.helper = authHelper
    }
    
    func viewDidLoad() {
        guard let request = helper.authRequest() else { return }
        view?.load(request: request)
    }
    
    func didUpdateProgressValue(_ newValue: Double) {
        let isLoaded = fabs(newValue - 1.0) <= 0.0001
        if isLoaded {
            view?.hideProgress()
        } else {
            view?.showProgress(Float(newValue))
        }
    }
    
    func code(from url: URL) -> String? {
        helper.code(from: url)
    }
}
