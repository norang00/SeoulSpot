//
//  CurationViewController.swift
//  SeoulSpot
//
//  Created by Kyuhee hong on 3/31/25.
//

import UIKit

protocol CurationViewControllerDelegate: AnyObject {
    func didSelectEvent(_ event: CulturalEvent)
}

final class CurationViewController: BaseViewController<CurationView, CurationViewModel> {
    
    var delegate: CurationViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        title = Resources.curation.title

        print(#function, delegate)

        setupCollectionView()
    }
    
    override func bindViewModel() {
        viewModel.$isLoading
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in self?.showLoading($0) }
            .store(in: &cancellables)
        
        viewModel.errorMessage
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in self?.showError($0) }
            .store(in: &cancellables)
        
        viewModel.$mainItems
            .receive(on: DispatchQueue.main) // [TODO] Runloop 이랑 뭐가 다른거지?
            .sink { [weak self] _ in
                self?.mainView.mainCollectionView.reloadData()
            }
            .store(in: &cancellables)
        
        viewModel.$subItems
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                self?.mainView.subCollectionView.reloadData()
            }
            .store(in: &cancellables)
    }
}

extension CurationViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDataSourcePrefetching {

    func setupCollectionView() {
        mainView.mainCollectionView.delegate = self
        mainView.mainCollectionView.dataSource = self
        mainView.mainCollectionView.register(MainCollectionViewCell.self, forCellWithReuseIdentifier: MainCollectionViewCell.identifier)

        mainView.subCollectionView.delegate = self
        mainView.subCollectionView.dataSource = self
        mainView.subCollectionView.register(SubCollectionViewCell.self, forCellWithReuseIdentifier: SubCollectionViewCell.identifier)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case mainView.mainCollectionView:
            return viewModel.mainItems.count
        case mainView.subCollectionView:
            return viewModel.subItems.count
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell: UICollectionViewCell
        let event: CulturalEvent

        switch collectionView {
        case mainView.mainCollectionView:
            let mainCell = collectionView.dequeueReusableCell(withReuseIdentifier: MainCollectionViewCell.identifier, for: indexPath) as! MainCollectionViewCell
            event = viewModel.mainItems[indexPath.item]
            mainCell.configure(with: event)
            cell = mainCell

        case mainView.subCollectionView:
            let subCell = collectionView.dequeueReusableCell(withReuseIdentifier: SubCollectionViewCell.identifier, for: indexPath) as! SubCollectionViewCell
            event = viewModel.subItems[indexPath.item]
           subCell.configure(with: event)
            cell = subCell
            
        default:
            return UICollectionViewCell()
        }

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedEvent: CulturalEvent

        switch collectionView {
        case mainView.mainCollectionView:
            selectedEvent = viewModel.mainItems[indexPath.item]
        case mainView.subCollectionView:
            selectedEvent = viewModel.subItems[indexPath.item]
        default:
            return
        }
        print(#function, selectedEvent.title, delegate)
        print("🔥 delegate 연결 상태:", delegate != nil)

        delegate?.didSelectEvent(selectedEvent)
    }
    
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        print(#function)
    }
}
