//
//  MTMainViewController.swift
//  MaxTest
//
//  Created by Dmitry Ivashin on 1/26/18.
//  Copyright © 2018 Dmitry Ivashin. All rights reserved.
//

import UIKit
import CoreData

class MTMainViewController: UITableViewController {
    
    enum CellIdentifier {
        static let articleCell = "ArticleCell"
    }
    
    fileprivate var fetchedResultsController: NSFetchedResultsController<NSFetchRequestResult> {
        return MTApplicationManager.instance().coreDataService.getFetchResultsController()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchedResultsController.delegate = self
        performFetch()
    }
    
    fileprivate func performFetch()
    {
        do {
            try fetchedResultsController.performFetch()
        } catch let error as NSError {
            print("Error: \(error.localizedDescription)")
        }
    }
}

extension MTMainViewController: NSFetchedResultsControllerDelegate {
    
    func controllerWillChangeContent(_ controller:
        NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            tableView.insertRows(at: [newIndexPath!],
                                 with: .automatic)
        case .delete:
            tableView.deleteRows(at: [indexPath!],
                                 with: .automatic)
        case .update:
            let cell = tableView.cellForRow(at: indexPath!)
                as! MTArticleCell
            cell.article = fetchedResultsController.object(at: indexPath!)
                as! Article
        case .move:
            tableView.deleteRows(at: [indexPath!],
                                 with: .automatic)
            tableView.insertRows(at: [newIndexPath!],
                                 with: .automatic)
        }
    }
    
    func controllerDidChangeContent(_ controller:
        NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
}
