import UIKit

final class PhotoCell: UICollectionViewCell {
    static let identifier = "PhotoCell"
    private let photoImageView = UIImageView()
    private let favIcon = UIImageView()
    override init(frame: CGRect) {
        super.init(frame: frame)
        configUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(index: String, item: PhotoArray, isFav: Bool) {
        photoImageView.sd_setImage(with: URL(string: item.urls.small))
        photoImageView.heroID = index
        favIcon.isHidden = !isFav
    }
    private func configUI() {
        addSubview(photoImageView)
        addSubview(favIcon)
        photoImageView.contentMode = .scaleAspectFill
        photoImageView.clipsToBounds = true
        photoImageView.layer.cornerRadius = 8
        photoImageView.snp.makeConstraints { make in
            make.left.right.top.bottom.equalToSuperview()
        }
        favIcon.image = UIImage(systemName: "star.fill")
        favIcon.tintColor = AppColors.activeButton.color
        favIcon.clipsToBounds = false
        favIcon.layer.shadowColor = UIColor.white.cgColor
        favIcon.layer.shadowOpacity = 1
        favIcon.layer.shadowOffset = CGSize.zero
        favIcon.layer.shadowRadius = 1
        favIcon.snp.makeConstraints { make in
            make.right.top.equalToSuperview().inset(5)
            make.height.width.equalTo(16)
        }
        
    }

}
