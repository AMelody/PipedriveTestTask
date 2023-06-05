//
//  PersonsViewController.swift
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

        personsTableViewController.model = model
        personsTableViewController.delegate = self

        let tableView = personsTableViewController.tableView!
        tableView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(tableView)

        let safeArea = view.safeAreaLayoutGuide
        tableView.leftAnchor.constraint(equalTo: safeArea.leftAnchor, constant: 0.0).isActive = true
        tableView.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 0.0).isActive = true
        tableView.rightAnchor.constraint(equalTo: safeArea.rightAnchor, constant: 0.0).isActive = true
        tableView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: 0.0).isActive = true

        view.setNeedsLayout()
        
        reloadData()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if segue.identifier == Self.nextSceneSegueIdentifier,
           let nextScene = segue.destination as? PersonViewController,
           let persoon = sender as? Person {

                nextScene.person = persoon
        }
    }

    // MARK: - Private

    private enum State {

        case noData
        case operationInProgress
        case dataPresentation
    }

    @IBOutlet private weak var activityIndicatorView: UIActivityIndicatorView!
    @IBOutlet private weak var noDataLabel: UILabel!
    @IBOutlet private weak var reloadDataButton: UIButton!

    private static let nextSceneSegueIdentifier = "showPersonDetails"

    private let model: PersonsModelInterface = PersonsModel(client: PipedriveAPIClient())
    private let personsTableViewController: PersonsTableViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PersonsTableViewController") as! PersonsTableViewController

    @IBAction private func handleReloadButtonClick(_ sender: Any) {

        reloadData()
    }

    private func reloadData() {

        updateUIWithState(.operationInProgress)

        model.loadData { result in

            switch result {

            case let .success(persons):

                self.updateUIWithState(persons.count > 0 ? .dataPresentation : .noData)

            case let .failure(error):

                UIAlertController.presentAlert(for: self, with: error)
                self.updateUIWithState(.noData)
            }

            self.personsTableViewController.tableView.reloadData()
        }
    }

    private func updateUIWithState(_ state: State) {

        switch state {

        case .noData:

            activityIndicatorView.isHidden = true
            activityIndicatorView.stopAnimating()
            noDataLabel.isHidden = false
            reloadDataButton.isHidden = false
            personsTableViewController.tableView.isHidden = true

        case .dataPresentation:

            activityIndicatorView.isHidden = true
            activityIndicatorView.stopAnimating()
            noDataLabel.isHidden = true
            reloadDataButton.isHidden = true
            personsTableViewController.tableView.isHidden = false

        case .operationInProgress:

            activityIndicatorView.isHidden = false
            activityIndicatorView.startAnimating()
            noDataLabel.isHidden = true
            reloadDataButton.isHidden = true
            personsTableViewController.tableView.isHidden = true
        }
    }
}

// MARK: - PersonsTableViewControllerDelegate

extension PersonsViewController: PersonsTableViewControllerDelegate {

    func personsTableViewController(

        _ viewController: PersonsTableViewController,
        didRequesToPresentDetails person: Person

    ) {

        performSegue(withIdentifier: Self.nextSceneSegueIdentifier, sender: person)
    }
}
