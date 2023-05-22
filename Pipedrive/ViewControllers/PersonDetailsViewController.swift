//
//  PersonDetailsViewController.swift
//  Pipedrive
//
//  Created by Anastasiia Shpak on 5/20/23.
//

import UIKit

// MARK: -

class PersonDetailsViewController: UIViewController  {

    // MARK: - Interface

    var person: Person? {

        didSet {

            itemsToDisplay = Self.makeItemsToDisplay(person)
        }
    }

    // MARK: - UIViewController

    override func viewDidLoad() {

        super.viewDidLoad()

        personDetailsTableView.dataSource = self
    }

    // MARK: - Private

    private typealias ItemToDisplay = (String, Any)

    private static let stringCellIdentifier = "personDetailsCell"
    @IBOutlet private weak var personDetailsTableView: UITableView!

    private var itemsToDisplay = [ItemToDisplay]() {

        didSet {

            if isViewLoaded{

                DispatchQueue.main.async {

                    self.personDetailsTableView.reloadData()
                }
            }
        }
    }

    private static func makeItemsToDisplay(_ person: Person?) -> [ItemToDisplay] {

        guard let person else {

            return []
        }

        var result = [ItemToDisplay]()
        for item in person.allProperties() {

            result.append(item)
        }

        return result.sorted(by: {

            $0.0 <= $1.0
        })
    }
}

// MARK: - UITableViewDataSource

extension PersonDetailsViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {

        itemsToDisplay.count
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {

        itemsToDisplay[section].0
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        let objectToCheck = itemsToDisplay[section].1
        switch objectToCheck {

        case let contacts as [Contact]:

            return contacts.count

        case let picture as Picture:

            return picture.pictures?.count ?? 1

        default:

            return 1
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: Self.stringCellIdentifier, for: indexPath)
        let objectToCheck = itemsToDisplay[indexPath.section].1
        cell.contentConfiguration = Self.makeContentConfiguration(cell, dataSource: objectToCheck, indexPath: indexPath)
        return cell
    }

    // MARK: - Private

    private static func makeContentConfiguration(

        _ cell: UITableViewCell,
        dataSource: Any,
        indexPath: IndexPath

    ) -> UIListContentConfiguration {

        var content = cell.defaultContentConfiguration()
        switch dataSource {

        case let contacts as [Contact]:

            let contact = contacts[indexPath.row]
            content.text = contact.value.isEmpty ? "-" : contact.value

            var description = [String]()
            if let label = contact.label {

                description.append(label)
            }
            if contact.primary ?? false {

                description.append("is primary contact")
            }
            content.secondaryText = description.joined(separator: ", ")

        case let organisation as Organisation:

            content.text = organisation.name
            content.secondaryText = organisation.address

        case let owner as Owner:

            content.text = owner.name
            content.secondaryText = owner.email

        case let picture as Picture:

            content.text = picture.pictures?.values.sorted()[indexPath.row] ?? "-"

        case let text as String:

            content.text = text

        case let number as Int:

            content.text = "\(number)"

        case let boolean as Bool:

            content.text = "\(boolean)"

        default:

            content.text = "-"
        }

        return content
    }
}
