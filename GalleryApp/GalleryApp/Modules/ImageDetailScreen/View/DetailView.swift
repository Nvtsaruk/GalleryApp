import Foundation
import UIKit

final class DetailView: UIView {
    
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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layout() {
        descriptionTitle.snp.makeConstraints { make in
            make.left.top.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-10)
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
