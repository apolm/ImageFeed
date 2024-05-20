import UIKit

final class SingleImageViewController: UIViewController {
    // MARK: - IB Outlets
    @IBOutlet private var imageView: UIImageView!
    
    // MARK: - Public Properties
    var image: UIImage?
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.image = image
    }
    
    // MARK: - IB Actions
    @IBAction private func backwardButtonDidTap() {
        dismiss(animated: true)
    }
}
