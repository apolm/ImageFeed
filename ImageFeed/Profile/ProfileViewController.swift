import UIKit

class ProfileViewController: UIViewController {
    // MARK: - IB Outlets
    @IBOutlet private var avatarImage: UIImageView!
    @IBOutlet private var logoutButton: UIButton!
    @IBOutlet private var nameLabel: UILabel!
    @IBOutlet private var loginLabel: UILabel!
    @IBOutlet private var descriptionLabel: UILabel!
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - IB Actions
    @IBAction private func logoutButtonDidTap() {
    }
}
