//
//  SingleArticleViewModel.swift
//  newsapp
//
//  Created by Alexey Savchenko on 03.05.2018.
//  Copyright © 2018 Alexey Savchenko. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import RxDataSources

protocol SingleArticleViewModelType {
  // Outputs
  var sectionsDriver: Driver<[MultipleSectionModel]> { get }
  var errorsOccuredSubject: PublishSubject<String> { get }
  var dataSource: RxTableViewSectionedReloadDataSource<MultipleSectionModel> { get }
  // Inputs
  var tagSelectedSubject: PublishSubject<String> { get }
  var categorySelectedSubject: PublishSubject<NewsCategory> { get }
}

class SingleArticleViewModel: SingleArticleViewModelType {

  // MARK: Init and deinit
  init(articleID: Int,
       loadService: ContentLoaderService,
       contentBuilder: NewsContentBuider,
       delegate: TagAndCategorySelectionDelegate) {

    loadService
      .load(WebContent<Article?>(resource: NewsAPI.singleArticle(ID: articleID), parse: Article.init))
      .flatMap(transformArticleToSections)
      .subscribe(sectionsSubject)
      .disposed(by: disposeBag)

    sectionsSubject
      .subscribe(onNext: nil, onError: { [unowned self] (error) in
        let errorMessage = error.localizedDescription
        self.errorsOccuredSubject.onNext(errorMessage)
      }).disposed(by: disposeBag)

  }

  deinit {
    print("\(self) dealloc")
  }

  // MARK: Properties
  private let tagSelectionSubject = PublishSubject<String>()
  private let disposeBag = DisposeBag()
  var tagSelectedSubject = PublishSubject<String>()
  var categorySelectedSubject = PublishSubject<NewsCategory>()
  var errorsOccuredSubject = PublishSubject<String>()
  private var sectionsSubject = PublishSubject<[MultipleSectionModel]>()
  var sectionsDriver: Driver<[MultipleSectionModel]> {
    return sectionsSubject.asDriver(onErrorJustReturn: [])
  }
  var dataSource: RxTableViewSectionedReloadDataSource<MultipleSectionModel> {
    return RxTableViewSectionedReloadDataSource<MultipleSectionModel>(configureCell: { (dataSource, tableView, indexPath, _) in
      switch dataSource[indexPath] {

      case .headerImageSectionItem(let imgURL, let copyright):
        let cell = tableView.dequeueReusableCell(withIdentifier: "ArticleHeaderCell") as! ArticleHeaderCell
        cell.headerImage.sd_setImage(with: imgURL, completed: { (image, _, _, _) in
          cell.headerImage.image = UIImage.imageWithGradient(img: image ?? UIImage())
        })
        cell.copyrightLabel.text = copyright
        return cell

      case .titleSectionItem(let title, let timestamp, let category):

        let cell = tableView.dequeueReusableCell(withIdentifier: "ArticleTitleCell") as! ArticleTitleCell
        cell.titlelabel.text = title
        cell.TimestampLabel.text = timestamp
        cell.categoriesLabel.text = category
        return cell

      case .mediaSectionItem(let media):

        switch media.type {

        case .description:
          let cell = tableView.dequeueReusableCell(withIdentifier: "ArticleDescriptionCell") as! ArticleDescriptionCell
          cell.descriptionText.text = (media as! DescriptionMedia).content
          return cell

        case .text:
          let cell = tableView.dequeueReusableCell(withIdentifier: "ArticleParagraphCell") as! ArticleParagraphCell
          cell.textParapraph.text = "    \((media as! TextMedia).content)"
          return cell

        case .image:
          let cell = tableView.dequeueReusableCell(withIdentifier: "ArticleImageCell") as! ArticleImageCell
          cell.contentImage.sd_setImage(with: URL(string: (media as! ImageMedia).content)!, completed: nil)
          return cell

        case .quote:
          let cell = tableView.dequeueReusableCell(withIdentifier: "ArticleQuoteCell") as! ArticleQuoteCell
          cell.quoteText.text = "    \((media as! QuoteMedia).content)"
          return cell

        case .video:
          let cell = tableView.dequeueReusableCell(withIdentifier: "ArticleVideoCell") as! ArticleVideoCell
          let videoURL = URL(string: (media as! VideoMedia).content)!
          cell.videoURL = videoURL
          return cell

        case .twitter:
          let cell = tableView.dequeueReusableCell(withIdentifier: "SocialMediaCell") as! SocialMediaCell
          let socialURL = URL(string: (media as! TwitterMedia).content)!
          cell.socialURL = socialURL
          return cell

        case .facebook:

          let cell = tableView.dequeueReusableCell(withIdentifier: "SocialMediaCell") as! SocialMediaCell
          let socialURL = URL(string: (media as! FacebookMedia).content)!
          cell.socialURL = socialURL
          return cell

        case .instagram:
          let cell = tableView.dequeueReusableCell(withIdentifier: "SocialMediaCell") as! SocialMediaCell
          let socialURL = URL(string: (media as! InstagramMedia).content)!
          cell.socialURL = socialURL
          return cell

        case .category:
          return UITableViewCell()
        }

      case .tagsSectionItem(let tags):
        let cell = tableView.dequeueReusableCell(withIdentifier: "ArticleTagsCell") as! ArticleTagsCell
        cell.tags = tags
        cell.collectionView.rx.modelSelected(String.self)
          .subscribe(self.tagSelectedSubject)
          .disposed(by: self.disposeBag)
        return cell
      }
    })
  }

  // MARK: Functions
  private func transformArticleToSections(_ article: Article?) -> Observable<[MultipleSectionModel]> {
    return Observable<[MultipleSectionModel]>.create { observer in

      guard let article = article else {
        observer.onError(CustomError(value: "Corrupted data"))
        return Disposables.create()
      }

      var sectionsArray = [MultipleSectionModel]()

      sectionsArray.append(.headerImageSection(item: .headerImageSectionItem(imgURL: article.coverImageURL,
                                                                             copyright: article.copyrightImage)))

      sectionsArray.append(.titleSection(item: .titleSectionItem(title: article.title,
                                                                 timestamp: article.timestamp,
                                                                 category: article.categories.first?.name ?? "")))

      sectionsArray.append(.mediaSection(items: article.mediaArray.map(SectionItem.mediaSectionItem)))

      sectionsArray.append(.tagsSection(tags: .tagsSectionItem(tags: article.tagArray)))

      return Disposables.create()
    }
  }
}
