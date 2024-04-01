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
    var searchViewModel: SearchViewModel?
    
    init(viewModel: MapViewModel, searchViewModel: SearchViewModel? = nil) {
        self.viewModel = viewModel
        self.searchViewModel = searchViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var mapContainer: KMViewContainer = KMViewContainer(
        frame: CGRect(
            x: 0,
            y: 0,
            width: UIScreen.main.bounds.width,
            height: UIScreen.main.bounds.height
        )
    )
    var mapController: KMController?
    var _observerAdded: Bool = false
    var _auth: Bool = false
    var _appear = true
    var locationManager = CLLocationManager()
    var modalViewController: FieldDetailViewController?
    
    private var buttonConfig: UIButton.Configuration {
        var config = UIButton.Configuration.plain()
        config.contentInsets = NSDirectionalEdgeInsets(
            top: 10,
            leading: 10,
            bottom: 10,
            trailing: 10
        )
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
        button.setTitleColor(AFColor.grayScale200, for: .highlighted)
        button.layer.cornerRadius = LayoutOptions.cornerRadious
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
        mapController?.pauseEngine()
        mapController?.resetEngine()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureMap()
        configureUI()
        setLocationManager()
        bindSearch()
        setUserLocation()
        fetchFieldData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        addObservers()
        _appear = true
        if mapController?.isEnginePrepared == false {
            mapController?.prepareEngine()
        }
        
        if mapController?.isEngineActive == false {
            mapController?.activateEngine()
        }
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
    
    func poiTappedHandler(_ param: PoiInteractionEventParam) {
        let itemID = param.poiItem.itemID
        viewModel.presentDetailViewController(itemID: itemID)
    }
    
    // MARK: - Helpers
    
    private func bindSearch() {
        guard let searchViewModel = searchViewModel else { return }
        updateSearchBar(
            dataSubject: searchViewModel.dataSubject,
            searchBarButton: searchFieldButton,
            disposeBag: disposeBag
        )
        searchViewModel.dataSubject
            .subscribe(onNext: { [weak self] place in
                guard let self else { return }
                moveCamera(
                    latitude: Double(place.y) ?? 127,
                    longitude: Double(place.x) ?? 38
                )
            })
            .disposed(by: disposeBag)
    }
    
    func setUserLocation() {
        guard
            let locationCoordinate = self.locationManager.location?.coordinate
        else {
            return
        }
        viewModel.setCurrentLocation(latitude: locationCoordinate.latitude,
                                     longitude: locationCoordinate.longitude)
    }
    
    private func fetchFieldData() {
        Task {
            do {
                try await viewModel.fetchFields { [weak self] fields in
                    _ = self?.loadFieldsData(
                        label: MapLabel(
                            labelType: .fieldPosition,
                            poi: .fieldPosition(fields.map{ $0.id })
                        ),
                        fields: fields
                    )
                }
            } catch {
                print("Error: \(error)")
            }
        }
    }
    
    private func configureUI() {
        view.backgroundColor = .systemBackground
        
        view.addSubviews(
            mapContainer,
            searchFieldButton,
            trackingButton
        )
        
        mapContainer.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(self.view.safeAreaLayoutGuide)
        }
        
        searchFieldButton.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.equalToSuperview().offset(SuperviewOffsets.leadingPadding)
            $0.trailing.equalToSuperview().offset(SuperviewOffsets.trailingPadding)
        }
        
        trackingButton.snp.makeConstraints {
            $0.leading.equalTo(mapContainer).offset(10)
            $0.bottom.equalTo(mapContainer).offset(-10)
            $0.height.width.equalTo(56)
        }
    }
}

extension MapViewController: Searchable { }
