@testable import ImageFeed
import XCTest

class ImagesListViewControllerTests: XCTestCase {
    var view: ImagesListViewController!
    var presenter: ImagesListPresenterSpy!
    
    override func setUp() {
        super.setUp()
        view = ImagesListViewController()
        presenter = ImagesListPresenterSpy()
        view.presenter = presenter
        presenter.view = view
        view.loadViewIfNeeded()
    }
    
    override func tearDown() {
        view = nil
        presenter = nil
        super.tearDown()
    }
    
    func testViewDidLoad() {
        XCTAssertNotNil(view.view)
        XCTAssertTrue(presenter.viewDidLoadCalled)
    }
    
    func testTableViewDataSource() {
        let tableView = view.tableView
        XCTAssertNotNil(tableView.dataSource)
        
        let rows = tableView.numberOfRows(inSection: 0)
        XCTAssertEqual(rows, 0)
    }
    
    func testTableViewDelegate() {
        let tableView = view.tableView
        XCTAssertNotNil(tableView.delegate)
        
        let height = tableView.delegate?.tableView?(tableView, heightForRowAt: IndexPath(row: 0, section: 0))
        XCTAssertEqual(height, 10.0)
    }
}

