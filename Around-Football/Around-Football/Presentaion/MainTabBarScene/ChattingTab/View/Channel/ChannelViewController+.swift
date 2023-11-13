//
//  ChannelViewController+.swift
//  Around-Football
//
//  Created by 진태영 on 11/13/23.
//

import UIKit

import MessageKit

extension ChannelViewController {
//    func bindTableView() {
//        viewModel.channels.bind(to: channelTableView.rx.items(cellIdentifier: ChannelTableViewCell.cellId, cellType: ChannelTableViewCell.self)) { [weak self] row, item, cell in
//            guard let self = self else { return }
//            cell.chatRoomLabel.text = item.withUserName
//            cell.chatPreviewLabel.text = item.previewContent
//            let alarmNumber = item.alarmNumber
//            alarmNumber == 0 ? self.hideChatAlarmNumber(cell: cell) : self.showChatAlarmNumber(cell: cell, alarmNumber: "\(alarmNumber)")
//            let date = item.recentDate
//            cell.recentDateLabel.text = self.formatDate(date)
//        }
//        .disposed(by: disposeBag)
//        
//        channelTableView.rx.itemSelected
//            .subscribe { [weak self] indexPath in
//                let selectedItem = self?.viewModel.channels.value[indexPath.row]
//                self?.viewModel.showChatView()
//            }
//            .disposed(by: disposeBag)
//    }
    
    private func hideChatAlarmNumber(cell: ChannelTableViewCell) {
        cell.chatAlarmNumberLabel.text = ""
        cell.chatAlarmNumberLabel.isHidden = true
    }
    
    private func showChatAlarmNumber(cell: ChannelTableViewCell, alarmNumber: String) {
        cell.chatAlarmNumberLabel.text = alarmNumber
        cell.chatAlarmNumberLabel.isHidden = false
        cell.updateAlarmLabelUI()
    }
    
    private func formatDate(_ date: Date) -> String {
        let calendar = Calendar.current
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        
        if calendar.isDateInToday(date) {
            formatter.dateFormat = "a h:mm"
        } else if calendar.isDateInYesterday(date) {
            return "어제"
        } else if calendar.isDate(date, equalTo: Date(), toGranularity: .year) {
            formatter.dateFormat = "M월 d일"
        } else {
            formatter.dateFormat = "yyyy년 M월 d일"
        }
        return formatter.string(from: date)
    }

}
//extension ChannelViewController: UITableViewDataSource {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return viewModel.channels.count
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: ChannelTableViewCell.cellId, for: indexPath) as! ChannelTableViewCell
//        cell.chatRoomLabel.text = viewModel.channels[indexPath.row].withUserName
//        cell.chatPreviewLabel.text = viewModel.channels[indexPath.row].previewContent
//        
//        let alarmNumber = viewModel.channels[indexPath.row].alarmNumber
//        alarmNumber == 0 ? hideChatAlarmNumber(cell: cell) : showChatAlarmNumber(cell: cell, alarmNumber: "\(alarmNumber)")
//        
//        let date = viewModel.channels[indexPath.row].recentDate
//        cell.recentDateLabel.text = formatDate(date)
//        
//        return cell
//    }
    
//}

extension ChannelViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let channel = viewModel.channels[indexPath.row]
//        guard let currentUser = viewModel.currentUser else { return }
        /* Coordinator 적용
        let viewController = ChatViewController(user: currentUser, channel: channel)
        navigationController?.pushViewController(viewController, animated: true)
         */
    }
}
