//
//  ChannelViewModel.swift
//  Around-Football
//
//  Created by 진태영 on 11/9/23.
//

import Foundation

import FirebaseFirestore
import Firebase

final class ChannelViewModel {
    
    // MARK: - Properties
    
    var channels: [ChannelInfo] = []
    var currentUser: User?
    
    // MARK: - API
    
    func setupListener() {
        ChannelAPI.shared.subscribe { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let data):
                self.updateCell(to: data)
            case .failure(let error):
                print("DEBUG - setupListener Error: \(error.localizedDescription)")
            }
        }
    }
    
    func fetchUser() {
        let uid = Auth.auth().currentUser?.uid ?? UUID().uuidString
        let fcmToken = UserDefaults.standard.string(forKey: "FCMToken") ?? ""
        FirebaseAPI.shared.updateFCMTokenAndFetchUser(uid: uid, fcmToken: fcmToken) { [weak self] user, error in
            if let error = error {
                print("DEBUG - FetchUser Error: ", #function, error.localizedDescription)
                return
            }
            guard let self = self else { return }
            self.currentUser = user
            print("DEBUG - CurrentUser: \(String(describing: self.currentUser))")
            
        }
    }
    // MARK: - Helpers
    
    private func updateCell(to data: [(ChannelInfo, DocumentChangeType)]) {
        data.forEach { channel, documentChangeType in
            switch documentChangeType {
            case .added:
                addChannelToTable(channel)
            case .modified:
                
            case .removed:
            }
        }
    }
    
    private func addChannelToTable(_ channel: ChannelInfo) {
        guard channels.contains(channel) == false else { return }
        channels.append(channel)
        channels.sort()
        
        guard let index = channels.firstIndex(of: channel) else { return }
        // TODO: - RX 적용하기
//                channelTableView.insertRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
    }
    
    private func updateChannelInTable(_ channel: ChannelInfo) {
        guard let index = channels.firstIndex(of: channel) else { return }
        channels[index] = channel
        // TODO: - RX 적용하기
//        channtlTableView.reloatRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
    }
    
    private func removeChannelFromTable(_ channel: ChannelInfo) {
        guard let index = channels.firstIndex(of: channel) else { return }
        channels.remove(at: index)
        // TODO: - RX 적용하기
//        channtlTableView.deleteRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
    }
}
