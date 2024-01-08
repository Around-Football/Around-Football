//
//  WebViewController.swift
//  Around-Football
//
//  Created by Deokhun KIM on 1/2/24.
//
import UIKit
import WebKit

import SnapKit
import Then

final class WebViewController: UIViewController {
    
    //MARK: - Properties
    var viewModel: SettingViewModel?
    var url: String
    
    init(viewModel: SettingViewModel?, url: String) {
        self.viewModel = viewModel
        self.url = url
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var webView = WKWebView(frame: view.bounds).then {
        $0.navigationDelegate = self
    }
    
    private lazy var indicator = UIActivityIndicatorView().then {
        $0.color = .gray
        
        webView.addSubview($0)
        $0.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(150)
            make.height.equalTo(150)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        loadWebView(url: url)
    }

    private func configureUI() {
        navigationItem.title = "약관 및 정책"
        view.backgroundColor = .systemBackground
        
        view.addSubview(webView)
        webView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.left.bottom.right.equalToSuperview()
        }
        
    }
    
    private func loadWebView(url: String) {
        guard let url = URL(string: url) else { return }
        let request = URLRequest(url: url)
        webView.load(request)
    }

}

extension WebViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didStartProvisionalNavigation: WKNavigation!) {
        indicator.startAnimating()
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        indicator.stopAnimating()
        indicator.hidesWhenStopped = true
    }
}
