//
//  FieldDetailViewController+.swift
//  Around-Football
//
//  Created by 진태영 on 10/23/23.
//

import UIKit

extension FieldDetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: FieldRecruitTableViewCell.cellID,
            for: indexPath
        ) as? FieldRecruitTableViewCell
        
        guard let cell = cell else { fatalError("FieldDetail TableView Cell Error") }
        
        return cell
    }
}

extension FieldDetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 48
    }
}
