//
//  CurationViewController.swift
//  SeoulSpot
//
//  Created by Kyuhee hong on 3/31/25.
//

import UIKit

protocol CurationViewControllerDelegate: AnyObject {
    func didSelectEvent(_ event: CulturalEventModel)
}

final class CurationViewController: BaseViewController<CurationView, CurationViewModel> {
    
    var delegate: CurationViewControllerDelegate?
 
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
    }
    
    override func bindViewModel() {
        viewModel.$isLoading
            .receive(on: RunLoop.main)
            .sink { [weak self] in self?.showLoading($0) }
            .store(in: &cancellables)
        
        viewModel.errorMessage
            .receive(on: RunLoop.main)
            .sink { [weak self] in self?.showError($0) }
            .store(in: &cancellables)
        
        viewModel.$mainItems
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                self?.curationView.mainCollectionView.reloadData()
            }
            .store(in: &cancellables)
        
        viewModel.$sub1Items
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                self?.curationView.sub1CollectionView.reloadData()
            }
            .store(in: &cancellables)

        viewModel.$sub2Items
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                self?.curationView.sub2CollectionView.reloadData()
            }
            .store(in: &cancellables)
        viewModel.$sub3Items
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                self?.curationView.sub3CollectionView.reloadData()
            }
            .store(in: &cancellables)    }
}

extension CurationViewController {
    private func setupNavigationView() {
        let logoImageView = UIImageView(image: UIImage(named: "logoname2"))
        logoImageView.contentMode = .scaleAspectFit

        let containerView = UIView()
        containerView.addSubview(logoImageView)

        logoImageView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.height.equalTo(32)
            $0.width.equalTo(120)
        }
        
        self.navigationItem.titleView = containerView
    }
}

extension CurationViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDataSourcePrefetching {

    private func setupCollectionView() {
        curationView.mainCollectionView.isPagingEnabled = true
        curationView.mainCollectionView.delegate = self
        curationView.mainCollectionView.dataSource = self
        curationView.mainCollectionView.register(LargeImageCollectionViewCell.self, forCellWithReuseIdentifier: LargeImageCollectionViewCell.identifier)

        curationView.sub1CollectionView.delegate = self
        curationView.sub1CollectionView.dataSource = self
        curationView.sub1CollectionView.register(SmallImageCollectionViewCell.self, forCellWithReuseIdentifier: SmallImageCollectionViewCell.identifier)

        curationView.sub2CollectionView.delegate = self
        curationView.sub2CollectionView.dataSource = self
        curationView.sub2CollectionView.register(SmallImageCollectionViewCell.self, forCellWithReuseIdentifier: SmallImageCollectionViewCell.identifier)

        curationView.sub3CollectionView.delegate = self
        curationView.sub3CollectionView.dataSource = self
        curationView.sub3CollectionView.register(SmallImageCollectionViewCell.self, forCellWithReuseIdentifier: SmallImageCollectionViewCell.identifier)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case curationView.mainCollectionView:
            return viewModel.mainItems.count
        case curationView.sub1CollectionView:
            return viewModel.sub1Items.count
        case curationView.sub2CollectionView:
            return viewModel.sub2Items.count
        case curationView.sub3CollectionView:
            return viewModel.sub3Items.count
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell: UICollectionViewCell
        let event: CulturalEventModel

        switch collectionView {
        case curationView.mainCollectionView:
            let mainCell = collectionView.dequeueReusableCell(withReuseIdentifier: LargeImageCollectionViewCell.identifier, for: indexPath) as! LargeImageCollectionViewCell
            event = viewModel.mainItems[indexPath.item]
            mainCell.configure(with: event)
            cell = mainCell

        case curationView.sub1CollectionView:
            let subCell = collectionView.dequeueReusableCell(withReuseIdentifier: SmallImageCollectionViewCell.identifier, for: indexPath) as! SmallImageCollectionViewCell
            event = viewModel.sub1Items[indexPath.item]
           subCell.configure(with: event)
            cell = subCell

        case curationView.sub2CollectionView:
            let subCell = collectionView.dequeueReusableCell(withReuseIdentifier: SmallImageCollectionViewCell.identifier, for: indexPath) as! SmallImageCollectionViewCell
            event = viewModel.sub2Items[indexPath.item]
           subCell.configure(with: event)
            cell = subCell

        case curationView.sub3CollectionView:
            let subCell = collectionView.dequeueReusableCell(withReuseIdentifier: SmallImageCollectionViewCell.identifier, for: indexPath) as! SmallImageCollectionViewCell
            event = viewModel.sub3Items[indexPath.item]
           subCell.configure(with: event)
            cell = subCell

        default:
            return UICollectionViewCell()
        }

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedEvent: CulturalEventModel

        switch collectionView {
        case curationView.mainCollectionView:
            selectedEvent = viewModel.mainItems[indexPath.item]
        case curationView.sub1CollectionView:
            selectedEvent = viewModel.sub1Items[indexPath.item]
        case curationView.sub2CollectionView:
            selectedEvent = viewModel.sub2Items[indexPath.item]
        case curationView.sub3CollectionView:
            selectedEvent = viewModel.sub3Items[indexPath.item]
        default:
            return
        }
        
        delegate?.didSelectEvent(selectedEvent)
    }
    
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        print(#function)
    }
}
