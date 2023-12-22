//
//  PopUpAlertViewController.swift
//  Around-Football
//
//  Created by 진태영 on 12/22/23.
//

import UIKit

import SnapKit
import Then

class PopUpViewController: UIViewController {
    
    // MARK: - Properties
    
    private var titleText: String?
    private var messageText: String?
    private var attributedMessageText: NSAttributedString?
    private var contentView: UIView?
        
    private lazy var containerView = UIView().then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 8
    }
    
    private lazy var containerStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 8
        $0.alignment = .center
    }
    
    private lazy var buttonStackView = UIStackView().then {
        $0.spacing = 8
        $0.distribution = .fillEqually
    }
    
    private let aflogoImageView = UIImageView().then {
        $0.image = UIImage(named: "AFSmallLogo")
    }
    
    private lazy var titleLabel: UILabel? = {
        let label = UILabel()
        label.text = titleText
        label.textAlignment = .center
        label.font = AFFont.titleMedium
        label.numberOfLines = 0
        label.textColor = AFColor.secondary

        return label
    }()
    
    private lazy var messageLabel: UILabel? = {
        guard messageText != nil || attributedMessageText != nil else { return nil }
        
        let label = UILabel()
        label.text = messageText
        label.textAlignment = .center
        label.font = AFFont.filterRegular
        label.textColor = AFColor.grayScale300
        label.numberOfLines = 0
        
        if let attributedMessageText = attributedMessageText {
            label.attributedText = attributedMessageText
        }
        
        return label
    }()
    
    // MARK: - Lifecycles
    
    convenience init(titleText: String? = nil,
                     messageText: String? = nil,
                     attributedMessageText: NSAttributedString? = nil) {
        self.init()
        
        self.titleText = titleText
        self.messageText = messageText
        self.attributedMessageText = attributedMessageText
        /// present 시 fullScreen (화면을 덮도록 설정) -> 설정 안하면 pageSheet 형태 (위가 좀 남아서 밑에 깔린 뷰가 보이는 형태)
        modalPresentationStyle = .overFullScreen
    }
    
    convenience init(contentView: UIView) {
        self.init()
        
        self.contentView = contentView
        modalPresentationStyle = .overFullScreen
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        addSubviews()
        makeConstraints()
        self.view.alpha = 0
        self.view.backgroundColor = .black.withAlphaComponent(0)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIView.animate(withDuration: 0.5) {
            self.view.alpha = 1
            self.view.backgroundColor = .black.withAlphaComponent(0.7)
        }
    }
    
    // MARK: - Helpers
    
    public func addActionToButton(title: String? = nil,
                                  titleColor: UIColor = .white,
                                  backgroundColor: UIColor = .blue,
                                  completion: (() -> Void)? = nil) {
        let button = UIButton()
        button.titleLabel?.font = AFFont.titleSmall
        
        // enable
        button.setTitle(title, for: .normal)
        button.setTitleColor(titleColor, for: .normal)
        button.setBackgroundImage(backgroundColor.image(), for: .normal)
        
        // disable
        button.setTitleColor(.gray, for: .disabled)
        button.setBackgroundImage(UIColor.gray.image(), for: .disabled)
        
        // layer
        button.layer.cornerRadius = 4.0
        button.layer.masksToBounds = true
        
        button.addAction(for: .touchUpInside) { _ in
            completion?()
        }
        
        buttonStackView.addArrangedSubview(button)
    }
    
    private func setupViews() {
        view.addSubview(containerView)
        containerView.addSubview(containerStackView)
    }
    
    private func addSubviews() {
        containerView.addSubview(aflogoImageView)
        if let contentView = contentView {
            containerStackView.addSubview(contentView)
        } else {
            if let titleLabel = titleLabel {
                containerStackView.addArrangedSubview(titleLabel)
            }
            
            if let messageLabel = messageLabel {
                containerStackView.addArrangedSubview(messageLabel)
            }
        }
        
        if let lastView = containerStackView.subviews.last {
            containerStackView.setCustomSpacing(20.0, after: lastView)
        }
        
        containerStackView.addArrangedSubview(buttonStackView)
    }
    
    private func makeConstraints() {
        containerView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(48)
            $0.trailing.equalToSuperview().offset(-48)
            $0.top.greaterThanOrEqualToSuperview().offset(32)
            $0.bottom.lessThanOrEqualToSuperview().offset(-32)
        }
        
        aflogoImageView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(29)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(28)
            $0.height.equalTo(37)
        }
        containerStackView.snp.makeConstraints {
            $0.top.equalTo(aflogoImageView.snp.bottom).offset(16)
            $0.leading.equalToSuperview().offset(40)
            $0.trailing.equalToSuperview().offset(-40)
            $0.bottom.equalToSuperview().offset(-29)
        }
        buttonStackView.snp.makeConstraints {
            $0.height.equalTo(36)
            $0.width.equalToSuperview()
        }
    }
    
}

extension PopUpViewController {
    static let matchAlertTitle = "매치 신청 확인"
    static let matchAlertMessage = "매치 신청 이후 취소를 원하시면 작성자에게 채팅하기를 통해 문의해주세요!"
    
    override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        UIView.animate(withDuration: 0.5, animations: {
            self.view.alpha = 0
        }, completion: { _ in
            super.dismiss(animated: false, completion: completion)
        })
    }
}
