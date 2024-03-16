import UIKit
import SnapKit
import SDWebImage
import Combine

class ImageGalleryScreenView: UIViewController {

    var viewModel: ImageGalleryScreenViewModel?
    private var cancellable: Set<AnyCancellable> = []
//    var collectionView = UICollectionView()
    private lazy var photoView: UICollectionView = {
            let layout = UICollectionViewFlowLayout()
//        layout.estimatedItemSize = CGSize(width: view.frame.width/3, height: view.frame.width/3)
            layout.itemSize = CGSize(width: view.frame.width/3, height: view.frame.width/3)
            layout.scrollDirection = .vertical
            layout.minimumInteritemSpacing = 0
        let collectionView = UICollectionView(frame: .null, collectionViewLayout: layout)
            collectionView.delegate = self
            collectionView.dataSource = self
            collectionView.backgroundColor = .lightGray
            collectionView.showsVerticalScrollIndicator = false
//            collectionView.contentInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
            return collectionView
        }()

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel?.getData()
        configUI()
        setupBind()
    }

    private func setupBind() {
        viewModel?.$photos
            .receive(on: DispatchQueue.main)
            .sink { error in
            print(error)
        } receiveValue: { _ in
            self.photoView.reloadData()
        }.store(in: &cancellable)

    }

    private func configUI() {
        self.title = "Gallery App"
        view.addSubview(photoView)
        photoView.register(PhotoCell.self, forCellWithReuseIdentifier: "photoCell")
        photoView.snp.makeConstraints { make in
//            make.left.equalTo(view.safeAreaLayoutGuide.snp.left).offset(30)
//            make.right.equalTo(view.safeAreaLayoutGuide.snp.right).offset(30)
            make.left.right.top.bottom.equalTo(self.view)
        }
    }
}

extension ImageGalleryScreenView: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel?.photos.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = photoView.dequeueReusableCell(withReuseIdentifier: "photoCell",
                                                       for: indexPath) as? PhotoCell,
              let url = URL(string: viewModel?.photos[indexPath.row].urls.regular ?? "")
        else { return UICollectionViewCell()}
        cell.configure(url: url, heroId: String(indexPath.row))
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel?.pushDetails(id: indexPath.row)
    }

}
