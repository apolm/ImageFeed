@testable import ImageFeed
import XCTest

class ImagesListPresenterTests: XCTestCase {
    var presenter: ImagesListPresenter!
    var view: ImagesListViewControllerSpy!
    
    override func setUp() {
        super.setUp()
        view = ImagesListViewControllerSpy()
        presenter = ImagesListPresenter(imagesListService: ImagesListServiceMock())
        view.presenter = presenter
        presenter.view = view
    }
    
    override func tearDown() {
        presenter = nil
        view = nil
        super.tearDown()
    }
    
    func testUpdateTabel() {
        presenter.viewDidLoad()
        
        XCTAssertEqual(presenter.photos.count, 1)
        XCTAssertTrue(view.rowsInserted)
    }
    
    func testSelectRow() {
        presenter.viewDidLoad()
        presenter.didSelectRow(at: IndexPath(row: 0, section: 0))
        
        XCTAssertTrue(view.viewPresented)
    }
    
    func testSetPhotoIsLiked() {
        presenter.viewDidLoad()
        let indexPath = IndexPath(row: 0, section: 0)
        let cell = ImagesListCell()
        
        XCTAssertFalse(presenter.photos[0].isLiked)
        
        presenter.toggleLike(at: indexPath, for: cell)
        
        XCTAssertTrue(presenter.photos[0].isLiked)
    }
}
