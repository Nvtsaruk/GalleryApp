import UIKit
import SnapKit
import SDWebImage
import Combine

class ImageGalleryScreenView: UIViewController {
    
    var viewModel: ImageGalleryScreenViewModel?
    private var dataSource: UICollectionViewDiffableDataSource<Section, PhotoArray>!
    private var layout: UICollectionViewCompositionalLayout!
    private var cancellable: Set<AnyCancellable> = []
    private var isPaginating = false
    //    var collectionView = UICollectionView()
    //    private lazy var photoView: UICollectionView = {
    //            let layout = UICollectionViewFlowLayout()
    ////        layout.estimatedItemSize = CGSize(width: view.frame.width/3, height: view.frame.width/3)
    //            layout.itemSize = CGSize(width: view.frame.width/3, height: view.frame.width/3)
    //            layout.scrollDirection = .vertical
    //            layout.minimumInteritemSpacing = 0
    //        let collectionView = UICollectionView(frame: .null, collectionViewLayout: layout)
    //            collectionView.delegate = self
    //            collectionView.dataSource = self
    //            collectionView.backgroundColor = .lightGray
    //            collectionView.showsVerticalScrollIndicator = false
    ////            collectionView.contentInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
    //            return collectionView
    //        }()
    private var photoView: UICollectionView! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationTitle()
        configureCollectionViewLayout()
        setupDataSource()
        configUI()
        viewModel?.getData()
        observe()
    }
    private func setupNavigationTitle() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Gallery App"
    }
    
//    private func setupBind() {
//        viewModel?.$photos
//            .receive(on: DispatchQueue.main)
//            .sink { error in
//                print(error)
//            } receiveValue: { photo in
//                self.photoView.reloadData()
//            }.store(in: &cancellable)
//        
//    }
    private func observe() {
        viewModel?.$photos
          .filter { !$0.isEmpty }
          .receive(on: DispatchQueue.main)
          .sink { [weak self] photo in
            self?.reloadSnapshot()
        }.store(in: &cancellable)
      }
    
    private func reloadSnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, PhotoArray>()
        snapshot.appendSections([.main])
        guard let photos = viewModel?.photos else { return }
        snapshot.appendItems(photos, toSection: .main)
        dataSource.apply(snapshot, animatingDifferences: false)
      }
    
    private func configUI() {
        view.backgroundColor = .lightGray
        
        
    }
}

extension ImageGalleryScreenView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel?.pushDetails(id: indexPath.row)
    }
}

//MARK: - Setup CollectionView

extension ImageGalleryScreenView {
    enum Section: Int, CaseIterable {
        case main
      }
    
    private func createLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        //        layout.estimatedItemSize = CGSize(width: view.frame.width/3, height: view.frame.width/3)
        layout.itemSize = CGSize(width: view.frame.width/3, height: view.frame.width/3)
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 0
        return layout
    }
    
    private func configureCollectionViewLayout() {
        photoView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        photoView.delegate = self
        
        photoView.register(
            PhotoCell.self,
            forCellWithReuseIdentifier: PhotoCell.identifier)
        photoView.register(
            FooterView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
            withReuseIdentifier: FooterView.identifier)
        view.addSubview(photoView)
        photoView.snp.makeConstraints { make in
            make.left.right.top.bottom.equalTo(self.view)
        }
        photoView.backgroundColor = .lightGray
    }
    
    private func setupDataSource() {
        dataSource = .init(collectionView: photoView) { collectionView, indexPath, item in
          guard let section = Section(rawValue: indexPath.section) else { return UICollectionViewCell() }
          switch section {
            case .main:
            let cell = collectionView.dequeueReusableCell(
              withReuseIdentifier: PhotoCell.identifier,
              for: indexPath) as? PhotoCell
                  cell?.configure(index: String(indexPath.row), item: item)
            return cell
          }
        }

        dataSource.supplementaryViewProvider = { [unowned self] (collectionView, kind, indexPath) in
          guard let footerView = self.photoView.dequeueReusableSupplementaryView(
            ofKind: UICollectionView.elementKindSectionFooter,
            withReuseIdentifier: FooterView.identifier, for: indexPath) as? FooterView else { fatalError() }
          footerView.toggleLoading(isEnabled: isPaginating)
          return footerView
        }
      }
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.item == (viewModel?.photos.count ?? 0) - 1 {
          print("last reached. paginate now")
          isPaginating = true
            viewModel?.page += 1
            viewModel?.getData()
//          fetchProducts { [weak self] in
//            self?.isPaginating = false
//          }
        }
      }
}
//extension ImageGalleryScreenView: UICollectionViewDelegate, UICollectionViewDataSource {
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return viewModel?.photos.count ?? 0
//    }
//
//    func collectionView(_ collectionView: UICollectionView,
//                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        guard let cell = photoView.dequeueReusableCell(withReuseIdentifier: PhotoCell.identifier,
//                                                       for: indexPath) as? PhotoCell,
//              let url = URL(string: viewModel?.photos[indexPath.row].urls.regular ?? "")
//        else { return UICollectionViewCell()}
//        cell.configure(url: url, heroId: String(indexPath.row))
//        return cell
//    }
//
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        viewModel?.pushDetails(id: indexPath.row)
//    }
//
//}
