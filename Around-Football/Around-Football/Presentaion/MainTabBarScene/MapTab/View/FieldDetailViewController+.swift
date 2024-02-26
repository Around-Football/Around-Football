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
        cell.bindButton(disposeBag: disposeBag) { [weak self] in
            self?.viewModel.checkChannelAndPushChatViewController(recruit: recruit)
        }
        return cell
    }
}

extension FieldDetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // TODO: - dismiss도 coordinator 통해서? -> 그러면 FieldDetailViewCoordinator 있어야할 듯?
        self.dismiss(animated: true) {
            let recruit = self.viewModel.fetchRecruit(row: indexPath.row)
            self.viewModel.pushRecruitDetailView(recruit: recruit)
        }
    }
}
