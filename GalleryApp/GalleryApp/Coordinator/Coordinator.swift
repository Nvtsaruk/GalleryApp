import UIKit
import Hero
protocol CoordinatorProtocol {
    func start()
    func pushDetailsView(id: Int, photos: [PhotoArray], currentImage: Data)
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

    func pushDetailsView(id: Int, photos: [PhotoArray], currentImage: Data) {
        let detailsViewController = ImageDetailScreenView()
        let viewModel = ImageDetailsScreenViewModel()
        viewModel.coordinator = self
        viewModel.id = id
        viewModel.photos = photos
        viewModel.currentImage = currentImage
        detailsViewController.viewModel = viewModel
        navigationController.isHeroEnabled = true
        navigationController.heroNavigationAnimationType = .fade
        navigationController.pushViewController(detailsViewController, animated: true)
    }
}
