//
//  PipedriveAPIController.swift
//  Pipedrive
//
//  Created by Anastasiia Shpak on 5/20/23.
//

import Foundation

// MARK: -

enum PipedriveAPIError: Error, LocalizedError {

    case unknown
    case noInternetConnection
    case serverError(statusCode: Int)

    public var errorDescription: String? {

        switch self {
        case .unknown: return "Unknown error."
        case .noInternetConnection: return "No internet connection."
        case let .serverError(statusCode): return "Unexpected server response (code=\(statusCode))."
        }
    }
}

protocol PipedriveAPIClientInterface {

    func loadPersons(_ completionHandler: @escaping (Result<[Person], PipedriveAPIError>) -> Void)
}

// MARK: -

class PipedriveAPIClient: PipedriveAPIClientInterface {

    // MARK: - Interface

    init() {

        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        self.decoder = decoder
    }

    func loadPersons(_ completionHandler: @escaping (Result<[Person], PipedriveAPIError>) -> Void) {

        URLSession.shared.dataTask(with: URLRequest(url: personsURL)) { data, response, error in

            // Handle URLSession error
            if let error = error {

                completionHandler(.failure(error.noNetworkConnection ? .noInternetConnection : .unknown))
                return
            }

            guard let httpResponse = response as? HTTPURLResponse else {

                completionHandler(.failure(.unknown))
                return
            }

            // Handle server error
            guard httpResponse.statusCode == 200 else {

                completionHandler(.failure(.serverError(statusCode: httpResponse.statusCode)))
                return
            }

            // Decode data
            guard let data else {

                completionHandler(.failure(.unknown))
                return
            }

            do {

                let result = try self.decoder.decode(DataTransferObject.self, from: data)
                completionHandler(.success(result.data ?? []))

            } catch {

                completionHandler(.failure(.unknown))
            }
        }
        .resume()
    }

    // MARK: - Private

    private struct DataTransferObject: Codable {

        let data: [Person]?
    }

    // Primitive obfuscated access token
    private static let token = ["32d6204352d892939", "e9cf7ebbd7607a2a0baeb09"].joined()

    private var personsURL: URL {

        var components = URLComponents()
        components.scheme = "https"
        components.host = "Shpak.pipedrive.com"
        components.path = "/api/v1/persons"
        components.queryItems = [URLQueryItem(name: "api_token", value: Self.token/*"e757403f92e055c781610e8325e207186762c04c"*/)]
        return components.url!
    }

    private let decoder: JSONDecoder
}
