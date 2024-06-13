import UIKit

final class AuthNavigationController: UINavigationController {
    override var childForStatusBarStyle: UIViewController? {
        return visibleViewController
    }
}
