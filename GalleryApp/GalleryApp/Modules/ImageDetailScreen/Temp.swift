//import UIKit
//import Combine
//import SDWebImage
//
//enum LabelType {
//    case title
//    case label
//}
//
//class ImageDetailScreenView: UIViewController {
//    var viewModel: ImageDetailsScreenViewModel?
//    private var cancellable: Set<AnyCancellable> = []
//    lazy var imageView = ImageView()
//    lazy var detailView = DetailView()
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        setupUI()
//        setupGestures()
//        observe()
//    }
//    
//    private func setupGestures() {
//        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture))
//        swipeRight.direction = .right
//        self.view.addGestureRecognizer(swipeRight)
//        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture))
//        swipeDown.direction = .left
//        self.view.addGestureRecognizer(swipeDown)
//    }
//    
//    @objc func respondToSwipeGesture(gesture: UIGestureRecognizer) {
//        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
//            switch swipeGesture.direction {
//            case .right:
//                if viewModel?.id ?? 0 > 0 {
//                    viewModel?.id -= 1
//                    updateUI()
//                } else {
//                    viewModel?.id = (viewModel?.photos.count ?? 0) - 1
//                    updateUI()
//                }
//            case .left:
//                if viewModel?.id ?? 0 < (viewModel?.photos.count ?? 0) - 1 {
//                    viewModel?.id += 1
//                    updateUI()
//                } else {
//                    viewModel?.page += 1
//                    viewModel?.getData()
//                    viewModel?.id += 1
//                }
//            default:
//                break
//            }
//        }
//    }
//    
//    private func observe() {
//        viewModel?.$photos
//            .receive(on: RunLoop.main)
//            .sink { [weak self] _ in
//                self?.updateUI()
//            }.store(in: &cancellable)
//    }
//    
//    private func updateUI() {
//        UIView.transition(with: self.imageView,
//                          duration: AnimationConstants.animationDuration.rawValue,
//                          options: .transitionCrossDissolve,
//                          animations: {
//            let imageUrl = self.viewModel?.photos[self.viewModel?.id ?? 0].urls.regular ?? ""
//            self.imageView.photoImageView.sd_setImage(with: URL(string: imageUrl))
//            self.imageView.photoImageView.heroID = String(self.viewModel?.photos[self.viewModel?.id ?? 0].id ?? "")
//        }, completion: nil)
//        UIView.transition(with: self.detailView,
//                          duration: AnimationConstants.animationDuration.rawValue,
//                          options: .transitionCrossDissolve,
//                          animations: {
//            let description = self.viewModel?.photos[self.viewModel?.id ?? 0].description
//            self.detailView.descriptionLabel.text = description ?? "No description"
//        }, completion: nil)
//    }
//    
//    @objc func backToMainView() {
//        viewModel?.backToMainView()
//    }
//    
//    private func setupUI() {
//        let backToRootVCButton = UIBarButtonItem.init(title: "Back", style: UIBarButtonItem.Style.plain, target: self, action: #selector(backToMainView))
//        self.navigationItem.setLeftBarButton(backToRootVCButton, animated: true)
//        view.backgroundColor = AppColors.background.color
//        view.addSubview(imageView)
//        guard let regularURL = viewModel?.photos[viewModel?.id ?? 0].urls.regular,
//              let smallURL = viewModel?.photos[viewModel?.id ?? 0].urls.small else { return }
//        imageView.configure(imageUrl: URL(string: regularURL),
//                            placeholderImage: SDImageCache.shared.imageFromCache(forKey: smallURL),
//                            heroId: String(viewModel?.photos[viewModel?.id ?? 0].id ?? ""))
//        imageView.layer.cornerRadius = UIConstants.cornerRadius.rawValue
//        imageView.clipsToBounds = true
//        view.addSubview(detailView)
//        detailView.heroModifiers = [.fade, .translate(x: 0, y: 400)]
//        detailView.backgroundColor = AppColors.descriptionBackground.color
//        detailView.layer.cornerRadius = UIConstants.cornerRadius.rawValue
//        
//        guard let width = viewModel?.photos[viewModel?.id ?? 0].width,
//              let height = viewModel?.photos[viewModel?.id ?? 0].height,
//              let isFav = viewModel?.photos[viewModel?.id ?? 0].likedByU private func layout() {
//                  favButton.snp.makeConstraints { make in
//                      make.left.top.equalToSuperview().offset(10)
//                      make.height.width.equalTo(48)
//                  }
//                  descriptionTitle.snp.makeConstraints { make in
//                      make.left.right.equalToSuperview().inset(10)
//                      make.top.equalTo(favButton.snp.bottom).offset(10)
//                  }
//                  descriptionLabel.snp.makeConstraints { make in
//                      make.left.equalTo(descriptionTitle)
//                      make.top.equalTo(descriptionTitle.snp.bottom).offset(10)
//                      make.right.equalToSuperview().offset(-5)
//                  }
//                  sizeTitle.snp.makeConstraints { make in
//                      make.left.equalTo(descriptionTitle)
//                      make.top.equalTo(descriptionLabel.snp.bottom).offset(10)
//                      make.right.equalToSuperview().offset(-10)
//                  }
//                  sizeLabel.snp.makeConstraints { make in
//                      make.left.equalTo(descriptionTitle)
//                      make.top.equalTo(sizeTitle.snp.bottom).offset(10)
//                      make.right.equalToSuperview().offset(-10)
//                  }
//                  userTitle.snp.makeConstraints { make in
//                      make.left.equalTo(descriptionTitle)
//                      make.top.equalTo(sizeLabel.snp.bottom).offset(10)
//                      make.right.equalToSuperview().offset(-10)
//                  }
//                  userLabel.snp.makeConstraints { make in
//                      make.left.equalTo(descriptionTitle)
//                      make.top.equalTo(userTitle.snp.bottom).offset(10)
//                      make.right.equalToSuperview().offset(-10)
//                  }
//              }ser
//        else { return }
//        print("In VC",isFav)
//        detailView.configure(descLabelText: viewModel?.photos[viewModel?.id ?? 0].description ?? "No description",
//                             width: width,
//                             height: height,
//                             user: viewModel?.photos[viewModel?.id ?? 0].user.username ?? "No name",
//                             isFav: ((viewModel?.photos[viewModel?.id ?? 0].likedByUser) != nil))
//        detailView.viewModel = viewModel
//        
//        setupConstraints()
//    }
//    private func setupConstraints() {
//        imageView.snp.makeConstraints { make in
//            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
//            make.left.equalTo(self.view).offset(5)
//            make.right.equalTo(self.view).offset(-5)
//            make.height.equalTo(self.view.frame.width)
//        }
//        detailView.snp.makeConstraints { make in
//            make.top.equalTo(imageView.snp.bottom)
//            make.left.equalTo(view).offset(5)
//            make.right.equalTo(view).offset(-5)
//            make.bottom.equalTo(self.view)
//        }
//    }
//}
