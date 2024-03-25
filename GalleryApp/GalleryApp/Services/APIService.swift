import Foundation
import Combine

final class ApiService {
    func getPhotos(page: Int) -> AnyPublisher<[PhotoArray], Error> {
        let url = URL(string: "\(NetworkConstants.baseAPICodeUrl)?page=\(page)&per_page=\(NetworkConstants.perPage)")!
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.setValue("Client-ID \(NetworkConstants.token)", forHTTPHeaderField: "Authorization")
            return URLSession.shared.dataTaskPublisher(for: request)
                .map(\.data)
                .decode(type: [PhotoArray].self, decoder: JSONDecoder())
                .receive(on: DispatchQueue.global(qos: .userInitiated))
                .eraseToAnyPublisher()
    }
}
