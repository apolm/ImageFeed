import ImageFeed
import Foundation

final class WebViewViewControllerSpy: WebViewViewControllerProtocol {
    var presenter: WebViewPresenterProtocol?
    var loadRequestCalled: Bool = false
    var progressIsVisible: Bool?
    
    func load(request: URLRequest) {
        loadRequestCalled = true
    }
    
    func showProgress(_ newValue: Float) {
        progressIsVisible = true
    }
    
    func hideProgress() {
        progressIsVisible = false
    }
}
