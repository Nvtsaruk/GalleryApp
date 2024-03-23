import UIKit
import SnapKit
import SDWebImage
import Combine

final class ImageGalleryScreenView: UIViewController {
    
    var viewModel: ImageGalleryScreenViewModel?
    private var dataSource: UICollectionViewDiffableDataSource<Section, PhotoArray>!
    private var layout: UICollectionViewCompositionalLayout!
    private var cancellable: Set<AnyCancellable> = []
    private var isPaginating = false
    private var isFavourite = false
    
    private let stackView = UIStackView()
    private let optionSwitch = UISwitch()
    private let toggleLabel = UILabel()
    private let isEmptyLabel = UILabel()
    private var photoView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationTitle()
        configureCollectionViewLayout()
        setupDataSource()
        configUI()
        viewModel?.getData()
        observe()
    }
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        photoView.collectionViewLayout.invalidateLayout()
        updateConstraints()
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
            .receive(on: DispatchQueue.global())
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
        guard let dbPhotCount = viewModel?.databasePhotos.count,
              let apiPhotoCount = viewModel?.photos.count else { return }
        if photoView.numberOfSections != 0 && (isFavourite ? dbPhotCount : apiPhotoCount) - 1 >= id {
            if photoView.numberOfItems(inSection: 0) < viewModel?.photos.count ?? 0 {
                self.reloadSnapshot()
            }
            print("Here")
            photoView.scrollToItem(at: IndexPath(row: id, section: 0),
                                   at: [.centeredVertically, .centeredHorizontally],
                                   animated: true)
        }
    }
    
    private func reloadSnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, PhotoArray>()
        snapshot.appendSections([.main])
        guard let photos = viewModel?.photos,
              let databasePhotos = viewModel?.databasePhotos,
              let empty = viewModel?.databasePhotos.isEmpty else { return }
        snapshot.appendItems(isFavourite ? databasePhotos : photos, toSection: .main)
        dataSource.apply(snapshot, animatingDifferences: true)
        DispatchQueue.main.async {
            if self.isFavourite && (empty) {
                self.isEmptyLabel.isHidden = false
            } else {
                self.isEmptyLabel.isHidden = true
            }
        }
        
    }
    
    private func configUI() {
        view.backgroundColor = AppColors.background.color
        view.addSubview(stackView)
        view.addSubview(photoView)
        view.addSubview(isEmptyLabel)
        
        stackView.addArrangedSubview(toggleLabel)
        stackView.addArrangedSubview(optionSwitch)
        stackView.axis = .horizontal
        stackView.spacing = 5
        
        toggleLabel.text = "Favourite"
        optionSwitch.addTarget(self, action: #selector(switchChanged), for: .valueChanged)
    
        isEmptyLabel.text = "Is empty"
        setupViewConstraints()
    }
    
    @objc func switchChanged() {
        isFavourite.toggle()
        reloadSnapshot()
    }
}

extension ImageGalleryScreenView: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel?.pushDetails(id: indexPath.row, isFavorite: isFavourite)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let orientation = UIApplication.shared.windows.first?.windowScene?.interfaceOrientation
        let width = (orientation?.isPortrait ?? false) ? (view.frame.width/3)-5 : (view.frame.width/6)
        return CGSize(width: width, height: width)
        }
}

// MARK: - Setup CollectionView

extension ImageGalleryScreenView {
    enum Section: Int, CaseIterable {
        case main
    }
    
    private func createLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 3
        layout.scrollDirection = .vertical
        return layout
    }
    
    private func updateCollectionViewLayout() {
        print("Creating layout")
        photoView.collectionViewLayout = createLayout()
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
        
        photoView.backgroundColor = .clear
    }
    
    private func updateConstraints() {
        guard let orientation = UIApplication.shared.windows.first?.windowScene?.interfaceOrientation else { return }
        if orientation.isPortrait {
            photoView.snp.remakeConstraints { make in
                make.left.right.bottom.equalTo(self.view)
                make.top.equalTo(stackView.snp.bottom).offset(5)
            }
            stackView.snp.remakeConstraints { make in
                make.top.equalTo(view.safeAreaLayoutGuide)
                make.left.equalTo(view).inset(5)
            }
            isEmptyLabel.snp.updateConstraints { make in
                make.center.equalTo(view.center)
            }
        } else {
            photoView.snp.remakeConstraints { make in
                make.left.right.equalTo(self.view.safeAreaLayoutGuide)
                make.bottom.equalTo(self.view)
                make.top.equalTo(stackView.snp.bottom).offset(5)
            }
            stackView.snp.remakeConstraints { make in
                make.top.equalTo(view.safeAreaLayoutGuide)
                make.left.equalTo(view.safeAreaLayoutGuide)
            }
            isEmptyLabel.snp.updateConstraints { make in
                make.center.equalTo(view.center)
            }
        }
    }
    private func setupViewConstraints() {
        guard let orientation = UIApplication.shared.windows.first?.windowScene?.interfaceOrientation else { return }
        if orientation.isPortrait {
            photoView.snp.makeConstraints { make in
                make.left.right.bottom.equalTo(self.view)
                make.top.equalTo(stackView.snp.bottom).offset(5)
            }
            stackView.snp.makeConstraints { make in
                make.top.equalTo(self.view.safeAreaLayoutGuide)
                make.left.equalTo(self.view).inset(5)
            }
            isEmptyLabel.snp.makeConstraints { make in
                make.center.equalTo(self.view.center)
            }
        } else {
            photoView.snp.makeConstraints { make in
                make.left.right.equalTo(self.view.safeAreaLayoutGuide)
                make.bottom.equalTo(self.view)
                make.top.equalTo(stackView.snp.bottom).offset(5)
            }
            stackView.snp.makeConstraints { make in
                make.top.equalTo(view.safeAreaLayoutGuide)
                make.left.equalTo(view.safeAreaLayoutGuide)
            }
            isEmptyLabel.snp.makeConstraints { make in
                make.center.equalTo(view.center)
            }
        }
    }
    
    private func setupDataSource() {
        dataSource = .init(collectionView: photoView) { collectionView, indexPath, item in
            guard let section = Section(rawValue: indexPath.section) else { return UICollectionViewCell() }
            switch section {
            case .main:
                let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: PhotoCell.identifier,
                    for: indexPath) as? PhotoCell
                cell?.configure(index: item.id,
                                item: item,
                                isFav: item.likedByUser ?? false,
                                isFavouriteTab: self.isFavourite)
                return cell
            }
        }
        
        dataSource.supplementaryViewProvider = { [unowned self] (_, _, indexPath) in
            guard let footerView = self.photoView.dequeueReusableSupplementaryView(
                ofKind: UICollectionView.elementKindSectionFooter,
                withReuseIdentifier: FooterView.identifier, for: indexPath) as? FooterView else { fatalError() }
            return footerView
        }
    }
    func collectionView(_ collectionView: UICollectionView,
                        willDisplay cell: UICollectionViewCell,
                        forItemAt indexPath: IndexPath) {
        if indexPath.item == (viewModel?.photos.count ?? 0) - 1 {
            isPaginating = true
            viewModel?.page += 1
            viewModel?.getData()
        }
    }
    
}
