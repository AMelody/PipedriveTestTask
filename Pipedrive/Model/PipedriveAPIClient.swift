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
    case requestCancelled
    case noInternetConnection
    case serverError(statusCode: Int)

    public var errorDescription: String? {

        switch self {
        case .unknown: return "Unknown error."
        case .requestCancelled: return "Request has been cancelled."
        case .noInternetConnection: return "No internet connection."
        case let .serverError(statusCode): return "Unexpected server response (code=\(statusCode))."
        }
    }
}

// MARK: -

class PipedriveAPIClient {

    // MARK: - Interface

    func loadPersons(_ completionHandler: @escaping ([Person]?, PipedriveAPIError?) -> Void) {


        URLSession.shared.dataTask(with: URLRequest(url: personsURL)) { data, response, error in

            // Handle URLSession error
            if let error = error {

                if error.isURLSessionCancelled {

                    completionHandler(nil, .requestCancelled)

                } else if error.noNetworkConnection {

                    completionHandler(nil, .noInternetConnection)

                } else {

                    completionHandler(nil, .unknown)
                }
                return
            }

            // Handle server error
            if let httpResponse = response as? HTTPURLResponse {

                let statusCode = httpResponse.statusCode
                if statusCode != 200 {

                    completionHandler(nil, .serverError(statusCode: statusCode))
                }

            } else {

                completionHandler(nil, .unknown)
            }

            // Decode data
            guard let data else {

                completionHandler(nil, nil)
                return
            }

            do {

                let JSONDecoder = JSONDecoder()
                JSONDecoder.keyDecodingStrategy = .convertFromSnakeCase
                let result = try JSONDecoder.decode(Response.self, from: data)

                DispatchQueue.main.async {

                    completionHandler(result.data, nil)
                }

            } catch {

                DispatchQueue.main.async {

                    completionHandler(nil, .unknown)
                }
            }
        }
        .resume()
    }

    // MARK: - Private

    private struct Response: Codable {

        let data: [Person]?
    }

    private static let scheme = "https"
    private static let host = "Shpak.pipedrive.com"
    private static let path = "/api/v1/persons"
    private static let tokenKey = "api_token"
    private static let tokenValue = "e757403f92e055c781610e8325e207186762c04c"

    private var personsURL: URL {

        var components = URLComponents()
        components.scheme = Self.scheme
        components.host = Self.host
        components.path = Self.path
        components.queryItems = [URLQueryItem(name: Self.tokenKey, value: Self.tokenValue)]
        return components.url!
    }
}
