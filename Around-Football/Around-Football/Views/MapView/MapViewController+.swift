//
//  MapViewController+.swift
//  Around-Football
//
//  Created by 진태영 on 10/5/23.
//

import Foundation
import CoreLocation

import KakaoMapsSDK

extension MapViewController: MapControllerDelegate, KakaoMapEventDelegate {
    
    // MARK: - API
    // 인증 성공시 delegate 호출.
    func authenticationSucceeded() {
        _auth = true
        print("인증 성공")
        
        //엔진 시작 및 렌더링 준비. 준비가 끝나면 MapControllerDelegate의 addViews 가 호출된다.
        mapController?.startEngine()
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
        mapController?.initEngine() //엔진 초기화. 엔진 내부 객체 생성 및 초기화가 진행된다.
    }
    
    func addViews() {
        //여기에서 그릴 View(KakaoMap, Roadview)들을 추가한다.
        guard let location = self.viewModel?.currentLocation else {
            print("Map AddView Failed")
            return
        }
        
        let defaultPosition: MapPoint = MapPoint(
            longitude: location.longitude,
            latitude: location.latitude
        )
        //지도(KakaoMap)를 그리기 위한 viewInfo를 생성
        let mapviewInfo: MapviewInfo = MapviewInfo(
            viewName: "mapview",
            viewInfoName: "map",
            defaultPosition: defaultPosition,
            defaultLevel: 14
        )
        //KakaoMap 추가.
        if mapController?.addView(mapviewInfo) == Result.OK {
            print("OK") //추가 성공. 성공시 추가적으로 수행할 작업을 진행한다.
            
            guard let location = self.viewModel?.currentLocation else { return }
            // POI
            let currentMapLabel = MapLabel(labelType: .currentPosition, poi: .currentPosition)
            let mapPoint = MapPoint(longitude: location.longitude, latitude: location.latitude)
            createLabelLayer(label: currentMapLabel)
            createPoiStyle(label: currentMapLabel)
            createPois(label: currentMapLabel, mapPoint: mapPoint)
            moveCamera(latitude: location.latitude, longitude: location.longitude)
            // GUI
            //            createSpriteGUI()
            
            guard let fields = self.viewModel?.fields else { return }
            let idArray = fields.map { $0.id }
            let fieldsMapLabel = MapLabel(labelType: .fieldPosition, poi: .fieldPosition(idArray))
            createLabelLayer(label: fieldsMapLabel)
            createPoiStyle(label: fieldsMapLabel)
            createPois(label: fieldsMapLabel, fields: fields)
        }
        
    }
    
    /**
     Container 뷰가 리사이즈 되었을때 호출된다.
     변경된 크기에 맞게 ViewBase들의 크기를 조절할 필요가 있는 경우 여기에서 수행한다.
     **/
    func containerDidResized(_ size: CGSize) {
        print("---------------------")
        print("resize: \(size)")
        print("---------------------")
        let mapView: KakaoMap? = mapController?.getView("mapview") as? KakaoMap
        //지도뷰의 크기를 리사이즈된 크기로 지정한다.
        mapView?.viewRect = CGRect(origin: CGPoint(x: 0.0, y: 0.0), size: size)
    }
    
