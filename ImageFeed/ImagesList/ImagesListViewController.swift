import UIKit

final class ImagesListViewController: UIViewController {
    // MARK: - Private Properties
    private lazy var tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .plain)
        table.register(ImagesListCell.self, forCellReuseIdentifier: ImagesListCell.reuseIdentifier)
        table.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
        table.separatorStyle = .none
        table.backgroundColor = .ypBlack
        table.delegate = self
        table.dataSource = self
        table.translatesAutoresizingMaskIntoConstraints = false
                
        return table
    }()
    
    private var photos: [Photo] = []
    private let edges = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
    private let imagesListService = ImagesListService.shared
    private var imagesListServiceObserver: NSObjectProtocol?
    
    // MARK: - Overridden Properties
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(tableView)
        view.backgroundColor = .ypBlack
        
        setupConstraints()
        
        imagesListServiceObserver = NotificationCenter.default.addObserver(
            forName: ImagesListService.didChangeNotification,
            object: nil,
            queue: .main) { [weak self] _ in
                self?.updateTableViewAnimated()
            }
        
        imagesListService.fetchPhotosNextPage()
    }
    
    // MARK: - Private Methods
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
   private func imageHeight(_ size: CGSize) -> CGFloat {
        let viewWidth = tableView.bounds.width - edges.left - edges.right
        let scale = viewWidth / size.width
        return size.height * scale
    }
    
    private func updateTableViewAnimated() {
        let oldCount = photos.count
        let newCount = imagesListService.photos.count
        if oldCount < newCount {
            photos.append(contentsOf: imagesListService.photos.suffix(from: oldCount))
            
            tableView.performBatchUpdates {
                let indexPaths = (oldCount..<newCount).map { i in
                    IndexPath(row: i, section: 0)
                }
                tableView.insertRows(at: indexPaths, with: .automatic)
            } completion: { _ in }
        }
    }
}

// MARK: - UITableViewDataSource
extension ImagesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.reuseIdentifier, for: indexPath)
        let photo = photos[indexPath.row]
        
        guard let imageListCell = cell as? ImagesListCell,
              let url = URL(string: photo.regularImageURL) else {
            return UITableViewCell()
        }
        
        let viewModel = ImagesListCellViewModel(url: url,
                                                imageHeight: imageHeight(photo.size),
                                                isLiked: photo.isLiked,
                                                date: photo.createdAt)
        
        photos[indexPath.row].regularImageLoaded = false
        imageListCell.config(with: viewModel) { [weak self] in
            self?.photos[indexPath.row].regularImageLoaded = true
            self?.tableView.reloadRows(at: [indexPath], with: .automatic)
        }
        
        return imageListCell
    }
}

// MARK: - UITableViewDelegate
extension ImagesListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let image = UIImage(named: photos[indexPath.row])
//
//        let viewController = SingleImageViewController()
//        viewController.image = image
//        viewController.modalPresentationStyle = .fullScreen
//        
//        present(viewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let photo = photos[indexPath.row]
        return photo.regularImageLoaded ? (imageHeight(photo.size) + edges.top + edges.bottom) : 200
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row + 1 == imagesListService.photos.count {
            imagesListService.fetchPhotosNextPage()
        }
    }
}
