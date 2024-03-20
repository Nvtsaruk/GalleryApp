import UIKit
import SnapKit

final class FooterView: UICollectionReusableView {
  static let identifier = "FooterView"

  private let activityIndicator = UIActivityIndicatorView()

  override init(frame: CGRect) {
    super.init(frame: frame)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
