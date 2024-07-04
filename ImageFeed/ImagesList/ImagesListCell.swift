import UIKit

final class ImagesListCell: UITableViewCell {
    // MARK: - Private Properties
    private lazy var cellImage: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        image.layer.cornerRadius = 16
        image.layer.masksToBounds = true
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    private lazy var likeButton: UIButton = {
        let button = UIButton(type: .custom)
        button.addTarget(self, action: #selector(Self.likeButtonDidTap), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .ypWhite
        label.font = UIFont.systemFont(ofSize: 13)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMMM YYYY"
        return formatter
    } ()
    
    // MARK: - Public Properties
    static let reuseIdentifier = "ImagesListCell"
        
    // MARK: - Public Methods
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(cellImage)
        contentView.addSubview(likeButton)
        contentView.addSubview(dateLabel)
        
        contentView.backgroundColor = .ypBlack
        
        backgroundColor = .ypBlack
        selectionStyle = .none
        
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func config(with model: ImagesListCellViewModel) {
        cellImage.image = model.image
        dateLabel.text = ImagesListCell.dateFormatter.string(from: model.date)
        
        let buttonImage = UIImage(named: model.isFavorite ? "LikeOn" : "LikeOff")
        likeButton.setImage(buttonImage, for: .normal)
        
        // Gradient
        cellImage.subviews.forEach { $0.removeFromSuperview() }
        
        cellImage.layoutIfNeeded()
        let gradientContainerView = UIView(frame: cellImage.bounds)
        
        let gradient = CAGradientLayer()
        gradient.frame = CGRect(x: 0,
                                y: model.imageHeight - 30,
                                width: gradientContainerView.bounds.width,
                                height: 30)
        gradient.colors = [UIColor.ypBlack.withAlphaComponent(0.2).cgColor,
                           UIColor.ypBlack.withAlphaComponent(0).cgColor]
        gradient.startPoint = CGPoint(x: 0.5, y: 1)
        gradient.endPoint = CGPoint(x: 0.5, y: 0)
        gradient.locations = [0.6, 0.9]
        
        gradientContainerView.layer.insertSublayer(gradient, at: 0)
        
        cellImage.addSubview(gradientContainerView)
    }
    
    // MARK: - Private Methods
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            cellImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            cellImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            cellImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            cellImage.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4),
            
            likeButton.heightAnchor.constraint(equalToConstant: 44),
            likeButton.widthAnchor.constraint(equalToConstant: 44),
            likeButton.trailingAnchor.constraint(equalTo: cellImage.trailingAnchor),
            likeButton.topAnchor.constraint(equalTo: cellImage.topAnchor),
            
            dateLabel.leadingAnchor.constraint(equalTo: cellImage.leadingAnchor, constant: 8),
            dateLabel.trailingAnchor.constraint(lessThanOrEqualTo: cellImage.trailingAnchor, constant: -8),
            dateLabel.bottomAnchor.constraint(equalTo: cellImage.bottomAnchor, constant: -8)
        ])
    }
    
    @objc
    private func likeButtonDidTap() {
        
    }
}
