import UIKit

public protocol ImagesListPresenterProtocol: AnyObject {
    var view: ImagesListViewControllerProtocol? { get set }
    var photos: [Photo] { get }
    
    func viewDidLoad()
    
    func didSelectRow(at indexPath: IndexPath)
    func heightForRow(at indexPath: IndexPath) -> CGFloat
    func willDisplay(rowAt indexPath: IndexPath)
    
    func cellViewModel(for indexPath: IndexPath) -> ImagesListCellViewModel?
    
    func toggleLike(at indexPath: IndexPath, for cell: ImagesListCell)
}

final class ImagesListPresenter: ImagesListPresenterProtocol {
    weak var view: ImagesListViewControllerProtocol?
    private(set) var photos: [Photo] = []
    
    private let edges = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
    private let imagesListService: ImagesListServiceProtocol
    private var imagesListServiceObserver: NSObjectProtocol?
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMMM YYYY"
        return formatter
    }()
    
    init(imagesListService: ImagesListServiceProtocol = ImagesListService.shared) {
        self.imagesListService = imagesListService
    }
    
    // MARK: - ImagesListPresenterProtocol
    func viewDidLoad() {
        imagesListServiceObserver = NotificationCenter.default.addObserver(
            forName: ImagesListService.didChangeNotification,
            object: nil,
            queue: .main) { [weak self] _ in
                self?.updateTableViewAnimated()
            }
        
        imagesListService.fetchPhotosNextPage()
    }
    
    func didSelectRow(at indexPath: IndexPath) {
        let photo = photos[indexPath.row]
        
        let viewController = SingleImageViewController()
        viewController.imageUrl = photo.fullImageURL
        viewController.modalPresentationStyle = .fullScreen
        
        view?.present(viewController: viewController)
    }
    
    func heightForRow(at indexPath: IndexPath) -> CGFloat {
        let photo = photos[indexPath.row]
        return imageHeight(photo.size) + edges.top + edges.bottom
    }
    
    func willDisplay(rowAt indexPath: IndexPath) {
        if indexPath.row + 1 == imagesListService.photos.count {
            imagesListService.fetchPhotosNextPage()
        }
    }
    
    func cellViewModel(for indexPath: IndexPath) -> ImagesListCellViewModel? {
        let photo = photos[indexPath.row]
        guard let url = URL(string: photo.regularImageURL) else { return nil }
        
        let viewModel = ImagesListCellViewModel(url: url,
                                                imageHeight: imageHeight(photo.size),
                                                isLiked: photo.isLiked,
                                                date: photo.createdAt.map { dateFormatter.string(from: $0) } ?? "")
        return viewModel
    }
    
    func toggleLike(at indexPath: IndexPath, for cell: ImagesListCell) {
        let photo = photos[indexPath.row]
        UIBlockingProgressHUD.show()
        
        imagesListService.changeLike(photoId: photo.id, isLike: !photo.isLiked) { [weak self] result in
            UIBlockingProgressHUD.dismiss()
            
            guard let self = self else { return }
            
            switch result {
            case .success:
                self.photos[indexPath.row].isLiked.toggle()
                cell.setIsLiked(self.photos[indexPath.row].isLiked)
            case .failure(let error):
                ErrorHandler.printError(error, origin: "ImagesListService.changeLike")
            }
        }
    }
    
    // MARK: - Private Methods
    private func imageHeight(_ size: CGSize) -> CGFloat {
        guard let view else { return CGFloat()}
        
        let viewWidth = view.tableWidth - edges.left - edges.right
        let scale = viewWidth / size.width
        return size.height * scale
    }
    
    private func updateTableViewAnimated() {
        let oldCount = photos.count
        let newCount = imagesListService.photos.count
        if oldCount < newCount {
            photos.append(contentsOf: imagesListService.photos.suffix(from: oldCount))
            let indexPaths = (oldCount..<newCount).map { IndexPath(row: $0, section: 0) }
            view?.insertRows(at: indexPaths)
        }
    }
}
