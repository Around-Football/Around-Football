//
//  ApplicationStatusViewController+.swift
//  Around-Football
//
//  Created by 차소민 on 2023/10/18.
//

import UIKit

extension ApplicantListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.rowHeight
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return nil
    }
}
