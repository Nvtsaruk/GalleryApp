import UIKit
import Combine
import SDWebImage

enum LabelType {
    case title
    case label
}

class ImageDetailScreenView: UIViewController {
    var viewModel: ImageDetailsScreenViewModel?
    private var cancellable: Set<AnyCancellable> = []
    lazy var photoImageView = UIImageView()
    lazy var imageView = ImageView()
    lazy var detailView = DetailView()
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupGestures()
        observe()
    }
    
    private func setupGestures() {
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture))
        swipeRight.direction = .right
        self.view.addGestureRecognizer(swipeRight)
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture))
        swipeDown.direction = .left
        self.view.addGestureRecognizer(swipeDown)
    }
    
    @objc func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            switch swipeGesture.direction {
            case .right:
                if viewModel?.id ?? 0 > 0 {
                    viewModel?.id -= 1
                    updateUI()
                } else {
                    viewModel?.id = (viewModel?.photos.count ?? 0) - 1
                    updateUI()
                }
            case .left:
                if viewModel?.id ?? 0 < (viewModel?.photos.count ?? 0) - 1 {
                    viewModel?.id += 1
                    updateUI()
                } else {
                    viewModel?.page += 1
                    viewModel?.getData()
                    viewModel?.id += 1
                }
            default:
                break
            }
        }
    }
    
    private func observe() {
        viewModel?.$photos
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                self?.updateUI()
            }.store(in: &cancellable)
    }
    
    private func updateUI() {
        UIView.transition(with: self.photoImageView,
                          duration: 1.0,
                          options: .transitionCrossDissolve,
                          animations: {
            let imageUrl = self.viewModel?.photos[self.viewModel?.id ?? 0].urls.regular ?? ""
            self.photoImageView.sd_setImage(with: URL(string: imageUrl))
            self.photoImageView.heroID = String(self.viewModel?.photos[self.viewModel?.id ?? 0].id ?? "")
        }, completion: nil)
        UIView.transition(with: self.detailView,
                          duration: 1.0,
                          options: .transitionCrossDissolve,
                          animations: {
            let description = self.viewModel?.photos[self.viewModel?.id ?? 0].description
            self.detailView.descriptionLabel.text = description ?? "No description"
        }, completion: nil)
    }
    
    private func setupUI() {
        view.backgroundColor = AppColors.background.color
        view.addSubview(imageView)
        guard let regularURL = viewModel?.photos[viewModel?.id ?? 0].urls.regular,
              let smallURL = viewModel?.photos[viewModel?.id ?? 0].urls.small else { return }
        //        photoImageView.sd_setImage(with: URL(string: regularURL),
        //                                   placeholderImage: SDImageCache.shared.imageFromCache(forKey: smallURL))
        //        photoImageView.contentMode = .scaleAspectFill
        //        photoImageView.clipsToBounds = true
        //        photoImageView.layer.cornerRadius = 16
        //        photoImageView.heroID = String(viewModel?.photos[viewModel?.id ?? 0].id ?? "")
        imageView.configure(imageUrl: URL(string: regularURL),
                            placeholderImage: SDImageCache.shared.imageFromCache(forKey: smallURL),
                            heroId: String(viewModel?.photos[viewModel?.id ?? 0].id ?? ""))
        
        view.addSubview(detailView)
        detailView.heroModifiers = [.fade, .translate(x: 0, y: 400)]
        detailView.backgroundColor = AppColors.descriptionBackground.color
        detailView.layer.cornerRadius = 16
        
        guard let width = viewModel?.photos[viewModel?.id ?? 0].width,
              let height = viewModel?.photos[viewModel?.id ?? 0].height else { return }
        
        detailView.configure(descLabelText: viewModel?.photos[viewModel?.id ?? 0].description ?? "No description",
                             width: width,
                             height: height)
        detailView.viewModel = viewModel
        
        setupConstraints()
    }
    private func setupConstraints() {
        imageView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.left.equalTo(self.view).offset(5)
            make.right.equalTo(self.view).offset(-5)
            make.height.equalTo(self.view.frame.width)
        }
        detailView.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom)
            make.left.equalTo(view).offset(5)
            make.right.equalTo(view).offset(-5)
            make.bottom.equalTo(self.view)
        }
    }
}
