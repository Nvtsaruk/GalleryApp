import UIKit
import Combine

class ImageDetailScreenView: UIViewController {
    var viewModel = ImageDetailsScreenViewModel()
    private var cancellable: Set<AnyCancellable> = []
    lazy var photoImageView = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        
    }
}
