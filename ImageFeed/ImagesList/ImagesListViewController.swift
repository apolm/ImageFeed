import UIKit

class ImagesListViewController: UIViewController {
    @IBOutlet private var tableView: UITableView!
    
    private let photosName = Array(0..<20).map{ "\($0)" }
    private let edges = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
    
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMMM YYYY"
        return formatter
    } ()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = 200
        tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
    }
}

extension ImagesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photosName.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.reuseIdentifier, for: indexPath)
        
        guard let imageListCell = cell as? ImagesListCell else {
            return UITableViewCell()
        }
        
        configCell(for: imageListCell, with: indexPath)
        
        return imageListCell
    }
}

extension ImagesListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let image = UIImage(named: photosName[indexPath.row]) else {
            return 0
        }
        return imageHeight(image) + edges.top + edges.bottom
    }
}

extension ImagesListViewController {
    private func imageHeight(_ image: UIImage) -> CGFloat {
        let viewWidth = tableView.bounds.width - edges.left - edges.right
        let scale = viewWidth / image.size.width
        return image.size.height * scale
    }
    
    func configCell(for cell: ImagesListCell, with indexPath: IndexPath) {
        guard let image = UIImage(named: photosName[indexPath.row]) else {
            return
        }
        cell.cellImage.image = image
        
        cell.dateLabel.text = dateFormatter.string(from: Date())
        
        let imageName = indexPath.row % 2 == 0 ? "LikeOn" : "LikeOff"
        cell.likeButton.setImage(UIImage(named: imageName), for: .normal)
        
        // Gradient
        cell.cellImage.subviews.forEach { $0.removeFromSuperview() }
        
        let gradientContainerView = UIView(frame: cell.cellImage.bounds)
        
        let gradient = CAGradientLayer()
        gradient.frame = CGRect(x: 0, y: imageHeight(image) - 30, width: gradientContainerView.bounds.width, height: 30)
        gradient.colors = [UIColor.ypBlack.withAlphaComponent(0.2).cgColor, UIColor.ypBlack.withAlphaComponent(0).cgColor]
        gradient.startPoint = CGPoint(x: 0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1, y: 0.5)
        
        gradientContainerView.layer.insertSublayer(gradient, at: 0)
        
        cell.cellImage.addSubview(gradientContainerView)
    }
}
