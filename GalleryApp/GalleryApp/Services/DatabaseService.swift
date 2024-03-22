import RealmSwift
import Combine

final class DatabaseService {
    static var shared = DatabaseService()
    private init() {}
    
    @Published var photos: [PhotoArray] = []
    
    let realm = try? Realm()
    
    func addToDatabase(photos: PhotoArray, imageUrlRegular: String) {
        var dbPhotos = DatabasePhotos()
        let modelToDatabase = ModelToDatabase(photos: photos)
        dbPhotos = modelToDatabase.modelToDatabase()
        dbPhotos.likedByUser = true
        dbPhotos.localUrlRegular = imageUrlRegular
        try? realm?.write {
            realm?.add(dbPhotos)
        }
    }
    
    func getAllPhotos() -> [PhotoArray] {
        var allPhotos: [PhotoArray] = []
        let dbPhotos = realm?.objects(DatabasePhotos.self)
        dbPhotos?.forEach { photo in
            guard let dbMap = DatabaseToModel(dbPhotos: photo).databaseToModel() else { return }
            allPhotos.append(dbMap)
        }
        return allPhotos
    }
    
    func observe() {
        guard let dbPhotos = realm?.objects(DatabasePhotos.self) else { return }
        let notificationToken = dbPhotos.observe { (changes) in
            switch changes {
            case .initial: break
                // Results are now populated and can be accessed without blocking the UI
            case .update(_, let deletions, let insertions, let modifications):
                // Query results have changed.
                print("Deleted indices: ", deletions)
                print("Inserted indices: ", insertions)
                print("Modified modifications: ", modifications)
            case .error(let error):
                // An error occurred while opening the Realm file on the background worker thread
                fatalError("\(error)")
            }
        }
    }
    
    func deleteFromDatabase(id: String) {
        try? realm?.write {
            let dbPhotos = realm?.objects(DatabasePhotos.self).where {
                $0.id == id
            }
            guard let dbPhotos = dbPhotos else { return }
            realm?.delete(dbPhotos)
        }
    }
}
