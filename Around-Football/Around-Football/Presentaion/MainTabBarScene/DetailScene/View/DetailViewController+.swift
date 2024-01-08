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
                
                // 비활성화 경우는 두 가지밖에 없고, close가 아닌 경우는 비활성화 상태시 나머지 경우로 처리(비활성화 아닌 경우는 정상 색상)
                let disabledBackground = recruitStatus == .close ? AFColor.grayScale200 : AFColor.grayScale50
                let disabledTitleColor = recruitStatus == .close ? UIColor.white : AFColor.grayScale300
                owner.setButtonUI(isEnabledSendButton: isEnabledSendButton,
                                  sendButtonTitle: sendButtonTitle,
                                  isHiddenMessageButton: isHiddenMessageButton,
                                  isHiddenBookmark: isHiddenBookmark,
                                  disabledBackground: disabledBackground,
                                  disabledTitleColor: disabledTitleColor)
                owner.configureBookmarkStyle()
            }
            .disposed(by: disposeBag)
        
        outputObservable
            .withUnretained(self)
            .bind { (owner, recruitStatus) in
                if recruitStatus == .ownRecruit {
                    owner.navigationItem.rightBarButtonItem = owner.navigationRightButton
                }
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
    
    func bindRecruit() {
        viewModel.recruitItem
            .bind(with: self) { owner, recruit in
                owner.detailView.setValues(recruit: recruit)
            }
            .disposed(by: disposeBag)
    }
}
