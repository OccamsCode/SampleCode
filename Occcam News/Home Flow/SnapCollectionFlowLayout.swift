//
//  SnapCollectionFlowLayout.swift
//  Occcam News
//
//  Created by Brian Munjoma on 10/03/2021.
//

import UIKit

class SnapCollectionFlowLayout: UICollectionViewFlowLayout {

    // MARK: - Properties

    private var firstSetupDone = false

    var spacingMultiplier: CGFloat = 6 {
        didSet {
            invalidateLayout()
        }
    }

    var minLineSpacing: CGFloat = 20 {
        didSet {
            minimumLineSpacing = minLineSpacing
            invalidateLayout()
        }
    }

    var itemHeight: CGFloat = 0 {
        didSet {
            recalculateItemSize(for: itemHeight)
        }
    }

    var horizontalOrientationDevider: CGFloat = 2 {
        didSet {
            recalculateItemSize(for: itemHeight)
            invalidateLayout()
        }
    }

    // MARK: - Overrides

    override func prepare() {
        super.prepare()

        if !firstSetupDone {
            setup()
            firstSetupDone = true
        }

        guard let unwrappedCollectionView = collectionView else {
            return
        }
        let height = unwrappedCollectionView.frame.height
        recalculateItemSize(for: height)
    }

    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint,
                                      withScrollingVelocity velocity: CGPoint) -> CGPoint {
        super.targetContentOffset(forProposedContentOffset: proposedContentOffset, withScrollingVelocity: velocity)

        guard let unwrappedCollectionView = collectionView else { fatalError("CollectionView not avaliable") }

        let layoutAttributes = layoutAttributesForElements(in: unwrappedCollectionView.bounds)

        var centerOffset: CGFloat
        var offsetWithCenter: CGFloat

        switch scrollDirection {
        case .horizontal:
            centerOffset = unwrappedCollectionView.bounds.size.width / 2
            offsetWithCenter = proposedContentOffset.x + centerOffset
        case .vertical:
            centerOffset = unwrappedCollectionView.bounds.size.height / 2
            offsetWithCenter = proposedContentOffset.y + centerOffset
        @unknown default:
            fatalError("Unsupported scroll direction. Please contact the developer to resolve this issue")
        }

        guard let unwrappedLayoutAttributes = layoutAttributes else {
            return super.targetContentOffset(forProposedContentOffset: proposedContentOffset,
                                             withScrollingVelocity: velocity)
        }

        var closestAttribute: UICollectionViewLayoutAttributes

        switch scrollDirection {
        case .horizontal:
            closestAttribute = unwrappedLayoutAttributes
                .sorted {
                    abs($0.center.x - offsetWithCenter) < abs($1.center.x - offsetWithCenter) }
                .first ?? UICollectionViewLayoutAttributes()
            return CGPoint(x: closestAttribute.center.x - centerOffset, y: 0)
        case .vertical:
            closestAttribute = unwrappedLayoutAttributes
                .sorted {
                    abs($0.center.y - offsetWithCenter) < abs($1.center.y - offsetWithCenter) }
                .first ?? UICollectionViewLayoutAttributes()
            return CGPoint(x: 0, y: closestAttribute.center.y - centerOffset)
        @unknown default:
            fatalError("Unsupported scroll direction. Please contact the developer to resolve this issue")
        }
    }

    // MARK: - Private helpers
    private func setup() {
        guard let unwrappedCollectionView = collectionView else {
            return
        }
        minimumLineSpacing = minLineSpacing
        itemSize = CGSize(width: unwrappedCollectionView.bounds.width, height: itemHeight)
        unwrappedCollectionView.decelerationRate = UIScrollView.DecelerationRate.fast
    }

    private func recalculateItemSize(for itemHeight: CGFloat) {
        guard let unwrappedCollectionView = collectionView else {
            return
        }
        let contentInset = unwrappedCollectionView.contentInset
        let horizontalContentInset = contentInset.left + contentInset.right
        let verticalContentInset = contentInset.bottom + contentInset.top

        var divider: CGFloat = 1.0

        if unwrappedCollectionView.bounds.width > unwrappedCollectionView.bounds.height {
            /* collection view bounds are in landscape so we change the item width
             in a way where 2 rows can be displayed */
            divider = horizontalOrientationDevider
        }

        itemSize = CGSize(width: unwrappedCollectionView.bounds.width / divider - horizontalContentInset,
                          height: itemHeight - (minLineSpacing * spacingMultiplier) - verticalContentInset)

        invalidateLayout()
    }
}
