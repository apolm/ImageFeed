import ImageFeed
import UIKit

class ImagesListPresenterSpy: ImagesListPresenterProtocol {
    var view: ImagesListViewControllerProtocol?
    var photos: [Photo] = []
    var viewDidLoadCalled = false
    
    func viewDidLoad() {
        viewDidLoadCalled = true
    }
    
    func didSelectRow(at indexPath: IndexPath) {
        
    }
    
    func heightForRow(at indexPath: IndexPath) -> CGFloat {
        return 10.0
    }
    
    func willDisplay(rowAt indexPath: IndexPath) {
        
    }
    
    func cellViewModel(for indexPath: IndexPath) -> ImagesListCellViewModel? {
        return ImagesListCellViewModel(url: URL(string: "https://api.unsplash.com")!,
                                       imageHeight: 10.0,
                                       isLiked: false,
                                       date: "01 January 2024")
    }
    
    func toggleLike(at indexPath: IndexPath, for cell: ImagesListCell) {
        
    }
}
