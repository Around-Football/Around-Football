//
//  FieldDetailViewController+.swift
//  Around-Football
//
//  Created by 진태영 on 10/23/23.
//

import UIKit

extension FieldDetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.recruitsCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard 
            let cell = tableView.dequeueReusableCell(
            withIdentifier: FieldRecruitTableViewCell.identifier,
            for: indexPath
        ) as? FieldRecruitTableViewCell 
        else {
            return FieldRecruitTableViewCell()
        }
        let recruit = viewModel.fetchRecruit(row: indexPath.row)
        cell.configure(recruit: recruit)
        return cell
    }
}
