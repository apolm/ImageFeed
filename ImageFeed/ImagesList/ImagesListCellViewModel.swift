import UIKit

public struct ImagesListCellViewModel {
    let url: URL
    let imageHeight: CGFloat
    let isLiked: Bool
    let date: String
    
    public init(url: URL, imageHeight: CGFloat, isLiked: Bool, date: String) {
        self.url = url
        self.imageHeight = imageHeight
        self.isLiked = isLiked
        self.date = date
    }
}
