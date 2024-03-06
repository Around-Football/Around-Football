//
//  Searchable.swift
//  Around-Football
//
//  Created by 강창현 on 2/29/24.
//

import UIKit

import RxSwift

protocol Searchable {
    func updateSearchBar(dataSubject: PublishSubject<Place>,
                         searchBarButton: UIButton,
                         disposeBag: DisposeBag)
}

extension Searchable {
    func updateSearchBar(dataSubject: PublishSubject<Place>,
                         searchBarButton: UIButton,
                         disposeBag: DisposeBag) {
        dataSubject
            .bind(onNext: { place in
                searchBarButton.setTitle(place.name, for: .normal)
                searchBarButton.setTitleColor(AFColor.grayScale400, for: .normal)
            })
            .disposed(by: disposeBag)
    }
}
