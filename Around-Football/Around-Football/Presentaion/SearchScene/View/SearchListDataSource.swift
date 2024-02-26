//
//  SearchListDataSource.swift
//  Around-Football
//
//  Created by 강창현 on 2/26/24.
//

import UIKit

enum SearchListSection {
    case place
}

typealias SearchListSnapShot = NSDiffableDataSourceSnapshot<SearchListSection, Place>

final class SearchListDataSource: UITableViewDiffableDataSource<SearchListSection, Place> {
    static let cellProvider: CellProvider = { tableview, indexPath, place in
        guard
            let cell = tableview.dequeueReusableCell(
                withIdentifier: SearchTableViewCell.identifier,
                for: indexPath
            ) as? SearchTableViewCell
        else {
            return SearchTableViewCell()
        }
        cell.configureCell(with: place)
        return cell
    }
    
    convenience init(_ listView: UITableView) {
        self.init(tableView: listView, cellProvider: Self.cellProvider)
    }
}

