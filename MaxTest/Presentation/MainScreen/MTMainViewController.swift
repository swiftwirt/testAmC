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
    
    enum SegueIdentifier {
        static let toDetails = "SegueToDetails"
    }
    
    fileprivate let applicationManager = MTApplicationManager.instance()
    
    fileprivate var fetchedResultsController = MTApplicationManager.instance().apiService.coreDataService.getFetchResultsController()
    
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
    
    // Data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultsController.fetchedObjects?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.articleCell, for: indexPath) as! MTArticleCell
        cell.article = fetchedResultsController.object(at: indexPath) as! Article
        return cell
    }
    
    // Segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier! {
        case SegueIdentifier.toDetails:
            guard let controller = segue.destination as? MTDetailsViewController, let cell = sender as? MTArticleCell else { return }
            let detailsHTML = cell.article.contentDetailsHTML
            controller.htmlString = detailsHTML
        default:
            break
        }
    }
    
    @IBAction func onPullToRefresh(_ sender: Any) {
        applicationManager.articleService.uploadArticles { [weak self] in
            self?.performFetch()
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
            tableView.insertRows(at: [newIndexPath!], with: .automatic)
        case .delete:
            tableView.deleteRows(at: [indexPath!], with: .automatic)
        case .update:
            let cell = tableView.cellForRow(at: indexPath!) as! MTArticleCell
            cell.article = fetchedResultsController.object(at: indexPath!) as! Article
        case .move:
            tableView.deleteRows(at: [indexPath!], with: .automatic)
            tableView.insertRows(at: [newIndexPath!], with: .automatic)
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
}
