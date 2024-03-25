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
    
    private let imageView = ImageView()
    private let detailView = DetailView()
    private let stackView = UIStackView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupGestures()
        observe()
    }
    
    override func viewWillTransition(to size: CGSize,
                                     with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        updateConstraints()
        imageView.updateConstraints()
        detailView.updateConstraints()
    }
    
    private func setupGestures() {
        let swipeRight = UISwipeGestureRecognizer(target: self,
                                                  action: #selector(respondToSwipeGesture))
        swipeRight.direction = .right
        self.view.addGestureRecognizer(swipeRight)
        let swipeLeft = UISwipeGestureRecognizer(target: self,
                                                 action: #selector(respondToSwipeGesture))
        swipeLeft.direction = .left
        self.view.addGestureRecognizer(swipeLeft)
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
                    guard let isFavourite = viewModel?.isFavourite else { return }
                    if isFavourite {
                        viewModel?.id = 0
                        updateUI()
                        
                    } else {
                        viewModel?.page += 1
                        viewModel?.getData()
                        viewModel?.id += 1
                    }
                }
            default:
                break
            }
        }
    }
    
    private func observe() {
        viewModel?.$photos
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.updateUI()
            }.store(in: &cancellable)
    }
    
    private func updateUI() {
        UIView.transition(with: self.imageView,
                          duration: AnimationConstants.animationDuration.rawValue,
                          options: .transitionCrossDissolve,
                          animations: {
            guard let regularUrl = self.viewModel?.photos[self.viewModel?.id ?? 0].urls.regular,
                  let smallURL = self.viewModel?.photos[self.viewModel?.id ?? 0].urls.small else { return }
            self.imageView.configure(imageUrl: URL(string: regularUrl),
                                     placeholderImage: SDImageCache.shared.imageFromCache(forKey: smallURL),
                                     heroId: String(self.viewModel?.photos[self.viewModel?.id ?? 0].id ?? ""))
        }, completion: nil)
        UIView.transition(with: self.detailView,
                          duration: AnimationConstants.animationDuration.rawValue,
                          options: .transitionCrossDissolve,
                          animations: {
            let description = self.viewModel?.photos[self.viewModel?.id ?? 0].description
            guard let width = self.viewModel?.photos[self.viewModel?.id ?? 0].width,
                  let height = self.viewModel?.photos[self.viewModel?.id ?? 0].height else { return }
            let isFav = self.viewModel?.favouriteDict[self.viewModel?.photos[self.viewModel?.id ?? 0].id ?? ""]
            self.detailView.configure(descLabelText: description ?? "No description",
                                      width: width,
                                      height: height,
                                      user: self.viewModel?.photos[self.viewModel?.id ?? 0].user.username ?? "No name",
                                      isFav: (isFav ?? false))
        }, completion: nil)
    }
    
    @objc func backToMainView() {
        viewModel?.backToMainView()
    }
    
    private func setupUI() {
        let backToRootVCButton = UIBarButtonItem.init(title: "Back",
                                                      style: UIBarButtonItem.Style.plain,
                                                      target: self,
                                                      action: #selector(backToMainView))
        backToRootVCButton.tintColor = AppColors.activeButton.color
        backToRootVCButton.image = UIImage(systemName: "chevron.left")
        self.navigationItem.setLeftBarButton(backToRootVCButton, animated: true)
        
        view.backgroundColor = AppColors.background.color
        
        view.addSubview(stackView)
        stackView.spacing = 0
        stackView.addArrangedSubview(imageView)
        stackView.addArrangedSubview(detailView)
        
        guard let orientation = UIApplication.shared.windows.first?.windowScene?.interfaceOrientation else { return }
        detailView.heroModifiers = [.fade, orientation.isPortrait ? .translate(x: 0, y: 400) : .translate(x: 400, y: 0)]
        detailView.backgroundColor = AppColors.descriptionBackground.color
        detailView.layer.cornerRadius = UIConstants.cornerRadius.rawValue
        detailView.viewModel = viewModel
        
        updateUI()
        setupConstraints()
    }
    
    private func setupConstraints() {
        guard let orientation = UIApplication.shared.windows.first?.windowScene?.interfaceOrientation else { return }
        stackView.axis = orientation.isLandscape ? .horizontal : .vertical
        if orientation.isPortrait {
            stackView.snp.makeConstraints { make in
                make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(-40)
                make.left.right.equalTo(view).inset(5)
                make.bottom.equalTo(view)
            }
            
        } else {
            stackView.snp.makeConstraints { make in
                make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
                make.left.right.equalTo(view.safeAreaLayoutGuide).inset(5)
                make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            }
        }
    }
    
    private func updateConstraints() {
        guard let orientation = UIApplication.shared.windows.first?.windowScene?.interfaceOrientation else { return }
        stackView.axis = orientation.isLandscape ? .horizontal : .vertical
        stackView.snp.remakeConstraints { make in
            if orientation.isPortrait {
                make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(-40)
                make.left.right.equalTo(view).inset(5)
                make.bottom.equalTo(view)
            } else {
                make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
                make.left.right.equalTo(view.safeAreaLayoutGuide).inset(5)
                make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            }
        }
    }
}
