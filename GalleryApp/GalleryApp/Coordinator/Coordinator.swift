import UIKit
import Hero
protocol CoordinatorProtocol {
    func start()
    func pushDetailsView(id: Int, photos: [PhotoArray], page: Int, isFavourite: Bool)
    func backToMainView(id: Int, photos: [PhotoArray]?, page: Int)
}
final class Coordinator: CoordinatorProtocol {

    let navigationController = UINavigationController()

    func start() {
        let imageGalleryViewController = ImageGalleryScreenView()
        let viewModel = ImageGalleryScreenViewModel()
        viewModel.coordinator = self
        imageGalleryViewController.viewModel = viewModel
        navigationController.isHeroEnabled = true
        navigationController.heroNavigationAnimationType = .fade
        navigationController.pushViewController(imageGalleryViewController, animated: true)
    }

    func pushDetailsView(id: Int, photos: [PhotoArray], page: Int, isFavourite: Bool) {
        let detailsViewController = ImageDetailScreenView()
        let viewModel = ImageDetailsScreenViewModel()
        viewModel.coordinator = self
        viewModel.id = id
        viewModel.photos = photos
        viewModel.page = page
        detailsViewController.viewModel = viewModel
        navigationController.isHeroEnabled = true
        navigationController.heroNavigationAnimationType = .fade
        navigationController.pushViewController(detailsViewController, animated: true)
    }
    func backToMainView(id: Int, photos: [PhotoArray]?, page: Int) {
        guard let imageGalleryViewController = navigationController.viewControllers.first as? ImageGalleryScreenView else { return }
        let viewModel = imageGalleryViewController.viewModel
        viewModel?.coordinator = self
        viewModel?.id = id
        if let photos = photos {
            viewModel?.photos = photos
        }
        viewModel?.page = page
        imageGalleryViewController.viewModel = viewModel
        navigationController.popToViewController(imageGalleryViewController, animated: true)
    }
}
