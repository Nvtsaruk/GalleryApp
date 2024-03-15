import Foundation
import Combine

enum NetworkConstants {
    case token
    var value : String {
        switch self {
            case .token:
                return "B_8irYfHoAoq6EvqrmbQdXo3U1tYXFcaQmMGkyqpJkI"
        }
    }
}

final class ApiService {
    func getPhotos(page: Int) -> AnyPublisher<[PhotoList], Error> {
        let url = URL(string: "https://api.unsplash.com/photos?page=\(page)")!
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.setValue("Client-ID \(NetworkConstants.token.value)", forHTTPHeaderField: "Authorization")
            return URLSession.shared.dataTaskPublisher(for: request)
                .map(\.data)
                .decode(type: [PhotoList].self, decoder: JSONDecoder())
                .eraseToAnyPublisher()
    }
}
