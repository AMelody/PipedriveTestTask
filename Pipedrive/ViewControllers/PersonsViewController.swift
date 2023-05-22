//
//  ViewController.swift
//  Pipedrive
//
//  Created by Anastasiia Shpak on 5/20/23.
//

import UIKit

// MARK: -

class PersonsViewController: UIViewController  {

    // MARK: - UIViewController

    override func viewDidLoad() {

        super.viewDidLoad()

        personsTableView.dataSource = self
        personsTableView.delegate = self

        reloadData()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if segue.identifier == Self.nextSceneSegueIdentifier,
            let nextScene = segue.destination as? PersonDetailsViewController,
            let indexPath = personsTableView.indexPathForSelectedRow {

            let selectedPerson = model.persons?[indexPath.row]
            nextScene.person = selectedPerson
        }
    }

    // MARK: - Private

    private enum State {

        case noData
        case operationInProgress
        case dataPresentation
    }

    @IBOutlet private weak var personsTableView: UITableView!
    @IBOutlet private weak var activityIndicatorView: UIActivityIndicatorView!
    @IBOutlet private weak var noDataLabel: UILabel!
    @IBOutlet private weak var reloadDataButton: UIButton!

    private static let nextSceneSegueIdentifier = "showPersonDetails"
    private static let cellIdentifier = "personCell"

    private let model = PersonsModel()

    @IBAction private func handleReloadButtonClick(_ sender: Any) {

        reloadData()
    }

    private func reloadData() {

        updateUIWithState(.operationInProgress)

        model.loadData { error in

            if let error {

                self.showErrorAlert(error)
                self.updateUIWithState(.noData)

            } else {

                if let personsCounter = self.model.persons?.count, personsCounter > 0 {

                    self.updateUIWithState(.dataPresentation)

                } else {

                    self.updateUIWithState(.noData)
                }
            }

            self.personsTableView.reloadData()
        }
    }

    private func updateUIWithState(_ state: State) {

        switch state {

        case .noData:

            activityIndicatorView.isHidden = true
            activityIndicatorView.stopAnimating()
            noDataLabel.isHidden = false
            reloadDataButton.isHidden = false
            personsTableView.isHidden = true

        case .dataPresentation:

            activityIndicatorView.isHidden = true
            activityIndicatorView.stopAnimating()
            noDataLabel.isHidden = true
            reloadDataButton.isHidden = true
            personsTableView.isHidden = false

        case .operationInProgress:

            activityIndicatorView.isHidden = false
            activityIndicatorView.startAnimating()
            noDataLabel.isHidden = true
            reloadDataButton.isHidden = true
            personsTableView.isHidden = true

        }
    }

    private func showErrorAlert(_ error: PipedriveAPIError) {

        let alert = UIAlertController(title: "Error", message: error.errorDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}

// MARK: - UITableViewDataSource

extension PersonsViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        model.persons?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let person = model.persons![indexPath.row]

        let cell = tableView.dequeueReusableCell(withIdentifier: Self.cellIdentifier, for: indexPath)
        var content = cell.defaultContentConfiguration()

        content.text = person.name
        content.secondaryText = person.primaryEmail ?? ""

        cell.contentConfiguration = content

        return cell
    }
}

// MARK: - UITableViewDelegate

extension PersonsViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        performSegue(withIdentifier: Self.nextSceneSegueIdentifier, sender: nil)
        tableView.deselectRow(at: indexPath, animated: false)
    }
}
