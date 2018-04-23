//
//  ElementViewController.swift
//  IOSMarvel
//
//  Created by mai.thi.giang on 4/10/18.
//  Copyright © 2018 mai.thi.giang. All rights reserved.
//

import UIKit

protocol ElementVCDelegate: NSObjectProtocol {
    func scrollUp()
    func scrollDown()
}

enum ElementType: Int {
    case comic = 0, event, seri, story
}

class ElementViewController: BaseViewController, AlertViewController {

    @IBOutlet weak var elementCollectionView: UICollectionView!
    @IBOutlet weak var noDataLabel: UILabel!
    weak var delegate: ElementVCDelegate?
    var pointTapScroll: CGFloat = 0.0
    var comicList = [Element]()
    var eventList = [Element]()
    var seritList = [Element]()
    var storyList = [Element]()
    var characterID: Int?
    var elementType = ElementType(rawValue: 0)
    var page = 0
    var isLoadMore = false
    var isLoading = false
    private let elementRepository: ElementRepository = ElementImplement(api: APIService.share)

    override func viewDidLoad() {
        super.viewDidLoad()
        self.getListElementOfCharacter(elementType: self.elementType?.rawValue ?? 0)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func initUI() {
        elementCollectionView.register(UINib(nibName: characterCollectionViewCell, bundle: nil),
                 forCellWithReuseIdentifier: characterCollectionViewCell)
        noDataLabel.isHidden = true
    }

    func checkEmptyList(elements: [Element]) {
        self.noDataLabel.isHidden = !elements.isEmpty
    }

    func getListEachElement(elementResponse: ElementResponse, elements: [Element]) -> [Element] {
        if let elementArr = (elementResponse.data?.elements) {
            self.isLoadMore = elementArr.count < limit ? false : true
            self.checkEmptyList(elements: elementArr)
            return elementArr
        }
        return [Element]()
    }

    func getListElementOfCharacter(elementType: Int) {
        if let characterID = self.characterID {
            self.page = 0
            self.showLoadingOnParent()
            elementRepository.getListElement(characterID: characterID,
                                             page: self.page, elementType: elementType, completion: { (result) in
                switch result {
                case .success(let elementResponse):
                    if let elementResponse = elementResponse {
                        switch elementType {
                        case ElementType.comic.rawValue:
                            self.comicList = self.getListEachElement(elementResponse: elementResponse,
                                                                     elements: self.comicList)
                        case ElementType.event.rawValue:
                            self.eventList = self.getListEachElement(elementResponse: elementResponse,
                                                                     elements: self.eventList)
                        case ElementType.seri.rawValue:
                            self.seritList = self.getListEachElement(elementResponse: elementResponse,
                                                                     elements: self.seritList)
                        case ElementType.story.rawValue:
                            self.storyList = self.getListEachElement(elementResponse: elementResponse,
                                                                     elements: self.storyList)
                        default :
                            self.comicList = self.getListEachElement(elementResponse: elementResponse,
                                                                     elements: self.comicList)
                        }
                        self.elementCollectionView.reloadData()
                        self.page += 1
                    }
                    self.hideLoading()
                case .failure(let error):
                    self.showErrorAlert(message: error?.errorMessage)
                    self.hideLoading()
                }
            })
        }
    }

    func loadMoreEachElement(elementResponse: ElementResponse, elements: [Element]) -> [Element] {
        if let elementArr = (elementResponse.data?.elements) {
            var elementList = elements
            let count = elementList.count
            elementList.append(contentsOf: elementArr)
            self.isLoadMore = count < elementList.count ? true : false
            return elementList
        }
        return [Element]()
    }

    func loadMoreElementsOfCharacter(elementType: Int) {
        if isLoading {
            return
        }
        if let characterID = self.characterID {
            self.showLoadingOnParent()
            elementRepository.getListElement(characterID: characterID,
                                             page: self.page, elementType: elementType) { (result) in
                switch result {
                case .success(let elementResponse):
                    if let elementResponse = elementResponse {
                        switch elementType {
                        case ElementType.comic.rawValue:
                            self.comicList = self.loadMoreEachElement(elementResponse: elementResponse,
                                                                      elements: self.comicList)
                        case ElementType.event.rawValue:
                            self.eventList = self.loadMoreEachElement(elementResponse: elementResponse,
                                                                      elements: self.eventList)
                        case ElementType.seri.rawValue:
                            self.seritList = self.loadMoreEachElement(elementResponse: elementResponse,
                                                                      elements: self.seritList)
                        case ElementType.story.rawValue:
                            self.storyList = self.loadMoreEachElement(elementResponse: elementResponse,
                                                                      elements: self.storyList)
                        default :
                            self.comicList = self.loadMoreEachElement(elementResponse: elementResponse,
                                                                      elements: self.comicList)
                        }
                        self.page += 1
                        self.elementCollectionView.reloadData()
                        self.isLoading = false
                    }
                    self.hideLoading()
                case .failure(let error):
                    self.showErrorAlert(message: error?.errorMessage)
                    self.hideLoading()
                }
            }
        }
    }

    func loadMoreComics(indexPath: IndexPath) {
        if (indexPath.row == self.comicList.count - 1) && isLoadMore {
            if !isLoading {
                self.loadMoreElementsOfCharacter(elementType: ElementType.comic.rawValue)
                isLoading = true
            }
        }
    }

    func loadMoreEvents(indexPath: IndexPath) {
        if (indexPath.row == self.eventList.count - 1) && isLoadMore {
            if !isLoading {
                self.loadMoreElementsOfCharacter(elementType: ElementType.event.rawValue)
                isLoading = true
            }
        }
    }

    func loadMoreSeries(indexPath: IndexPath) {
        if (indexPath.row == self.seritList.count - 1) && isLoadMore {
            if !isLoading {
                self.loadMoreElementsOfCharacter(elementType: ElementType.seri.rawValue)
                isLoading = true
            }
        }
    }

    func loadMoreStories(indexPath: IndexPath) {
        if (indexPath.row == self.storyList.count - 1) && isLoadMore {
            if !isLoading {
                self.loadMoreElementsOfCharacter(elementType: ElementType.story.rawValue)
                isLoading = true
            }
        }
    }
}

// MARK: UICollectionView
extension ElementViewController: UICollectionViewDelegate {

}

extension ElementViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch self.elementType?.rawValue {
        case ElementType.comic.rawValue?:
            return comicList.count
        case ElementType.event.rawValue?:
            return eventList.count
        case ElementType.seri.rawValue?:
            return seritList.count
        case ElementType.story.rawValue?:
            return storyList.count
        default:
            return comicList.count
        }
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: characterCollectionViewCell,
                                                            for: indexPath) as? CharacterCollectionViewCell else {
                                                                return UICollectionViewCell()
        }
        switch self.elementType?.rawValue {
        case ElementType.comic.rawValue?:
            cell.setContentForCell(element: comicList[indexPath.row])
            self.loadMoreComics(indexPath: indexPath)
        case ElementType.event.rawValue?:
            cell.setContentForCell(element: eventList[indexPath.row])
            self.loadMoreEvents(indexPath: indexPath)
        case ElementType.seri.rawValue?:
            cell.setContentForCell(element: seritList[indexPath.row])
            self.loadMoreSeries(indexPath: indexPath)
        case ElementType.story.rawValue?:
            cell.setContentForCell(element: storyList[indexPath.row])
            self.loadMoreStories(indexPath: indexPath)
        default:
            cell.setContentForCell(element: comicList[indexPath.row])
            self.loadMoreComics(indexPath: indexPath)
        }
        return cell
    }
}

// MARK: UICollectionViewFlowLayout
extension ElementViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        var cellItemSize = collectionView.frame.size
        cellItemSize.width = screenWidth / 2 - 10
        cellItemSize.height = screenWidth / 2 - 10
        return cellItemSize
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: CGFloat(edgeGrid), left: CGFloat(edgeGrid),
                            bottom: CGFloat(edgeGrid), right: CGFloat(edgeGrid))
    }
}

extension ElementViewController: UIScrollViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        pointTapScroll = scrollView.contentOffset.y
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y > pointTapScroll { // scroll up
            self.delegate?.scrollUp()
        } else { // scroll down
            self.delegate?.scrollDown()
        }
    }
}
