//
//  HomeViewModel.swift
//  Around-Football
//
//  Created by 강창현 on 10/12/23.
//

import UIKit

import Kingfisher
import RxSwift

final class HomeViewModel {
    
    struct Input {
        let loadRecruitList: Observable<RecruitFilter>
    }
    
    struct Output {
        let recruitList: Observable<[Recruit]>
    }
    
    // MARK: - Properties
    
    weak var coordinator: HomeTabCoordinator?
    private let disposeBag = DisposeBag()
    
    // MARK: - Lifecycles
    
    init(coordinator: HomeTabCoordinator) {
        self.coordinator = coordinator
    }
    
    // MARK: - Helpers
    
    func transform(_ input: Input) -> Output {
        let recruitList = loadRecruitList(by: input.loadRecruitList)
        let output = Output(recruitList: recruitList)
        return output
    }
    
    private func loadRecruitList(by inputObserver: Observable<RecruitFilter>) -> Observable<[Recruit]> {
        inputObserver
            .flatMap { input -> Observable<[Recruit]> in
                let recruitObservable = FirebaseAPI.shared.readRecruitRx(input: input)
                return recruitObservable
            }
    }
    
    func setTitleImage(recruit: Recruit) -> UIImage? {
        return recruit.type == "풋살" ? setFutsalImage(recruit: recruit) : setFootballImage(recruit: recruit)
    }
    
    // MARK: - ImageRender
    private func setFutsalImage(recruit: Recruit) -> UIImage? {
        let imageView = UIImageView()
        let placeHolder = UIImage(named: AFIcon.fieldImage)
        imageView.kf.setImage(with: URL(string:recruit.recruitImages.first ?? AFIcon.defaultImageURL),
                                        placeholder: placeHolder)
        return imageView.image
    }
    
    private func setFootballImage(recruit: Recruit) -> UIImage? {
        let imageView = UIImageView()
        let placeHolder = AFIcon.defaultfootballImage
        imageView.kf.setImage(with: URL(string:recruit.recruitImages.first ?? AFIcon.defaultFootballImageURL),
                                        placeholder: placeHolder)
        return imageView.image
    }
}
