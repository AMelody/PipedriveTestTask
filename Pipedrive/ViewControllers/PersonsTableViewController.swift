//
//  PersonsTableViewController.swift
//  Pipedrive
//
//  Created by Anastasiia Shpak on 6/4/23.
//

import UIKit

// MARK: -

protocol PersonsTableViewControllerDelegate: AnyObject {

    func personsTableViewController(

        _ viewController: PersonsTableViewController,
        didRequesToPresentDetails person: Person
    )
}

// MARK: -

class PersonsTableViewController: UITableViewController {

    // MARK: - Interface
    
    var model : PersonsModelInterface?
    weak var delegate: PersonsTableViewControllerDelegate?

    // MARK: - UIViewController

    override func viewDidLoad() {

        super.viewDidLoad()

        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(reloadData), for: .valueChanged)
    }

    // MARK: - Private

    private static let nextSceneSegueIdentifier = "showPersonDetails"

    @objc private func reloadData() {

        model?.loadData { result in

            switch result {

            case .success(_):

                break

            case let .failure(error):

                UIAlertController.presentAlert(for: self, with: error)
                break
            }

            self.tableView.reloadData()
            self.refreshControl?.endRefreshing()
        }
    }

    // MARK: - UITableViewDataSource

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        model?.persons.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let person = model?.persons[indexPath.row]

        let cell = tableView.dequeueReusableCell(withIdentifier: "personCell", for: indexPath)
        var content = cell.defaultContentConfiguration()
        content.text = person?.name
        content.secondaryText = person?.primaryEmail ?? ""
        cell.contentConfiguration = content

        return cell
    }
    
    // MARK: - UITableViewDelegate

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        if let selectedPerson = model?.persons[indexPath.row] {

            delegate?.personsTableViewController(self, didRequesToPresentDetails: selectedPerson)
        }

        tableView.deselectRow(at: indexPath, animated: false)
    }
}
