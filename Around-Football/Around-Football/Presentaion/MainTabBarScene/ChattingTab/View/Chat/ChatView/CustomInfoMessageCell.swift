//
//  CustomInfoMessageCell.swift
//  Around-Football
//
//  Created by 진태영 on 12/6/23.
//

import UIKit

import MessageKit
import SnapKit
import Then

final class CustomInfoMessageCell: UICollectionViewCell {
    
    static let cellId = "DateMessageCell"
    
    let label = UILabel().then {
        $0.textColor = .white
        $0.font = .systemFont(ofSize: 10)
        $0.backgroundColor = .lightGray
        $0.layer.cornerRadius = 10
        $0.clipsToBounds = true
        $0.textAlignment = .center
        $0.numberOfLines = 0
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        addSubviews(label)
        updateCustomInfoLabelUI()
        label.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
    
    func updateCustomInfoLabelUI() {
        label.snp.updateConstraints {
            let size = setTextLabelSize(label: label)
            $0.width.equalTo(size.width)
            $0.height.equalTo(size.height)
        }
    }
    
    private func setTextLabelSize(label: UILabel) -> CGSize {
        let size = (label.text as NSString?)?.size() ?? .zero
        let newSize = CGSize(width: size.width + 15, height: size.height + 10)
        return newSize
    }
}

final class CustomInfoMessageCellSizeLayout: CellSizeCalculator {
    
    init(layout: MessagesCollectionViewFlowLayout? = nil) {
        super.init()
        self.layout = layout
    }
    
    override func sizeForItem(at _: IndexPath) -> CGSize {
        let width = (layout?.collectionView?.bounds.width ?? 0)
        let height: CGFloat = 60
        return CGSize(width: width, height: height)
    }
}
