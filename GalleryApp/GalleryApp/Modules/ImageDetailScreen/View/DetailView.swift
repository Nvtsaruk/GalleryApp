import Foundation
import UIKit

final class DetailView: UIView {
    
    var isFav: Bool = false
    
    lazy var descriptionTitle: UILabel = {
            let label = UILabel()
            addSubview(label)
            return label
        }()
    lazy var descriptionLabel: UILabel = {
            let label = UILabel()
            addSubview(label)
            return label
        }()
    lazy var sizeTitle: UILabel = {
            let label = UILabel()
            addSubview(label)
            return label
        }()
    lazy var sizeLabel: UILabel = {
            let label = UILabel()
            addSubview(label)
            return label
        }()
    let favButton = UIButton()
    
    var viewModel: ImageDetailsScreenViewModel?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(favButton)
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func configure(descLabelText: String, width: Int, height: Int) {
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
        
        setupButton()
        favButton.addTarget(self, action: #selector(self.favButtonAction), for: .touchUpInside)
    }
    
    private func setupButton() {
        let largeConfig = UIImage.SymbolConfiguration(pointSize: 20, weight: .semibold, scale: .large)
        let heartFill = UIImage(systemName: "heart.fill", withConfiguration: largeConfig)
        let heart = UIImage(systemName: "heart", withConfiguration: largeConfig)
        favButton.setImage(isFav ? heartFill : heart, for: .normal)
        favButton.tintColor = isFav ? .red : .lightGray
    }
    
    @objc func favButtonAction() {
        isFav.toggle()
        setupButton()
        viewModel?.addToFavourites()
    }
    
    private func layout() {
        favButton.snp.makeConstraints { make in
            make.left.top.equalToSuperview().offset(10)
            make.height.width.equalTo(48)
        }
        descriptionTitle.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(10)
            make.top.equalTo(favButton.snp.bottom).offset(10)
        }
        descriptionLabel.snp.makeConstraints { make in
            make.left.equalTo(descriptionTitle)
            make.top.equalTo(descriptionTitle.snp.bottom).offset(10)
            make.right.equalToSuperview().offset(-5)
        }
        sizeTitle.snp.makeConstraints { make in
            make.left.equalTo(descriptionTitle)
            make.top.equalTo(descriptionLabel.snp.bottom).offset(10)
            make.right.equalToSuperview().offset(-10)
        }
        sizeLabel.snp.makeConstraints { make in
            make.left.equalTo(descriptionTitle)
            make.top.equalTo(sizeTitle.snp.bottom).offset(10)
            make.right.equalToSuperview().offset(-10)
        }
        
    }
    
}
