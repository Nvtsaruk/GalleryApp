import UIKit
import SDWebImage

final class ImageView: UIView {
    
    lazy var photoImageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(photoImageView)
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(imageUrl: URL?, placeholderImage: UIImage?, heroId: String) {
        photoImageView.sd_setImage(with: imageUrl, placeholderImage: placeholderImage)
        photoImageView.contentMode = .scaleAspectFill
        photoImageView.clipsToBounds = true
        photoImageView.heroID = heroId
    }
    
    private func layout() {
        photoImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
