//
//  MapViewController.swift
//  Around-Football
//
//  Created by 진태영 on 2023/09/27.
//

import UIKit
import KakaoMapsSDK
import SnapKit
import Then
import CoreLocation

class MapViewController: UIViewController {
    
    // MARK: - Properties
    var mapContainer: KMViewContainer = KMViewContainer()
    var mapController: KMController?
    var _observerAdded: Bool = false
    var _auth: Bool = false
    var _appear = true
    var locationManager = CLLocationManager()
    var viewModel: MapViewModel?
    
    private let searchTextField = UISearchTextField().then {
        $0.placeholder = "장소를 입력하세요."
        $0.backgroundColor = .systemBackground
        
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
            self.viewModel = MapViewModel(latitude: locationCoordinate.latitude, longitude: locationCoordinate.longitude)
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
        mapController?.initEngine() //엔진 초기화. 엔진 내부 객체 생성 및 초기화가 진행된다.
    }

    func configureUI() {
        view.backgroundColor = .systemBackground
        view.addSubview(mapContainer)
        mapContainer.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(self.view)
            $0.bottom.equalTo(self.view.safeAreaLayoutGuide)
        }
        
        view.addSubview(searchTextField)
        searchTextField.snp.makeConstraints {
            $0.top.equalTo(self.view.safeAreaLayoutGuide).offset(5)
            $0.leading.equalTo(self.view).offset(16)
            $0.trailing.equalTo(self.view).offset(-16)
            $0.height.equalTo(40)
        }
    }
    
}
