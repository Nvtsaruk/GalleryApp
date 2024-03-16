import UIKit
protocol CoordinatorProtocol {
    func start()
    func pushDetailsView(id: Int, photos: [PhotoList])
}
final class Coordinator: CoordinatorProtocol {

    let navigationController = UINavigationController()

    func start() {
        let imageGalleryViewController = ImageGalleryScreenView()
        let viewModel = ImageGalleryScreenViewModel()
        viewModel.coordinator = self
        imageGalleryViewController.viewModel = viewModel
        navigationController.pushViewController(imageGalleryViewController, animated: true)
    }
    
    func pushDetailsView(id: Int, photos: [PhotoList]) {
        let detailsViewController = ImageDetailScreenView()
        let viewModel = ImageDetailsScreenViewModel()
        viewModel.coordinator = self
        detailsViewController.viewModel = viewModel
        navigationController.pushViewController(detailsViewController, animated: true)
    }
}
