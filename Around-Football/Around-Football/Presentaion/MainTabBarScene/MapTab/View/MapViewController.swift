//
//  MapViewController.swift
//  Around-Football
//
//  Created by 진태영 on 2023/09/27.
//

import CoreLocation
import UIKit

import KakaoMapsSDK
import RxSwift
import SnapKit
import Then

final class MapViewController: UIViewController {
    
    // MARK: - Properties
    
    private let disposeBag = DisposeBag()
    var viewModel: MapViewModel
    
    init(viewModel: MapViewModel) {
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
    
    private var buttonConfig: UIButton.Configuration {
        var config = UIButton.Configuration.plain()
        config.contentInsets = NSDirectionalEdgeInsets(top: 10,
                                                       leading: 10,
                                                       bottom: 10,
                                                       trailing: 10)
        config.imagePadding = 5
        config.titleAlignment = .leading
        return config
    }
    
    private lazy var searchFieldButton: UIButton = {
        let button = UIButton(configuration: buttonConfig)
        let image = UIImage(systemName: "magnifyingglass")
        button.setTitle("장소를 입력하세요", for: .normal)
        button.titleLabel?.font = AFFont.text?.withSize(16)
        button.setImage(image?.withTintColor(AFColor.grayScale300, renderingMode: .alwaysOriginal),for: .normal)
        button.setTitleColor(AFColor.grayScale100, for: .normal)
        button.layer.cornerRadius = LayoutOptions.cornerRadious
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .white
        button.setShadowLayer()
        button.contentHorizontalAlignment = .leading
        button.addTarget(self, action: #selector(pressSearchBar), for: .touchUpInside)
        return button
    }()
    
    private lazy var searchResultsController: UITableViewController = {
        let controller = UITableViewController(style: .plain)
        controller.tableView.dataSource = nil
        return controller
    }()
    
    private lazy var trackingButton = UIButton().then {
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 30, weight: .medium)
        let image = UIImage(named: AFIcon.trackingButton, in: nil, with: imageConfig)
        $0.setImage(image, for: .normal)
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
        setTableView()
        if let locationCoordinate = locationManager.location?.coordinate {
            viewModel.setCurrentLocation(latitude: locationCoordinate.latitude, longitude: locationCoordinate.longitude)
            
//            guard let viewModel = viewModel else { return }
            
            viewModel.fetchFields()
            //viewModel.selectedDate = self.datePicker.date
            _ = getlodDatas(label: MapLabel(labelType: .fieldPosition, poi: .fieldPosition(viewModel.fields.map{$0.id})), fields: viewModel.fields)
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
    private func pressSearchBar() {
        viewModel.coordinator?.presentSearchViewController()
    }
    
    @objc
    func pressTrackingButton() {
        self.changeCurrentPoi()
        let location = viewModel.currentLocation
        self.moveCamera(latitude: location.latitude, longitude: location.longitude)
    }
    
    @objc
    func changeDate(_ sender: UIDatePicker) {
        viewModel.selectedDate = sender.date
    }
    
    func tapHandler(_ param: PoiInteractionEventParam) {
        let itemID = param.poiItem.itemID
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
    
    private func setTableView() {
        searchResultsController.tableView.register(SearchTableViewCell.self,
                           forCellReuseIdentifier: SearchTableViewCell.cellID)
        searchResultsController.tableView.dataSource = nil
        
        let selectedItem = searchResultsController.tableView.rx.modelSelected(Place.self)
        
        selectedItem
            .subscribe(onNext: { [weak self] place in
                self?.viewModel.dataSubject
                    .onNext(place)
                self?.searchResultsController.dismiss(animated: true)
                self?.moveCamera(latitude: Double(place.y) ?? 127, 
                                 longitude: Double(place.x) ?? 38)
                self?.searchFieldButton.titleLabel?.text = place.name
            })
            .disposed(by: disposeBag)
        
        _ = viewModel.searchResults
            .debug()
            .bind(to: searchResultsController.tableView.rx.items(
                cellIdentifier: SearchTableViewCell.cellID,
                cellType: SearchTableViewCell.self)) { index, place, cell in
                    cell.fieldNameLabel.text = place.name
                    cell.fieldAddressLabel.text = place.address
                }
                .disposed(by: disposeBag)
    }
    
    private func configureUI() {
        view.backgroundColor = .systemBackground
        
        view.addSubviews(
            mapContainer,
            searchFieldButton,
            trackingButton
        )
        
        mapContainer.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(self.view)
            $0.bottom.equalTo(self.view.safeAreaLayoutGuide)
        }
        
        searchFieldButton.snp.makeConstraints {
            $0.top.equalToSuperview().offset(70)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
        }
        
        trackingButton.snp.makeConstraints {
            $0.leading.equalTo(mapContainer).offset(10)
            $0.bottom.equalTo(mapContainer).offset(-10)
            $0.height.width.equalTo(56)
        }
    }
}

extension MapViewController: UISearchResultsUpdating, UISearchBarDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        setTableView()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.searchFields(keyword: searchText, disposeBag: disposeBag)
    }
}
