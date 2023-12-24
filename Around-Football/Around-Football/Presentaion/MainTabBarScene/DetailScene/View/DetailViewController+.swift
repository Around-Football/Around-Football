//
//  DetailViewController+.swift
//  Around-Football
//
//  Created by 진태영 on 12/24/23.
//

import UIKit

import RxSwift
import RxCocoa

extension DetailViewController {
    typealias RecruitStatus = DetailViewModel.RecruitStatus
    
    func bindButtonAction() {
        
        sendRecruitButton.rx.tap
            .bind { [weak self] _ in
                guard let self = self,
                      let recruit = viewModel.getRecruit() else { return }
                
                guard let currentUser = viewModel.getCurrentUser() else {
                    viewModel.showLoginView()
                    return
                }
                
                if currentUser.id == recruit.userID {
                    viewModel.showApplicationStatusView()
                } else {
                    showPopUp(title: PopUpViewController.matchAlertTitle,
                              message: PopUpViewController.matchAlertMessage,
                              leftActionTitle: "취소",
                              rightActionTitle: "신청",
                              rightActionCompletion: viewModel.sendRecruitApplicant)
                }
            }
            .disposed(by: disposeBag)
        
        sendMessageButton.rx.tap
            .bind { [weak self] _ in
                guard let self = self else { return }
                if viewModel.getCurrentUser() != nil {
                    viewModel.checkChannelAndPushChatViewController()
                } else {
                    viewModel.showLoginView()
                }
            }
            .disposed(by: disposeBag)
        
        bookMarkButton.rx.tap
            .withUnretained(self)
            .bind { (owner, _) in
                guard owner.viewModel.getCurrentUser() != nil else {
                    owner.viewModel.showLoginView()
                    return
                }
                
                if owner.viewModel.isSelectedBookmark == true {
                    owner.viewModel.removeBookmark() {
                        owner.configureBookmarkStyle()
                    }
                } else {
                    owner.viewModel.addBookmark() {
                        owner.configureBookmarkStyle()
                    }
                }
            }
            .disposed(by: disposeBag)
    }
    
    func bindButtonStyle(by outputObservable: Observable<RecruitStatus>) {
        outputObservable
            .withUnretained(self)
            .bind { (owner, recruitStatus) in
                let isEnabledSendButton = (recruitStatus == .availableRecruit) || (recruitStatus == .ownRecruit) ?
                true : false
                
                let sendButtonTitle = recruitStatus.statusDescription
                
                let isHiddenMessageButton = (recruitStatus == .close) || (recruitStatus == .ownRecruit) ?
                true : false
                
                let isHiddenBookmark = (recruitStatus == .ownRecruit) ? true : false
                
                owner.setButtonUI(isEnabledSendButton: isEnabledSendButton,
                                  sendButtonTitle: sendButtonTitle,
                                  isHiddenMessageButton: isHiddenMessageButton,
                                  isHiddenBookmark: isHiddenBookmark)
                owner.configureBookmarkStyle()
            }
            .disposed(by: disposeBag)
    }
    
    func bindRecruitUser() {
        viewModel.recruitUser
            .bind { [weak self] user in
                guard let self = self,
                      let user = user else { return }
                detailUserInfoView.setValues(user: user)
            }
            .disposed(by: disposeBag)
    }
}
