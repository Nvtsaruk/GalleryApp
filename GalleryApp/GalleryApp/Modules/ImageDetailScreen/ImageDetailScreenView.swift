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
            make.left.right.equalTo(self.view)
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
            make.left.right.bottom.equalTo(self.view)
        }
        descriptionLabel.snp.makeConstraints { make in
            make.left.right.top.equalTo(detailView).offset(10)
        }
        detailView.backgroundColor = .lightGray
        descriptionLabel.text = viewModel?.photos[viewModel?.id ?? 0].description ?? "No description"
    }
}
