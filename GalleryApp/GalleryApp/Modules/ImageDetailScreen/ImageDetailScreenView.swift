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
        setupGestures()
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
                    viewModel?.id! -= 1
                    UIView.transition(with: self.photoImageView,
                                              duration: 1.0,
                                      options: .transitionFlipFromLeft,
                                              animations: {
                        self.photoImageView.sd_setImage(with: URL(string: self.viewModel?.photos[self.viewModel?.id ?? 0].urls.regular ?? ""))
                            }, completion: nil)
                    UIView.transition(with: self.detailView,
                                              duration: 1.0,
                                      options: .transitionCrossDissolve,
                                              animations: {
                        self.descriptionLabel.text = self.viewModel?.photos[self.viewModel?.id ?? 0].description ?? "No description"
                            }, completion: nil)
            case .left:
                    viewModel?.id! += 1
                    UIView.transition(with: self.photoImageView,
                                              duration: 1.0,
                                      options: .transitionFlipFromRight,
                                              animations: {
                        self.photoImageView.sd_setImage(with: URL(string: self.viewModel?.photos[self.viewModel?.id ?? 0].urls.regular ?? ""))
                            }, completion: nil)
                    UIView.transition(with: self.detailView,
                                              duration: 1.0,
                                      options: .transitionCrossDissolve,
                                              animations: {
                        self.descriptionLabel.text = self.viewModel?.photos[self.viewModel?.id ?? 0].description ?? "No description"
                            }, completion: nil)
            default:
                break
            }
        }
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
