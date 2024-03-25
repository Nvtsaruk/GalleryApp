import UIKit
import Hero
protocol CoordinatorProtocol {
    func start()
    func pushDetailsView(id: Int, photos: [PhotoArray], page: Int, favouriteDict: [String: Bool], isFavScreen: Bool)
    func backToMainView(id: Int, photos: [PhotoArray]?, page: Int, favouriteDict: [String: Bool])
}
final class Coordinator: CoordinatorProtocol {

    let navigationController = UINavigationController()

    func start() {
        let imageGalleryVC = ImageGalleryScreenView()
        let viewModel = ImageGalleryScreenViewModel()
        viewModel.coordinator = self
        imageGalleryVC.viewModel = viewModel
        navigationController.isHeroEnabled = true
        navigationController.heroNavigationAnimationType = .fade
        navigationController.pushViewController(imageGalleryVC, animated: true)
    }

    func pushDetailsView(id: Int, photos: [PhotoArray], page: Int, favouriteDict: [String: Bool], isFavScreen: Bool) {
        let detailsVC = ImageDetailScreenView()
        let viewModel = ImageDetailsScreenViewModel()
        viewModel.coordinator = self
        viewModel.id = id
        viewModel.photos = photos
        viewModel.page = page
        viewModel.favouriteDict = favouriteDict
        viewModel.isFavourite = isFavScreen
        detailsVC.viewModel = viewModel
        navigationController.isHeroEnabled = true
        navigationController.heroNavigationAnimationType = .fade
        navigationController.pushViewController(detailsVC, animated: true)
    }
    func backToMainView(id: Int, photos: [PhotoArray]?, page: Int, favouriteDict: [String: Bool]) {
        guard let imageGalleryVC = navigationController.viewControllers.first as? ImageGalleryScreenView else { return }
        let viewModel = imageGalleryVC.viewModel
        viewModel?.coordinator = self
        viewModel?.id = id
        if let photos = photos {
            viewModel?.photos = photos
        }
        viewModel?.favouriteDict = favouriteDict
        viewModel?.page = page
        imageGalleryVC.viewModel = viewModel
        navigationController.popToViewController(imageGalleryVC, animated: true)
    }
}
