final class ModelToDatabase {
    let photos: PhotoArray
    
    init(photos: PhotoArray) {
        self.photos = photos
    }
    
    func modelToDatabase() -> DatabasePhotos {
        let dbUser = DatabaseUser(photos.user)
        let dbUrls = DatabaseUrls(photos.urls)
        let dbPhotos = DatabasePhotos(liked_by_user: false, photos, user: dbUser, urls: dbUrls, localUrlRegular: nil, localUrlSmall: nil)
        return dbPhotos
    }
}

final class DatabaseToModel {
    let dbPhotos: DatabasePhotos
    
    init(dbPhotos: DatabasePhotos) {
        self.dbPhotos = dbPhotos
    }
    
    func databaseToModel() -> PhotoArray? {
        guard let dbUser = dbPhotos.user,
              let dbUrls = dbPhotos.urls else { return nil }
        let user = UserModel(username: dbUser.username)
        let urls = UrlsModel(regular: dbUrls.regular, small: dbUrls.small)
        let photoModel = PhotoArray(likedByUser: dbPhotos.likedByUser, id: dbPhotos.id, width: dbPhotos.width, height: dbPhotos.height, description: dbPhotos.desc, user: user, urls: urls)
        return photoModel
    }
}
