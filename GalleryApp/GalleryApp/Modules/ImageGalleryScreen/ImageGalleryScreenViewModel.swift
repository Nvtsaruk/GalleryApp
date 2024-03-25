import Foundation
import Combine

final class ImageGalleryScreenViewModel {
    
    var coordinator: CoordinatorProtocol?
    let apiService = ApiService()
    
    private var cancellable: Set<AnyCancellable> = []
    
    @Published var photos: [PhotoArray] = []
    @Published var databasePhotos: [PhotoArray] = []
    @Published var favouriteDict: [String: Bool] = [:]
    @Published var id = 0
    
    var page = 1
    
    func getData() {
        getDataFromApi()
        getDataFromDatabase()
    }
    
    func getDataFromApi() {
        apiService.getPhotos(page: page)
            .receive(on: DispatchQueue.main)
            .sink { error in
                print(error)
            } receiveValue: { [weak self] photos in
                self?.photos.append(contentsOf: photos)
            }.store(in: &cancellable)
    }
    
    func getDataFromDatabase() {
        DatabaseService.shared.getAllPhotos()
        DatabaseService.shared.$photos
            .receive(on: DispatchQueue.main)
            .sink { error in
                print(error)
            } receiveValue: { [weak self] photos in
                self?.databasePhotos = photos
                self?.addFavs()
            }.store(in: &cancellable)
        addFavs()
    }

    private func addFavs() {
        var tempDict: [String: Bool] = [:]
        databasePhotos.forEach { item in
            tempDict[item.id] = true
        }
        favouriteDict = tempDict
    }
    
    func pushDetails(id: Int, isFavorite: Bool) {
        if !isFavorite {
            coordinator?.pushDetailsView(id: id,
                                         photos: photos,
                                         page: page,
                                         favouriteDict: favouriteDict,
                                         isFavScreen: isFavorite)
        } else {
            coordinator?.pushDetailsView(id: id,
                                         photos: databasePhotos,
                                         page: page,
                                         favouriteDict: favouriteDict,
                                         isFavScreen: isFavorite)
        }
    }
}
