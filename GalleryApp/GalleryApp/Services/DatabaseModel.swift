import Foundation
import RealmSwift

final class DatabasePhotos: Object {
    
    @Persisted(primaryKey: true) var uuid: UUID
    @Persisted var needUpdate: Bool
    @Persisted var id: String
    @Persisted var width: Int
    @Persisted var height: Int
    @Persisted var desc: String?
    @Persisted var user: DatabaseUser?
    @Persisted var urls: DatabaseUrls?
    @Persisted var localUrlRegular: String?
    
    convenience init(liked_by_user: Bool,
                     _ model: PhotoArray,
                     user: DatabaseUser,
                     urls: DatabaseUrls,
                     localUrlRegular: String?) {
        self.init()
        self.uuid = model.uuid
        self.id = model.id
        self.width = model.width
        self.height = model.height
        self.desc = model.description
        self.user = user
        self.urls = urls
        self.localUrlRegular = localUrlRegular
    }
}

final class DatabaseUser: Object {
    
    @Persisted var username: String
    
    convenience init(_ model: UserModel) {
        self.init()
        self.username = model.username
    }
}

final class DatabaseUrls: Object {
    
    @Persisted var regular: String
    @Persisted var small: String
    
    convenience init(_ model: UrlsModel) {
        self.init()
        self.regular = model.regular
        self.small = model.small
    }
}
