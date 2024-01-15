//
//  HomeViewModel.swift
//  Around-Football
//
//  Created by 강창현 on 10/12/23.
//

import UIKit

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
    
    func setTitleImage(recruit: Recruit) -> UIImage {
        guard 
            let defaultImage = UIImage(named: AFIcon.fieldImage)
        else {
            return UIImage()
        }
        guard
            let titleImageURL = recruit.recruitImages.first,
            let url = URL(string: titleImageURL)
        else {
            return defaultImage
        }
        var titleImage: UIImage = UIImage()
        StorageAPI.downloadImage(url: url) { image in
            guard let image = image else { return }
            titleImage = image
        }
        return titleImage
    }
}