    func addObservers(){
        NotificationCenter.default.addObserver(self, selector: #selector(willResignActive), name: UIApplication.willResignActiveNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didBecomeActive), name: UIApplication.didBecomeActiveNotification, object: nil)
        
        _observerAdded = true
    }
    
    func removeObservers(){
        NotificationCenter.default.removeObserver(
            self,
            name: UIApplication.willResignActiveNotification,
            object: nil
        )
        NotificationCenter.default.removeObserver(
            self,
            name: UIApplication.didBecomeActiveNotification,
            object: nil
        )
        
        _observerAdded = false
    }
    
    func moveCamera(latitude: Double, longitude: Double) {
        guard let mapView: KakaoMap = mapController?.getView("mapview") as? KakaoMap
        else { return }
        
        let animationOptions = CameraAnimationOptions(
            autoElevation: true,
            consecutive: true,
            durationInMillis: 1000
        )
        let mappoint = MapPoint(longitude: longitude, latitude: latitude)
        mapView.animateCamera(
            cameraUpdate: CameraUpdate.make(
                target: mappoint,
                zoomLevel: 14, mapView: mapView),
            options: animationOptions
        )
    }
    
    // MARK: - POI
    // Poi 생성을 위한 LabelLayer 생성 함수
    func createLabelLayer(label: MapLabel) {
        let mapView: KakaoMap = mapController?.getView("mapview") as! KakaoMap
        let manager = mapView.getLabelManager()
        
        switch label.labelType {
        case .currentPosition:
            let layerOptions = LabelLayerOptions(
                layerID: label.layerID,
                competitionType: .none,
                competitionUnit: .symbolFirst,
                orderType: .rank,
                zOrder: 5000
            )
            let _ = manager.addLabelLayer(option: layerOptions)
            
        case .fieldPosition:
            let layerOptions = LodLabelLayerOptions(
                layerID: label.layerID,
                competitionType: .none,
                competitionUnit: .symbolFirst,
                orderType: .rank,
                zOrder: 0,
                radius: 20.0
            )
            let _ = manager.addLodLabelLayer(option: layerOptions)
        }
        
    }
    
    func createPoiStyle(label: MapLabel) {
        let mapView: KakaoMap = mapController?.getView("mapview") as! KakaoMap
        let manager = mapView.getLabelManager()
        let anchorPoint: CGPoint
        switch label.labelType {
        case .currentPosition: anchorPoint = CGPoint(x: 0.5, y: 0.5)
        case .fieldPosition: anchorPoint = CGPoint(x: 0.5, y: 1)
        }
        
        let iconStyle = PoiIconStyle(symbol: label.poiImage, anchorPoint: anchorPoint)
        let poiStyle = PoiStyle(styleID: label.poiStyle, styles: [
            PerLevelPoiStyle(iconStyle: iconStyle, level: 0)
        ])
        manager.addPoiStyle(poiStyle)
        
    }
    
    func createPois(label: MapLabel,
                    mapPoint: MapPoint = MapPoint(longitude: 0, latitude: 0),
                    fields: [Field] = []) {
        let mapView: KakaoMap = mapController?.getView("mapview") as! KakaoMap
        let manager = mapView.getLabelManager()
        
        if label.labelType == .currentPosition {
            let layer = manager.getLabelLayer(layerID: label.layerID)
            let poiOption = PoiOptions(styleID: label.poiStyle, poiID: label.poiID[0])
            poiOption.rank = label.poiRank
            let poi1 = layer?.addPoi(option: poiOption, at: mapPoint)
            poi1?.show()
            
            return
        }
        
        if label.labelType == .fieldPosition {
            let layer = manager.getLodLabelLayer(layerID: label.layerID)
            let datas = getlodDatas(label: label, fields: fields)
            let lodPois = layer?.addLodPois(options: datas.0, at: datas.1)
            guard let lodPois = lodPois else { return }
            let _ = lodPois.map {
                let _ = $0.addPoiTappedEventHandler(
                    target: self,
                    handler: MapViewController.tapHandler
                )
            }
            
            layer?.showAllLodPois()
        }
        
    }
    
    func getlodDatas( label: MapLabel, fields: [Field]) -> ([PoiOptions], [MapPoint]) {
        var options: [PoiOptions] = []
        var positions: [MapPoint] = []
        
        for field in fields {
            let option = PoiOptions(styleID: label.poiStyle, poiID: field.id)
            option.rank = label.poiRank
            option.transformType = .decal
            option.clickable = true
            let position = MapPoint(
                longitude: field.location.longitude,
                latitude: field.location.latitude
            )
            options.append(option)
            positions.append(position)
        }
        
        return (options, positions)
    }
    
    func changeCurrentPoi() {
        guard let mapView: KakaoMap = mapController?.getView("mapview") as? KakaoMap
        else { return }
        let manager = mapView.getLabelManager()
        let mapLabel = MapLabel(labelType: .currentPosition, poi: .currentPosition)
        let layer = manager.getLabelLayer(layerID: mapLabel.layerID)
        let poi = layer?.getPoi(poiID: mapLabel.poiID[0])
        
        guard let location = self.viewModel?.currentLocation else { return }
        let newPoint = MapPoint(longitude: location.longitude, latitude: location.latitude)
        poi?.moveAt(newPoint, duration: 1000)
    }
    
}

/*
 extension MapViewController: GuiEventDelegate {
 // MARK: - SpriteGUI
 func createSpriteGUI() {
 guard let mapView: KakaoMap = mapController?.getView("mapview") as? KakaoMap else { return }
 let guiManager = mapView.getGuiManager()
 let spriteGui = SpriteGui("PositionToolSprite")
 
 spriteGui.arrangement = .horizontal
 spriteGui.bgColor = UIColor.clear
 spriteGui.splitLineColor = UIColor.white
 spriteGui.origin = GuiAlignment(vAlign: .bottom, hAlign: .left)
 spriteGui.position = CGPoint(x: 50, y: 50)
 
 let trackingButtonName: GuiButtonComponent = .trackingPosition
 let currentPositionButton = GuiButton(trackingButtonName.name)
 let locationImage = UIImage(systemName: "location")
 currentPositionButton.image = UIImage(systemName: "location")
 currentPositionButton.imageSize = GuiSize(width: 20, height: 20)
 currentPositionButton.padding = GuiPadding(left: 10, right: 10, top: 10, bottom: 10)
 
 spriteGui.addChild(currentPositionButton)
 
 guiManager.spriteGuiLayer.addSpriteGui(spriteGui)
 spriteGui.delegate = self
 spriteGui.show()
 }
 
 func guiDidTapped(_ gui: GuiBase, componentName: String) {
 print("Gui: \(gui.name), Component: \(componentName) tapped")
 
 guard let viewModel = self.viewModel else { return }
 
 switch componentName {
 case GuiButtonComponent.trackingPosition.name:
 let location = viewModel.currentLocation
 changeCurrentPoi()
 moveCamera(latitude: location.latitude, longitude: location.longitude)
 default: break
 }
 
 }
 }
 */

extension MapViewController: CLLocationManagerDelegate {
    func setLocationManager() {
        // 델리게이트
        locationManager.delegate = self
        // 거리 정확도
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        // 위치 사용 허용 알림
        locationManager.requestWhenInUseAuthorization()
        // 위치 사용 허용 여부 분기처리
        if locationManager.authorizationStatus == .authorizedAlways
            ||
            locationManager.authorizationStatus == .authorizedWhenInUse {
            locationManager.startUpdatingLocation()
        } else {
            print("위치 서비스 허용 OFF")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        print("현재 위치 업데이트")
        print("위도: \(location.coordinate.latitude)")
        print("경도: \(location.coordinate.longitude)")
        // 현재 고유위치  37.253463   127.036306
        guard let viewModel = viewModel else { return }
        //        // 현재 위치로 카메라 이동
        //        if viewModel.isSearchCurrentLocation {
        viewModel.setCurrentLocation(
            latitude: location.coordinate.latitude,
            longitude: location.coordinate.longitude
        )
        //            changeCurrentPoi()
        //            moveCamera(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        //            viewModel.isSearchCurrentLocation = false
        //        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("LocationManager Error: \(error.localizedDescription)")
    }
}
