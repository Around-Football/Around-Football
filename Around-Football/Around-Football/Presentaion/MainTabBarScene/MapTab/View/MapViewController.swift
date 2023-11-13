//
//  MapViewController.swift
//  Around-Football
//
//  Created by 진태영 on 2023/09/27.
//

import CoreLocation
import UIKit

import KakaoMapsSDK
import SnapKit
import Then

protocol MapViewControllerDelegate: AnyObject {
    //
}

final class MapViewController: UIViewController {
    
    // MARK: - Properties
    
    weak var delegate: MapViewControllerDelegate?
    var viewModel: MapViewModel?
    
    init(delegate: MapViewControllerDelegate, viewModel: MapViewModel) {
        self.delegate = delegate
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var mapContainer: KMViewContainer = KMViewContainer(frame: self.view.frame)
    var mapController: KMController?
    var _observerAdded: Bool = false
    var _auth: Bool = false
    var _appear = true
    var locationManager = CLLocationManager()
    var modalViewController: FieldDetailViewController?
    
    private let searchTextField = UISearchTextField().then {
        $0.placeholder = "장소를 입력하세요."
        $0.subviews[0].alpha = 0
        $0.layer.backgroundColor = UIColor.white.cgColor
        $0.layer.cornerRadius = LayoutOptions.cornerRadious
        $0.setShadowLayer()
    }
    
    private lazy var datePicker = UIDatePicker().then {
        $0.preferredDatePickerStyle = .compact
        $0.datePickerMode = .date
        $0.locale = Locale(identifier: "ko_KR")
        $0.subviews[0].subviews[0].subviews[0].alpha = 0
        $0.layer.backgroundColor = UIColor.white.cgColor
        $0.layer.cornerRadius = LayoutOptions.cornerRadious
        $0.setShadowLayer()
        $0.addTarget(self, action: #selector(changeDate(_:)), for: .valueChanged)
    }
        
    private lazy var trackingButton = UIButton().then {
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 30, weight: .medium)
        let image = UIImage(systemName: "location", withConfiguration: imageConfig)
        $0.setImage(image, for: .normal)
        $0.backgroundColor = .white
        $0.tintColor = .black
        $0.layer.cornerRadius = 56/2
        $0.setShadowLayer()
        $0.addTarget(self, action: #selector(pressTrackingButton), for: .touchUpInside)
    }
    
    // MARK: - Lifecycle
    
    deinit {
        mapController?.stopRendering()
        mapController?.stopEngine()
        
        print("deinit")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureMap()
        configureUI()
        setLocationManager()
        if let locationCoordinate = locationManager.location?.coordinate {
            self.viewModel = MapViewModel(
                latitude: locationCoordinate.latitude,
                longitude: locationCoordinate.longitude
            )
            
            guard let viewModel = viewModel else { return }
            
            viewModel.fetchFields()
            viewModel.selectedDate = self.datePicker.date
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        addObservers()
        _appear = true
        //        if _auth {
        if mapController?.engineStarted == false {
            mapController?.startEngine()
        }
        
        if mapController?.rendering == false {
            mapController?.startRendering()
        }
        //        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        //        _appear = false
        //        mapController?.stopRendering()  //렌더링 중지.
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        //        removeObservers()
        //        mapController?.stopEngine()     //엔진 정지. 추가되었던 ViewBase들이 삭제된다.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        //        mapController?.initEngine() //엔진 초기화. 엔진 내부 객체 생성 및 초기화가 진행된다.
    }
    
    // MARK: - Selectors
    
    @objc
    func pressTrackingButton() {
        self.changeCurrentPoi()
        guard let location = viewModel?.currentLocation else { return }
        self.moveCamera(latitude: location.latitude, longitude: location.longitude)
    }
    
    @objc
    func changeDate(_ sender: UIDatePicker) {
        guard let viewModel = self.viewModel else { return }
        viewModel.selectedDate = sender.date
    }
    
    func tapHandler(_ param: PoiInteractionEventParam) {
        let itemID = param.poiItem.itemID
        guard let viewModel = self.viewModel else { return }
        guard let field = viewModel.fields.filter({ $0.id == itemID }).first else { return }
        let selectedDate = viewModel.selectedDate
        
        let fieldViewModel = FieldDetailViewModel(field: field, selectedDate: selectedDate)
        self.modalViewController = FieldDetailViewController(viewModel: fieldViewModel)
        
        if let modalViewController = self.modalViewController {
            let navigation = UINavigationController(rootViewController: modalViewController)
            present(navigation, animated: true)
        }
    }
    
    
    // MARK: - Helpers
    
    private func configureUI() {
        view.backgroundColor = .systemBackground
        
        view.addSubviews(
            mapContainer,
            searchTextField,
            datePicker,
            trackingButton
        )
        
        mapContainer.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(self.view)
            $0.bottom.equalTo(self.view.safeAreaLayoutGuide)
        }
        
        searchTextField.snp.makeConstraints {
            $0.top.equalTo(self.view.safeAreaLayoutGuide).offset(5)
            $0.leading.equalTo(self.view).offset(16)
            $0.trailing.equalTo(self.view).offset(-16)
            $0.height.equalTo(40)
        }
        
        datePicker.snp.makeConstraints {
            $0.top.equalTo(searchTextField.snp.bottom).offset(10)
            $0.centerX.equalToSuperview()
        }
        
        trackingButton.snp.makeConstraints {
            $0.leading.equalTo(mapContainer).offset(20)
            $0.bottom.equalTo(mapContainer).offset(-20)
            $0.height.width.equalTo(56)
        }
    }
}
