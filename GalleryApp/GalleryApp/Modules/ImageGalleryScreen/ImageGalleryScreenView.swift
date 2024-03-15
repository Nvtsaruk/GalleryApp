import UIKit
import SnapKit

class ImageGalleryScreenView: UIViewController {

    var viewModel: ImageGalleryScreenViewModelProtocol?
    
//    var collectionView = UICollectionView()

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel?.getData()
    }
    
    private func configUI() {
        
    }
}
