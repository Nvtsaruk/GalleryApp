import Foundation

final class ImageDetailsScreenViewModel {
    var coordinator: CoordinatorProtocol?
    var photos: [PhotoArray] = []
    var id: Int?
    var currentImage: Data?
}
