//
//  DetailViewController+.swift
//  Around-Football
//
//  Created by Deokhun KIM on 10/7/23.
//

import UIKit

// TODO: - Rx 이전 함수. 삭제하기

//extension DetailViewController: UITableViewDelegate, UITableViewDataSource {
//    //셀 갯수 (임시)
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        cellTitles.count
//    }
//    
//    //셀 높이 (임시)
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        indexPath.row == 6 ? 100 : 40
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//
//        let contents = ["2023.09.30(토) 17:00~19:00", "풋살", "남2(20,30,40대)",
//                        "2년 이하", "3.0", "인당 10,000원",
//                        "1년 이상 게임경험 있으신 분들로 모집합니다! 1년 이상 게임경험 있으신 분들로 모집합니다! 1년 이상 게임경험 있으신 분들로 모집합니다! 1년 이상 게임경험 있으신 분들로 모집합니다!"]
//        
//        let cell = detailTableView.dequeueReusableCell(withIdentifier: DetailUserInfoCell.cellID,
//                                                       for: indexPath) as! DetailUserInfoCell
//        cell.setValues(title: cellTitles[indexPath.row], contents: contents[indexPath.row])
//        return cell
//    }
//}
