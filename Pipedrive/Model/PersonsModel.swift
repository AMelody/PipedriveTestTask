//
//  Modelswift.swift
//  Pipedrive
//
//  Created by Anastasiia Shpak on 5/21/23.
//

import Foundation

// MARK: -

protocol PersonsModelInterface {

    var persons: [Person] { get }

    func loadData(_ completionHandler: @escaping (Result<[Person], PipedriveAPIError>) -> Void)
}

class PersonsModel: PersonsModelInterface {

    init(client: PipedriveAPIClientInterface) {

        self.client = client
    }

    // MARK: - PersonsModelInterface

    private(set) var persons = [Person]()

    // TODO: replace completionHandler with reactive approach (Combine)
    func loadData(_ completionHandler: @escaping (Result<[Person], PipedriveAPIError>) -> Void) {

        client.loadPersons { result in

            // Dispatch on main queue allows to synchronize access to 'persons' property.
            DispatchQueue.main.async {

                switch result {

                case let .success(persons):

                    self.persons = persons

                case .failure(_):

                    break
                }
                completionHandler(result)
            }
        }
    }

    // MARK: - Private

    private let client: PipedriveAPIClientInterface
}
