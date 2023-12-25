//
//  ApplicationStatusViewController+.swift
//  Around-Football
//
//  Created by 차소민 on 2023/10/18.
//

import UIKit

//TODO: - 파일 삭제

extension ApplicantListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ApplicantListTableViewCell.cellID) as?
                ApplicantListTableViewCell else { return UITableViewCell() }
        
        return cell
    }
}

extension ApplicantListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 93
    }
}
