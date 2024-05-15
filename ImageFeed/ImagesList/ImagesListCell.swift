import UIKit

final class ImagesListCell: UITableViewCell {
    // MARK: - IB Outlets
    @IBOutlet private var cellImage: UIImageView!
    @IBOutlet private var likeButton: UIButton!
    @IBOutlet private var dateLabel: UILabel!
    
    // MARK: - Public Properties
    static let reuseIdentifier = "ImagesListCell"
    
    // MARK: - Private Properties
    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMMM YYYY"
        return formatter
    } ()
    
    // MARK: - Public Methods
    func config(with model: ImagesListCellViewModel) {
        cellImage.image = model.image
        dateLabel.text = ImagesListCell.dateFormatter.string(from: model.date)
        
        let buttonImage = UIImage(named: model.isFavorite ? "LikeOn" : "LikeOff")
        likeButton.setImage(buttonImage, for: .normal)
        
        // Gradient
        cellImage.subviews.forEach { $0.removeFromSuperview() }
        
        let gradientContainerView = UIView(frame: cellImage.bounds)
        
        let gradient = CAGradientLayer()
        gradient.frame = CGRect(x: 0,
                                y: model.imageHeight - 30,
                                width: gradientContainerView.bounds.width,
                                height: 30)
        gradient.colors = [UIColor.ypBlack.withAlphaComponent(0.2).cgColor,
                           UIColor.ypBlack.withAlphaComponent(0).cgColor]
        gradient.startPoint = CGPoint(x: 0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1, y: 0.5)
        
        gradientContainerView.layer.insertSublayer(gradient, at: 0)
        
        cellImage.addSubview(gradientContainerView)
    }
}
