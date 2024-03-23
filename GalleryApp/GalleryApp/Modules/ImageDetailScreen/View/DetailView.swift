import Foundation
import UIKit
import SDWebImage

final class DetailView: UIView {
    
    var isFavourite: Bool = false
    let stackView = UIStackView()
    
    let descriptionTitle = UILabel()
    let descriptionLabel = UILabel()
    let sizeTitle = UILabel()
    let sizeLabel = UILabel()
    let userTitle = UILabel()
    let userLabel = UILabel()
    let favButton = UIButton()
    let blankView = UIView()
    
    var viewModel: ImageDetailsScreenViewModel?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(favButton)
        configureStack()
        addSubview(stackView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureStack() {
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.spacing = 0
        stackView.addArrangedSubview(descriptionTitle)
        stackView.addArrangedSubview(descriptionLabel)
        stackView.addArrangedSubview(sizeTitle)
        stackView.addArrangedSubview(sizeLabel)
        stackView.addArrangedSubview(userTitle)
        stackView.addArrangedSubview(userLabel)
    }
    func configure(descLabelText: String, width: Int, height: Int, user: String, isFav: Bool) {
        descriptionTitle.text = "Description"
        descriptionTitle.textColor = AppColors.descriptionTitleTextColor.color
        
        descriptionLabel.lineBreakMode = .byWordWrapping
        descriptionLabel.numberOfLines = 3
        descriptionLabel.text = descLabelText
        descriptionLabel.textColor = AppColors.mainTextColor.color
        
        sizeTitle.text = "Size"
        sizeTitle.textColor = AppColors.descriptionTitleTextColor.color
        
        sizeLabel.text = "\(width)x\(height)px"
        sizeLabel.textColor = AppColors.mainTextColor.color
        
        userTitle.text = "User"
        userTitle.textColor = AppColors.descriptionTitleTextColor.color
        
        userLabel.text = user
        userLabel.textColor = AppColors.mainTextColor.color
        isFavourite = isFav
        setupButton()
        favButton.addTarget(self, action: #selector(self.favButtonAction), for: .touchUpInside)
    }
    
    private func setupButton() {
        let largeConfig = UIImage.SymbolConfiguration(pointSize: 20, weight: .semibold, scale: .large)
        let heartFill = UIImage(systemName: "heart.fill", withConfiguration: largeConfig)
        let heart = UIImage(systemName: "heart", withConfiguration: largeConfig)
        favButton.setImage(isFavourite ? heartFill : heart, for: .normal)
        favButton.tintColor = isFavourite ? .red : .lightGray
    }
    
    @objc func favButtonAction() {
        guard let regularUrl = viewModel?.photos[viewModel?.id ?? 0].urls.regular else { return }
        let regularImage = SDImageCache.shared.imageFromCache(forKey: regularUrl)?.jpegData(compressionQuality: 0.9)
        viewModel?.toggleFavourites(regularImage: regularImage)
        isFavourite.toggle()
        setupButton()
    }
    
    override func updateConstraints() {
        super.updateConstraints()
        guard let orientation = UIApplication.shared.windows.first?.windowScene?.interfaceOrientation else { return }
        if orientation.isLandscape {
            favButton.snp.makeConstraints { make in
                make.left.top.equalToSuperview().offset(10)
                make.height.width.equalTo(48)
            }
            stackView.snp.makeConstraints { make in
                make.left.right.equalToSuperview().inset(10)
                make.top.equalTo(favButton.snp.bottom)

            }
        } else {
            favButton.snp.makeConstraints { make in
                make.left.top.equalToSuperview().offset(10)
                make.height.width.equalTo(48)
            }
            stackView.snp.makeConstraints { make in
                make.left.right.equalToSuperview().inset(10)
                make.top.equalTo(favButton.snp.bottom)
            }
        }
    }
}
