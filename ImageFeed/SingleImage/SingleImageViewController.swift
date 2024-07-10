import UIKit
import Kingfisher

final class SingleImageViewController: UIViewController {
    // MARK: - Private Properties
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.minimumZoomScale = 0.05
        scrollView.maximumZoomScale = 1.25
        scrollView.delegate = self
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    private lazy var imageView: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.clipsToBounds = true
        image.isUserInteractionEnabled = true
        
        let doubleTapGesture = UITapGestureRecognizer(
            target: self,
            action: #selector(handleDoubleTap(_:)))
        doubleTapGesture.numberOfTapsRequired = 2
        image.addGestureRecognizer(doubleTapGesture)
        
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    private lazy var backwardButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "Backward"), for: .normal)
        button.addTarget(self, action: #selector(Self.backwardButtonDidTap), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    private lazy var sharingButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "Sharing"), for: .normal)
        button.addTarget(self, action: #selector(Self.sharingButtonDidTap), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    private lazy var stubImageView: UIImageView = {
        let image = UIImageView(image: UIImage(named: "StubLogo"))
        image.contentMode = .scaleAspectFit
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    private var image: UIImage?
    
    // MARK: - Public Properties
    var imageUrl: String? {
        didSet {
            guard isViewLoaded else { return }
            loadImage()
        }
    }
    
    // MARK: - Overridden Properties
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
                
        scrollView.addSubview(imageView)
        view.addSubview(scrollView)
        view.addSubview(backwardButton)
        view.addSubview(sharingButton)
        view.addSubview(stubImageView)
                
        sharingButton.isHidden = true
        
        view.backgroundColor = .ypBlack
        
        setupConstraints()
        loadImage()
    }
    
    // MARK: - Private Methods
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            backwardButton.heightAnchor.constraint(equalToConstant: 44),
            backwardButton.widthAnchor.constraint(equalToConstant: 44),
            backwardButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 8),
            backwardButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            
            sharingButton.heightAnchor.constraint(equalToConstant: 51),
            sharingButton.widthAnchor.constraint(equalToConstant: 51),
            sharingButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            sharingButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            
            stubImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stubImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func rescaleAndCenterImageInScrollView() {
        guard let image else { return }
        
        let minZoomScale = scrollView.minimumZoomScale
        let maxZoomScale = scrollView.maximumZoomScale
        
        view.layoutIfNeeded()
        let visibleRectSize = scrollView.bounds.size
        let imageSize = image.size
        let hScale = visibleRectSize.width / imageSize.width
        let vScale = visibleRectSize.height / imageSize.height
        let scale = min(maxZoomScale, max(minZoomScale, min(hScale, vScale)))
        scrollView.setZoomScale(scale, animated: false)
        
        scrollView.layoutIfNeeded()
        let newContentSize = scrollView.contentSize
        let x = (newContentSize.width - visibleRectSize.width) / 2
        let y = (newContentSize.height - visibleRectSize.height) / 2
        scrollView.setContentOffset(CGPoint(x: x, y: y), animated: false)
    }
    
    private func loadImage() {
        guard let imageUrl,
              let url = URL(string: imageUrl) else {
            return
        }
        
        UIBlockingProgressHUD.show()
        
        imageView.kf.setImage(with: url) { [weak self] result in
            UIBlockingProgressHUD.dismiss()
            
            guard let self else { return }
            
            switch result {
            case .success(let imageResult):
                self.image = imageResult.image
                self.imageView.frame.size = imageResult.image.size
                self.rescaleAndCenterImageInScrollView()
                self.sharingButton.isHidden = false
                self.stubImageView.isHidden = true
            case .failure(let error):
                ErrorHandler.printError(error, origin: "SingleImageViewController.loadImage")
                self.showError(error)
            }
        }
    }
    
    private func showError(_ error: Error) {
        let alertController = UIAlertController(title: "Что-то пошло не так",
                                                message: "Попробовать ещё раз?",
                                                preferredStyle: .alert)
        let dismissAction = UIAlertAction(title: "Не надо", style: .default)
        alertController.addAction(dismissAction)
        
        let retryAction = UIAlertAction(title: "Повторить", style: .default) { [weak self] _ in
            self?.loadImage()
        }
        alertController.addAction(retryAction)
        
        self.present(alertController, animated: true)
    }
    
    @objc
    private func backwardButtonDidTap() {
        dismiss(animated: true)
    }
    
    @objc
    private func sharingButtonDidTap() {
        guard let image else { return }
        let share = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        present(share, animated: true)
    }
    
    @objc private func handleDoubleTap(_ sender: UITapGestureRecognizer) {
        UIView.animate(withDuration: 0.5) { [weak self] in
            self?.rescaleAndCenterImageInScrollView()
        }
    }
}

// MARK: - UIScrollViewDelegate
extension SingleImageViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        imageView
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        let verticalInset = max((scrollView.bounds.height - scrollView.contentSize.height) / 2, 0)
        let horizontalInset = max((scrollView.bounds.width - scrollView.contentSize.width) / 2, 0)
                
        scrollView.contentInset = UIEdgeInsets(
            top: verticalInset,
            left: horizontalInset,
            bottom: verticalInset,
            right: horizontalInset)
    }
}
