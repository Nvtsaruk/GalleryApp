import UIKit
protocol CoordinatorProtocol {
    func start()
}
final class Coordinator: CoordinatorProtocol {
    
    let navigationController = UINavigationController()
    
    func start() {
        let vc = ImageGalleryScreenView()
        let viewModel = ImageGalleryScreenViewModel()
        viewModel.coordinator = self
        vc.viewModel = viewModel
        navigationController.pushViewController(vc, animated: true)
    }
}
