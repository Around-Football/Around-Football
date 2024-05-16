//
//  AlertMessage.swift
//  Around-Football
//
//  Created by 강창현 on 5/16/24.
//

enum AlertMessage {
    case actionSheet
    case userBlock(userName: String)
    
    var description: String {
        switch self {
        case .actionSheet:
            "내부 검토 후  24시간 이내 해당 유저의 이용제한 절차가 진행됩니다. 허위 신고 시 서비스 이용제한 등의 불이익을 받을 수 있으니 주의해 주세요."
        case .userBlock(let userName):
                    """
                    신고 유저: \(userName)\n
                    신고 사유:\n
                    신고 내용:
                    """
        }
    }
}
