import UIKit
import SnapKit
import SDWebImage
import Combine

class ImageGalleryScreenView: UIViewController {

    var viewModel = ImageGalleryScreenViewModel()
    private var cancellable: Set<AnyCancellable> = []
//    var collectionView = UICollectionView()
    private lazy var photoView: UICollectionView = {
            let layout = UICollectionViewFlowLayout()
//        layout.estimatedItemSize = CGSize(width: view.frame.width/3, height: view.frame.width/3)
            layout.itemSize = CGSize(width: view.frame.width/3, height: view.frame.width/3)
            layout.scrollDirection = .vertical
            layout.minimumInteritemSpacing = 0
            let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
            collectionView.delegate = self
            collectionView.dataSource = self
            collectionView.backgroundColor = .lightGray
            collectionView.showsHorizontalScrollIndicator = false
            collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            return collectionView
        }()

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.getData()
        configUI()
        setupBind()
    }
    
    private func setupBind() {
        viewModel.$photos
            .receive(on: DispatchQueue.main)
            .sink { error in
            print(error)
        } receiveValue: { photos in
            self.photoView.reloadData()
        }.store(in: &cancellable)

    }

    private func configUI() {
        view.addSubview(photoView)
        photoView.register(PhotoCell.self, forCellWithReuseIdentifier: "photoCell")
        photoView.snp.makeConstraints { make in
            make.top.equalTo(self.view)
            make.bottom.equalTo(self.view)
            make.left.equalTo(self.view)
            make.right.equalTo(self.view)
        }
    }
}

final class PhotoCell: UICollectionViewCell {
    let photoImageView = UIImageView()
    override init(frame: CGRect) {
        super.init(frame: frame)
        configUI()
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

extension ImageGalleryScreenView: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.photos.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = photoView.dequeueReusableCell(withReuseIdentifier: "photoCell", for: indexPath) as? PhotoCell else { return UICollectionViewCell()}
        cell.photoImageView.sd_setImage(with: URL(string: viewModel.photos[indexPath.row].urls.regular))
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(viewModel.photos[indexPath.row].id)
    }

}
