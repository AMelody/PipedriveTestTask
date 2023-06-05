//
//  PersonViewController.swift
//  Pipedrive
//
//  Created by Anastasiia Shpak on 6/5/23.
//

import UIKit

// MARK: -

class PersonViewController: UIViewController  {

    // MARK: - Interface

    var person : Person? {

        didSet {

            if isViewLoaded {

                updateUI()
            }
        }
    }

    // MARK: - UIViewController

    override func viewDidLoad() {

        super.viewDidLoad()

        contactsTableView.dataSource = self

        updateUI()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if segue.identifier == Self.nextSceneSegueIdentifier,
           let nextScene = segue.destination as? PersonDetailsViewController,
           let persoon = sender as? Person {

            nextScene.setPerson(persoon)
        }
    }

    // MARK: - Private

    @IBOutlet private var firstNameLabel: UILabel!
    @IBOutlet private weak var lastNameLabel: UILabel!
    @IBOutlet private weak var contactsTableView: UITableView!
    @IBOutlet private weak var openedDeals: UILabel!
    @IBOutlet private weak var closedDeals: UILabel!

    @IBAction func handleViewAllDetailsButton(_ sender: Any) {

        performSegue(withIdentifier: Self.nextSceneSegueIdentifier, sender: person)
    }

    private static let nextSceneSegueIdentifier = "showAllPersonDetails"
    private let sectionTitles = ["Phone numbers", "Emails", "Organization"]

    private func updateUI() {

        if let person {

            firstNameLabel.text = person.firstName
            lastNameLabel.text = person.lastName
            openedDeals.text = "\(person.openDealsCount ?? 0)"
            closedDeals.text = "\(person.closedDealsCount ?? 0)"
        }
    }
}

// MARK: - UITableViewDataSource

extension PersonViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {

        sectionTitles.count
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {

        sectionTitles[section]
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        if section == 0 {

            return person?.phone?.count ?? 1

        } else if section == 1 {

            return person?.email?.count  ?? 1
        }

        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "personDetailsCell", for: indexPath)
        var content = cell.defaultContentConfiguration()

        var text: String?
        if (indexPath.section == 0 || indexPath.section == 1) {

            let items = (indexPath.section == 0) ? person?.phone : person?.email
            if let item = items?[indexPath.row] {

                text = item.value
            }

        } else {

            text = person?.orgName
        }

        content.text = (text?.isEmpty ?? true ) ? "-" : text

        cell.contentConfiguration = content
        return cell
    }
}
