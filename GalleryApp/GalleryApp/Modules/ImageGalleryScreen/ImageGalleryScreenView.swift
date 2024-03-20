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
        let appearance = UINavigationBarAppearance()
        appearance.titleTextAttributes = [.foregroundColor: AppColors.headerColor.color]
        appearance.largeTitleTextAttributes = [.foregroundColor: AppColors.headerColor.color]
        navigationItem.standardAppearance = appearance
    }
    
    private func observe() {
        viewModel?.$photos
            .filter { !$0.isEmpty }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.reloadSnapshot()
            }.store(in: &cancellable)
        viewModel?.$id
            .receive(on: DispatchQueue.main)
            .sink { [weak self] id in
                self?.scrollToItem(id: id)
            }.store(in: &cancellable)
    }
    
    func scrollToItem(id: Int) {
        if photoView.numberOfSections != 0 {
            photoView.scrollToItem(at: IndexPath(row: id, section: 0),
                                   at: [.centeredVertically, .centeredHorizontally],
                                   animated: true)
        }
    }
    
    private func reloadSnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, PhotoArray>()
        snapshot.appendSections([.main])
        guard let photos = viewModel?.photos else { return }
        snapshot.appendItems(photos, toSection: .main)
        dataSource.apply(snapshot, animatingDifferences: false)
    }
    
    private func configUI() {
        view.backgroundColor = AppColors.background.color
    }
}

extension ImageGalleryScreenView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel?.pushDetails(id: indexPath.row)
    }
}

// MARK: - Setup CollectionView

extension ImageGalleryScreenView {
    enum Section: Int, CaseIterable {
        case main
    }
    
    private func createLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        let width = (view.frame.width/3)-5
        layout.sectionInset = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
        layout.itemSize = CGSize(width: width, height: width)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 3
        layout.scrollDirection = .vertical
        return layout
    }
    private func fixedSpacedFlowLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .estimated(view.frame.width/3 - 2),
            heightDimension: .estimated(view.frame.width/3 - 2)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.edgeSpacing = NSCollectionLayoutEdgeSpacing(
            leading: .fixed(1),
            top: .fixed(1),
            trailing: .fixed(1),
            bottom: .fixed(1)
        )
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(100)
        )
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        return UICollectionViewCompositionalLayout(section: section)
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
        photoView.backgroundColor = .clear
    }
    
    private func setupDataSource() {
        dataSource = .init(collectionView: photoView) { collectionView, indexPath, item in
            guard let section = Section(rawValue: indexPath.section) else { return UICollectionViewCell() }
            switch section {
            case .main:
                let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: PhotoCell.identifier,
                    for: indexPath) as? PhotoCell
                cell?.configure(index: String(self.viewModel?.photos[indexPath.row].id ?? ""), item: item)
                return cell
            }
        }
        
        dataSource.supplementaryViewProvider = { [unowned self] (collectionView, kind, indexPath) in
            guard let footerView = self.photoView.dequeueReusableSupplementaryView(
                ofKind: UICollectionView.elementKindSectionFooter,
                withReuseIdentifier: FooterView.identifier, for: indexPath) as? FooterView else { fatalError() }
            return footerView
        }
    }
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.item == (viewModel?.photos.count ?? 0) - 1 {
            print("last reached. paginate now")
            isPaginating = true
            viewModel?.page += 1
            viewModel?.getData()
            print("ViewModel version",viewModel)
        }
    }
    
}
