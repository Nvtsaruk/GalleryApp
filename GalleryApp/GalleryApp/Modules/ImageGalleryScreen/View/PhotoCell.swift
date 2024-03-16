import UIKit
final class PhotoCell: UICollectionViewCell {
    static let identifier = "PhotoCell"
    private let photoImageView = UIImageView()
    override init(frame: CGRect) {
        super.init(frame: frame)
        configUI()
    }
    func configure(url: URL, heroId: String) {
        photoImageView.sd_setImage(with: url)
        photoImageView.heroID = heroId
    }
    private func configUI() {
        addSubview(photoImageView)
        photoImageView.contentMode = .scaleAspectFill
        photoImageView.clipsToBounds = true
        photoImageView.layer.cornerRadius = 8
        photoImageView.snp.makeConstraints { make in
            make.left.right.top.bottom.equalToSuperview()
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
