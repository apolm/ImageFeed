import ImageFeed
import UIKit

class ImagesListViewControllerSpy: ImagesListViewControllerProtocol {
    var presenter: ImagesListPresenterProtocol?
    var tableWidth: CGFloat = 0.0
    
    var rowsInserted = false
    var viewPresented = false
    
    func insertRows(at indexPaths: [IndexPath]) {
        rowsInserted = true
    }
    
    func present(viewController: UIViewController) {
        viewPresented = true
    }
}
