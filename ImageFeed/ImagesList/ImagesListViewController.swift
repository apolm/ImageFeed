import UIKit

final class ImagesListViewController: UIViewController {
    // MARK: - IB Outlets
    @IBOutlet private var tableView: UITableView!
    
    // MARK: - Private Properties
    private let photosName = Array(0..<20).map{ "\($0)" }
    private let edges = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
    private let showSingleImageSegueIdentifier = "ShowSingleImage"
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = 200
        tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showSingleImageSegueIdentifier {
            guard let viewController = segue.destination as? SingleImageViewController,
                  let indexPath = sender as? IndexPath else {
                assertionFailure("Invalid segue destination")
                return
            }
            
            let image = UIImage(named: photosName[indexPath.row])
            viewController.image = image
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
    
    // MARK: - Private Methods
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
        performSegue(withIdentifier: showSingleImageSegueIdentifier, sender: indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let image = UIImage(named: photosName[indexPath.row]) else {
            return 0
        }
        return imageHeight(image) + edges.top + edges.bottom
    }
}
