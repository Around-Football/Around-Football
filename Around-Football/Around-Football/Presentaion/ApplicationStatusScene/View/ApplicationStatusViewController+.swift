//
//  ApplicationStatusViewController+.swift
//  Around-Football
//
//  Created by 차소민 on 2023/10/18.
//

import UIKit

extension ApplicationStatusViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5     // 임시값
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ApplicationStatusTableViewCell", for: indexPath) as! ApplicationStatusTableViewCell
       
        cell.selectionStyle = .none
        return cell
    }
}

extension ApplicationStatusViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 85
    }
}


