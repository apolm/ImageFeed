@testable import ImageFeed
import XCTest

final class WebViewTests: XCTestCase {
    func testViewControllerCallsViewDidLoad() {
        //given
        let viewController = WebViewViewController()
        let presenter = WebViewPresenterSpy()
        viewController.presenter = presenter
        presenter.view = viewController
        
        //when
        _ = viewController.view
        
        //then
        XCTAssertTrue(presenter.viewDidLoadCalled)
    }
    
    func testPresenterCallsLoadRequest() {
        //given
        let viewController = WebViewViewControllerSpy()
        let presenter = WebViewPresenter(authHelper: AuthHelper())
        viewController.presenter = presenter
        presenter.view = viewController
        
        //when
        presenter.viewDidLoad()
        
        //then
        XCTAssertTrue(viewController.loadRequestCalled)
    }
    
    func testProgressVisibleWhenLessThenOne() {
        //given
        let viewController = WebViewViewControllerSpy()
        let presenter = WebViewPresenter(authHelper: AuthHelper())
        viewController.presenter = presenter
        presenter.view = viewController
        
        let progress = 0.6
                
        //when
        presenter.didUpdateProgressValue(progress)
        
        //then
        XCTAssertTrue(viewController.progressIsVisible ?? false)
    }
    
    func testProgressHiddenWhenOne() {
        //given
        let viewController = WebViewViewControllerSpy()
        let presenter = WebViewPresenter(authHelper: AuthHelper())
        viewController.presenter = presenter
        presenter.view = viewController
        
        let progress = 1.0
                
        //when
        presenter.didUpdateProgressValue(progress)
        
        //then
        XCTAssertFalse(viewController.progressIsVisible ?? true)
    }
    
    func testAuthHelperAuthURL() {
        //given
        let configuration = AuthConfiguration.standard
        let authHelper = AuthHelper(configuration: configuration)
        
        //when
        let url = authHelper.authRequest()?.url
        let urlString = url?.absoluteString ?? ""
        
        //then
        XCTAssertTrue(urlString.contains(configuration.authorizeURLString))
        XCTAssertTrue(urlString.contains(configuration.accessKey))
        XCTAssertTrue(urlString.contains(configuration.redirectURI))
        XCTAssertTrue(urlString.contains("code"))
        XCTAssertTrue(urlString.contains(configuration.accessScope))
    }
    
    func testCodeFromURL() {
        //given
        let authHelper = AuthHelper()
        
        let testCode = "test code"
        
        var urlComponents = URLComponents(string: "https://unsplash.com/oauth/authorize/native")!
        urlComponents.queryItems = [URLQueryItem(name: "code", value: testCode)]
        let url = urlComponents.url!
        
        //when
        let code = authHelper.code(from: url)
        
        //then
        XCTAssertEqual(code, testCode)
    }
}
