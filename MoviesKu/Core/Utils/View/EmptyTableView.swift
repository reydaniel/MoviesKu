//
//  EmptyTableView.swift
//  MoviesKu
//
//  Created by ReyDaniel on 03/12/21.
//

import Foundation
import UIKit

struct EmptyTableView {
    func showEmptyText(tableView: UITableView) {
        let noDataLabel: UILabel  = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
        noDataLabel.text          = "No data available"
        noDataLabel.textColor     = UIColor.black
        noDataLabel.textAlignment = .center
        tableView.backgroundView  = noDataLabel
    }
}
