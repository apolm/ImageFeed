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
    
    private let photosName = Array(0..<20).map{ "\($0)" }
    private let edges = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
    private let imagesListService = ImagesListService.shared
    
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
    
    private func imageHeight(_ image: UIImage) -> CGFloat {
        let viewWidth = tableView.bounds.width - edges.left - edges.right
        let scale = viewWidth / image.size.width
        return image.size.height * scale
    }
}

// MARK: - UITableViewDataSource
extension ImagesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photosName.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.reuseIdentifier, for: indexPath)
        
        guard let imageListCell = cell as? ImagesListCell,
              let image = UIImage(named: photosName[indexPath.row]) else {
            return UITableViewCell()
        }
        
        let viewModel = ImagesListCellViewModel(image: image,
                                                imageHeight: imageHeight(image),
                                                isFavorite: indexPath.row % 2 == 0,
                                                date: Date())
        imageListCell.config(with: viewModel)
        
        return imageListCell
    }
}

// MARK: - UITableViewDelegate
extension ImagesListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let image = UIImage(named: photosName[indexPath.row])
        
        let viewController = SingleImageViewController()
        viewController.image = image
        viewController.modalPresentationStyle = .fullScreen
        
        present(viewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let image = UIImage(named: photosName[indexPath.row]) else {
            return 0
        }
        return imageHeight(image) + edges.top + edges.bottom
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row + 1 == imagesListService.photos.count {
            imagesListService.fetchPhotosNextPage()
        }
    }
}
