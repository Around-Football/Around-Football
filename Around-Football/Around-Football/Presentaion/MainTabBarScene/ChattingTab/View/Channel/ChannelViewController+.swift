//
//  ChannelViewController+.swift
//  Around-Football
//
//  Created by 진태영 on 11/13/23.
//

import UIKit

import RxSwift
import MessageKit

extension ChannelViewController {
    func bindContentView() {
        viewModel.currentUser
            .map { $0 != nil }
            .bind(to: loginLabel.rx.isHidden)
            .disposed(by: disposeBag)
        
        viewModel.currentUser
            .map { $0 == nil }
            .bind(to: channelTableView.rx.isHidden)
            .disposed(by: disposeBag)
    }
    
    func bindChannels() {
        viewModel.channels
            .bind(to: channelTableView.rx.items(cellIdentifier: ChannelTableViewCell.cellId, cellType: ChannelTableViewCell.self)) { row, item, cell in
                cell.chatRoomLabel.text = item.withUserName
                cell.chatPreviewLabel.text = item.previewContent
                let alarmNumber = item.alarmNumber
                alarmNumber == 0 ? self.hideChatAlarmNumber(cell: cell) : self.showChatAlarmNumber(cell: cell, alarmNumber: "\(alarmNumber)")
                let date = item.recentDate
                cell.recentDateLabel.text = self.formatDate(date)
            }
            .disposed(by: disposeBag)
        
        
    }
    
    func bindLoginModalView(with outputObservable: Observable<Bool>) {
        outputObservable
            .withUnretained(self)
            .subscribe(onNext: { (owner, isShowing) in
                if isShowing {
                    print("currentUser nil")
                    owner.viewModel.coordinator?.presentLoginViewController()
                }
            })
            .disposed(by: disposeBag)
        
    }
    
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

extension ChannelViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}
