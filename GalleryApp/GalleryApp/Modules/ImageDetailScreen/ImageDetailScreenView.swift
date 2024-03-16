import UIKit
import Combine
import SDWebImage

class ImageDetailScreenView: UIViewController {
    var viewModel: ImageDetailsScreenViewModel?
    private var cancellable: Set<AnyCancellable> = []
    lazy var photoImageView = UIImageView()
    lazy var detailView = UIView()
    lazy var descriptionLabel = UILabel()
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    private func setupUI() {
        view.backgroundColor = .white
        view.addSubview(photoImageView)
        photoImageView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.left.equalTo(self.view).offset(5)
            make.right.equalTo(self.view).offset(-5)
            make.height.equalTo(self.view.frame.width)
        }
        print(viewModel?.id)
        photoImageView.sd_setImage(with: URL(string: viewModel?.photos[viewModel?.id ?? 0].urls.regular ?? ""))
        photoImageView.contentMode = .scaleAspectFill
        photoImageView.clipsToBounds = true
        photoImageView.layer.cornerRadius = 8
        photoImageView.heroID = String(viewModel?.id ?? 0)
        detailView.addSubview(descriptionLabel)
        view.addSubview(detailView)
        detailView.snp.makeConstraints { make in
            make.top.equalTo(photoImageView.snp.bottom)
            make.left.equalTo(view).offset(5)
            make.right.equalTo(view).offset(-5)
            make.bottom.equalTo(self.view)
        }
        detailView.heroModifiers = [.fade, .translate(x:0, y:400)]
        descriptionLabel.snp.makeConstraints { make in
            make.left.top.equalTo(detailView).offset(10)
            make.right.equalTo(detailView).offset(-10)
        }
        detailView.backgroundColor = .lightGray
        descriptionLabel.lineBreakMode = .byWordWrapping
        descriptionLabel.numberOfLines = 3
        descriptionLabel.text = viewModel?.photos[viewModel?.id ?? 0].description ?? "No description"
    }
}
