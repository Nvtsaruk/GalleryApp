import UIKit
import SDWebImage

final class ImageView: UIView {
    
    lazy var photoImageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(photoImageView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(imageUrl: URL?, placeholderImage: UIImage?, heroId: String) {
        photoImageView.sd_setImage(with: imageUrl, placeholderImage: placeholderImage)
        photoImageView.contentMode = .scaleAspectFill
        photoImageView.clipsToBounds = true
        photoImageView.heroID = heroId
        photoImageView.layer.cornerRadius = UIConstants.cornerRadius.rawValue
    }
    
    override func updateConstraints() {
        super.updateConstraints()
        guard let orientation = UIApplication.shared.windows.first?.windowScene?.interfaceOrientation else { return }
        if orientation.isLandscape {
            photoImageView.snp.makeConstraints { make in
                make.edges.equalToSuperview()
                make.width.equalToSuperview { view in
                    view.snp.height
                }
            }
        } else {
            photoImageView.snp.makeConstraints { make in
                make.edges.equalToSuperview()
                make.height.equalToSuperview { view in
                    view.snp.width
                }
            }
        }
    }
}
