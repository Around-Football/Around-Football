//
//  MapViewController.swift
//  Around-Football
//
//  Created by 진태영 on 2023/09/27.
//

import UIKit
import KakaoMapsSDK
import SnapKit

class MapViewController: UIViewController, MapControllerDelegate {
    
    // MARK: - Properties
    private var mapContainer: KMViewContainer = KMViewContainer()
    var mapController: KMController?
    var _observerAdded: Bool = false
    var _auth: Bool = false
    var _appear = true

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
        _appear = false
        mapController?.stopRendering()  //렌더링 중지.
    }

    override func viewDidDisappear(_ animated: Bool) {
        removeObservers()
        mapController?.stopEngine()     //엔진 정지. 추가되었던 ViewBase들이 삭제된다.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        mapController?.initEngine() //엔진 초기화. 엔진 내부 객체 생성 및 초기화가 진행된다.
    }

    // MARK: - API
    // 인증 성공시 delegate 호출.
    func authenticationSucceeded() {
        _auth = true
        print("인증 성공")
        mapController?.startEngine()    //엔진 시작 및 렌더링 준비. 준비가 끝나면 MapControllerDelegate의 addViews 가 호출된다.
        mapController?.startRendering() //렌더링 시작.
    }
    
    // 인증 실패시 호출.
    func authenticationFailed(_ errorCode: Int, desc: String) {
        print("error code: \(errorCode)")
        print("\(desc)")
        
        // 인증 실패 delegate 호출 이후 5초뒤에 재인증 시도..
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
            print("retry auth...")
            
            self.mapController?.authenticate()
        }
    }
    
    // MARK: - Selectors
    @objc func willResignActive(){
        mapController?.stopRendering()  //뷰가 inactive 상태로 전환되는 경우 렌더링 중인 경우 렌더링을 중단.
    }

    @objc func didBecomeActive(){
        mapController?.startRendering() //뷰가 active 상태가 되면 렌더링 시작. 엔진은 미리 시작된 상태여야 함.
    }
    
    // MARK: - Helpers
    func configureMap() {
        //KMController 생성.
        mapController = KMController(viewContainer: mapContainer)!
        mapController!.delegate = self
        
//        mapController?.initEngine() //엔진 초기화. 엔진 내부 객체 생성 및 초기화가 진행된다.
    }

    func configureUI() {
        view.backgroundColor = .systemBackground
        view.addSubview(mapContainer)
        mapContainer.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(self.view)
            $0.bottom.equalTo(self.view.safeAreaLayoutGuide)
        }
    }
    
    func addViews() {
        //여기에서 그릴 View(KakaoMap, Roadview)들을 추가한다.
        let defaultPosition: MapPoint = MapPoint(longitude: 127.108678, latitude: 37.402001)
        //지도(KakaoMap)를 그리기 위한 viewInfo를 생성
        let mapviewInfo: MapviewInfo = MapviewInfo(viewName: "mapview", viewInfoName: "map", defaultPosition: defaultPosition, defaultLevel: 14)
        //KakaoMap 추가.
        if mapController?.addView(mapviewInfo) == Result.OK {
            print("OK") //추가 성공. 성공시 추가적으로 수행할 작업을 진행한다.
        }
    }
    
    //Container 뷰가 리사이즈 되었을때 호출된다. 변경된 크기에 맞게 ViewBase들의 크기를 조절할 필요가 있는 경우 여기에서 수행한다.
    func containerDidResized(_ size: CGSize) {
        let mapView: KakaoMap? = mapController?.getView("mapview") as? KakaoMap
        mapView?.viewRect = CGRect(origin: CGPoint(x: 0.0, y: 0.0), size: size)   //지도뷰의 크기를 리사이즈된 크기로 지정한다.
    }
    
    func addObservers(){
        NotificationCenter.default.addObserver(self, selector: #selector(willResignActive), name: UIApplication.willResignActiveNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didBecomeActive), name: UIApplication.didBecomeActiveNotification, object: nil)
    
        _observerAdded = true
    }
     
    func removeObservers(){
        NotificationCenter.default.removeObserver(self, name: UIApplication.willResignActiveNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIApplication.didBecomeActiveNotification, object: nil)

        _observerAdded = false
    }
}
