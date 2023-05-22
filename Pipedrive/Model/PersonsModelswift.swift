//
//  Modelswift.swift
//  Pipedrive
//
//  Created by Anastasiia Shpak on 5/21/23.
//

import Foundation

// MARK: -

class PersonsModel {

    // MARK: - Interface

    private(set) var persons: [Person]?

    func loadData(_ completionHandler: @escaping (_ error: PipedriveAPIError?) -> Void) {

        client.loadPersons { persons, error in

            DispatchQueue.main.async {

                self.persons = persons
                completionHandler(error)
            }
        }
    }

    // MARK: - Private

    private let client = PipedriveAPIClient()
}
