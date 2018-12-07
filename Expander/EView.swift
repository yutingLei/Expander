//
//  ExpanderView.swift
//  Expander
//
//  Created by yutingLei on 2018/11/27.
//  Copyright © 2018 Develop. All rights reserved.
//

import UIKit

/// In this framework, all the name of class has a prefix character 'E' which means 'Expander'.
/// Statement private vars must start with character '_'.
public class EView: UIView {

    // MARK: Private vars
    /// The EView's parent view.
    internal weak var _parentView: UIView!

    /// Save current config
    internal var _config: EViewConfig = EViewConfig()

    /// The original frame
    internal var _originalFrame: CGRect!

    /// The expanded frame
    internal var _expandedFrame: CGRect!

    /// The current state
    internal var _isExpanded = false


    // MARK: Public vars
    /// The view's configuration
    /// Don't set it directly, replace with the function of `EView.applyConfig(_:)`
    public private(set) var config: EViewConfig! {
        get { return _config }
        set { updateConfig(with: newValue) }
    }

    /// The button who control the action of EView
    public private(set) var controlButton: UIButton!

    /// The content's view
    public private(set) lazy var contentView: UIView = {
        bringSubviewToFront(controlButton!)

        let view = UIView(frame: CGRect(x: 4, y: 30, width: _expandedFrame.width - 8, height: _expandedFrame.height - 34))
        view.backgroundColor = .white
        view.alpha = 0
        addSubview(view)
        return view
    }()

    deinit {
        EViewDataHolder.datas = nil
        EViewDataHolder.config = nil
        EViewDataHolder.collectionView = nil
        EViewDataHolder.cellSelectHandler = nil
        EViewDataHolder.multipleCellSelected = nil
    }
}

/// Some functions that can be invoked
//MARK: - Public functions
public extension EView {

    /// Init an instance of EView by class
    ///
    /// - Parameter parentView: EView's parent view
    public class func serialization(in parentView: UIView) -> EView {

        /// Init and save parent view
        let eView = EView()
        eView.clipsToBounds = true
        eView.backgroundColor = UIColor.rgb(0, 191, 255)

        /// Save parent view
        eView._parentView = parentView

        /// Initialize a button to control expansion and folding
        eView.controlButton = UIButton()
        eView.controlButton.addTarget(eView, action: #selector(controlAction), for: .touchUpInside)
        eView.addSubview(eView.controlButton)

        /// Use default config and layout
        eView.config = EViewConfig()

        return eView
    }

    /// Apply new configuration
    ///
    /// - Parameter newConfig: the EView's config
    public func applyConfig(_ newConfig: EViewConfig) {
        self.config = newConfig
    }

    /// Expand EView
    public func expand(to rect: CGRect? = nil) {
        UIView.animate(withDuration: 0.35, animations: {[unowned self] in
            self.layer.cornerRadius = self._config.expandCornerRadius!
            self.frame = rect ?? self._expandedFrame
            self.contentView.alpha = 1
            self.controlButton.isSelected = true
            self.controlButton!.frame.size = CGSize(width: 80, height: 30)
        }) {[unowned self] _ in
            self._isExpanded = true
            EViewDataHolder.completionButton?.isHidden = !self.hasSelected(in: EViewDataHolder.multipleCellSelected!)
        }
    }

    /// Fold EView
    public func fold(to rect: CGRect? = nil) {
        EViewDataHolder.completionButton?.isHidden = true
        UIView.animate(withDuration: 0.35, animations: {
            self.layer.cornerRadius = min(self._originalFrame.width, self._originalFrame.height) / 2
            self.frame = rect ?? self._originalFrame
            self.contentView.alpha = 0
            self.controlButton.isSelected = false
            self.controlButton!.frame.size = (rect ?? self._originalFrame).size
        }) {[unowned self] _ in
            self._isExpanded = false
        }
    }


    /// Show datas
    ///
    /// - Parameters:
    ///   - datas: Datas array
    ///   - config: The collection view and cells configuration
    public func showDatas(_ datas: [[String: Any]], with config: EViewCellConfig, whileCellSelect cellSelectHandler: EViewCellSelectHandler? = nil) {

        guard datas.count != 0 else {
            print("The count of datas equal 0.")
            return
        }

        guard config.valueByKeys.count >= 2 else {
            print("The valueByKeys must contain two keys.")
            return
        }

        /// Save datas
        EViewDataHolder.datas = datas
        EViewDataHolder.config = config
        EViewDataHolder.cellSelectHandler = cellSelectHandler

        /// Single or multiple select
        EViewDataHolder.multipleCellSelected = [Bool](repeating: false, count: datas.count)

        /// Init layout
        var layout = config.layout
        if layout == nil {
            layout = UICollectionViewFlowLayout()
            layout?.itemSize = CGSize(width: contentView.bounds.height, height: contentView.bounds.height)
            layout?.scrollDirection = .horizontal
            layout?.minimumLineSpacing = 4
            layout?.minimumInteritemSpacing = 4
            EViewDataHolder.collectionView?.collectionViewLayout = layout!
        }

        /// Init collectionView
        if EViewDataHolder.collectionView == nil {

            EViewDataHolder.collectionView = UICollectionView(frame: contentView.bounds, collectionViewLayout: layout!)
            EViewDataHolder.collectionView?.backgroundColor = UIColor.rgb(245, 245, 245)
            EViewDataHolder.collectionView?.dataSource = self
            EViewDataHolder.collectionView?.delegate = self
            contentView.addSubview(EViewDataHolder.collectionView!)

            /// Register cell
            EViewDataHolder.collectionView?.register(EViewCell.self, forCellWithReuseIdentifier: "com.expander.cell")
        }

        /// Init a button to control selected datas
        if config.isMultiSelect && EViewDataHolder.completionButton == nil {
            let button = UIButton()
            button.isHidden = true
            button.setTitle(config.sureTitle!, for: .normal)
            button.setTitleColor(.white, for: .normal)
            button.addTarget(self, action: #selector(sureAction), for: .touchUpInside)
            EViewDataHolder.completionButton = button
            addSubview(button)

            button.layer.cornerRadius = 5
            button.backgroundColor = UIColor.rgb(76, 165, 75)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 15)
            button.translatesAutoresizingMaskIntoConstraints = false

            addConstraint(NSLayoutConstraint(item: self, attribute: .trailing, relatedBy: .equal, toItem: button, attribute: .trailing, multiplier: 1, constant: 8))
            addConstraint(NSLayoutConstraint(item: button, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 2))
            addConstraint(NSLayoutConstraint(item: button, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 26))
            addConstraint(NSLayoutConstraint(item: button, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: config.sureTitle!.width(26) + 10))
        }

        /// Reload data
        EViewDataHolder.collectionView?.reloadData()
    }
}

//MARK: - Private functions
fileprivate extension EView {

    /// Apply new config.
    func updateConfig(with newValue: EViewConfig) {

        /// Apply new values
        _config.expandType = newValue.expandType ?? .center
        _config.located = newValue.located ?? .left
        _config.stateFlag = newValue.stateFlag ?? ("Expand", "Fold")
        _config.expandCornerRadius = newValue.expandCornerRadius ?? 10

        _config.size = newValue.size ?? CGSize(width: 80, height: 80)
        _config.expandSize = newValue.expandSize ?? CGSize(width: _parentView.bounds.width - 16, height: 120)

        if _config.size! > _config.expandSize! {
            print("Expanded size less than origianl size. Use default configuration.")
        }

        _config.padding = newValue.padding ?? EViewPadding(8)
        _config.distanceToTop = newValue.distanceToTop ?? (_parentView.bounds.height - 80) / 2

        /// set EView's size
        frame.size = _config.size!

        /// calculate EView's origin
        let ox = _config.located == .left ? _config.padding!.left : _parentView.bounds.width - frame.width - _config.padding!.right
        let oy = _config.distanceToTop!
        frame.origin = CGPoint(x: ox, y: oy)
        _originalFrame = frame

        /// calculate EView's expanded frame
        let paddingl = _config.padding!.left
        let paddingr = _config.padding!.right
        let ew = _config.expandSize!.width
        let eh = _config.expandSize!.height
        let ex = _config.located == .left ? paddingl : _parentView.bounds.width - ew - paddingr
        var ey: CGFloat = 0
        switch _config.expandType! {
        case .up:
            ey = frame.maxY - eh
            if ey < _config.padding!.top {
                ey = _config.padding!.top
            }
        case .down:
            ey = frame.minY
            if ey + eh > _parentView.frame.height - _config.padding!.bottom {
                ey = _parentView.frame.height - _config.padding!.bottom - eh
            }
        default:
            ey = frame.midY - eh / 2
            if ey <= 0 {
                ey = _config.padding!.top
            }
            if ey > _parentView.bounds.height {
                ey = _parentView.bounds.height - _config.expandSize!.height
            }
        }
        _expandedFrame = CGRect(x: ex, y: ey, width: ew, height: eh)

        /// Set corner radius
        layer.cornerRadius = min(_config.size!.width, _config.size!.height) / 2

        /// Update control button
        updateControlButton()
    }

    /// Update control button
    func updateControlButton() {

        /// Update frame
        controlButton.frame = CGRect(origin: CGPoint.zero, size: _config.size!)

        /// Set control button
        let expandFlag = _config.stateFlag!.0
        if let text = expandFlag as? String {
            controlButton.setTitle(text, for: .normal)
        } else if let image = expandFlag as? UIImage {
            controlButton.setImage(image, for: .normal)
        }

        let foldFlag = _config.stateFlag!.1
        if let text = foldFlag as? String {
            controlButton.setTitle(text, for: .selected)
        } else if let image = foldFlag as? UIImage {
            controlButton.setImage(image, for: .selected)
        }
    }

    /// Touch action
    @objc func controlAction() {
        _isExpanded ? fold() : expand()
    }

    /// Click `Sure` button
    @objc private func sureAction() {
        guard let handler = EViewDataHolder.config?.multiSelectedHandler else { return }
        var selectedIndexes = [Int]()
        for idx in 0..<EViewDataHolder.multipleCellSelected!.count {
            if EViewDataHolder.multipleCellSelected![idx] {
                selectedIndexes += [idx]
            }
        }
        handler(selectedIndexes)
    }

    /// Whether has selected
    func hasSelected(in arr: [Bool]) -> Bool {
        var hasSelected = false
        for value in arr {
            if value { hasSelected = true }
        }
        return hasSelected
    }
}

//MARK: About Cell
extension EView: UICollectionViewDataSource, UICollectionViewDelegate {

    /// Typealise
    public typealias EViewCellSelectHandler = (Int) -> Void

    /// Hold some vars
    struct EViewDataHolder {
        static var datas: [[String: Any]]?
        static var config: EViewCellConfig?
        static var collectionView: UICollectionView?
        static var cellSelectHandler: EViewCellSelectHandler?
        static var multipleCellSelected: [Bool]?
        static var completionButton: UIButton?
    }

    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return EViewDataHolder.datas?.count ?? 0
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "com.expander.cell", for: indexPath) as! EViewCell
        let cellConfig = EViewDataHolder.config
        let cellMode = cellConfig!.mode

        /// Data
        let data = EViewDataHolder.datas![indexPath.row]
        let keys = EViewDataHolder.config!.valueByKeys!

        /// Title label
        if cell.titleLabel.frame == CGRect.zero {
            let y = cellMode == .`default` ? 0 : cell.contentView.bounds.height - 20
            cell.titleLabel.frame.origin.y = y
        }
        cell.titleLabel.text = data[keys[0]] as? String

        /// Image view
        if cell.imageView.frame == CGRect.zero {
            cell.imageView.frame.origin.y = cellMode == .`default` ? 24 : 4
        }
        cell.imageView.image = EHelp.generateImage(by: data[keys[1]])

        /// Single or multiple select
        if cellConfig!.isMultiSelect {
            cell.selectedView.superview?.isHidden = !EViewDataHolder.multipleCellSelected![indexPath.row]
            cell.selectedView.image = cellConfig?.selectedImage
        } else {
            if let selectedColor = cellConfig?.selectedBackgroundColor {
                let isSelected = EViewDataHolder.multipleCellSelected![indexPath.row]
                cell.contentView.backgroundColor = isSelected ? selectedColor : cellConfig?.backgroundColor
            }
        }
        return cell
    }

    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        /// is Single select
        if !EViewDataHolder.config!.isMultiSelect {
            /// Handle select
            if let handler = EViewDataHolder.cellSelectHandler {
                handler(indexPath.row)
            }

            guard let _ = EViewDataHolder.config?.selectedBackgroundColor else { return }
            EViewDataHolder.multipleCellSelected = [Bool](repeating: false, count: EViewDataHolder.datas!.count)
            EViewDataHolder.multipleCellSelected?[indexPath.row] = true
        } else {
            /// is multiple selecte
            let isSelected = EViewDataHolder.multipleCellSelected![indexPath.row]
            EViewDataHolder.multipleCellSelected?[indexPath.row] = !isSelected

            /// Whether show completion button
            EViewDataHolder.completionButton?.isHidden = !hasSelected(in: EViewDataHolder.multipleCellSelected!)
        }
        collectionView.reloadData()
    }
}

/// Custom cell
fileprivate class EViewCell: UICollectionViewCell {

    /// Title label
    lazy var titleLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: frame.width, height: 20))
        label.textColor = UIColor.rgb(45, 45, 45)
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 14)
        contentView.addSubview(label)
        return label
    }()

    /// Image
    lazy var imageView: UIImageView = {
        let imageView = UIImageView(frame: CGRect(x: 4, y: 20, width: frame.width - 8, height: frame.height - 24))
        imageView.contentMode = .scaleAspectFit
        contentView.addSubview(imageView)
        return imageView
    }()

    /// Selected image. support only multiple selecte
    lazy var selectedView: UIImageView = {
        let selectedView = UIView(frame: bounds)
        selectedView.backgroundColor = UIColor.white.withAlphaComponent(0.85)
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: bounds.width / 2, height: bounds.height / 2))
        imageView.center = selectedView.center
        imageView.contentMode = .scaleAspectFit
        selectedView.addSubview(imageView)
        contentView.addSubview(selectedView)
        bringSubviewToFront(selectedView)
        return imageView
    }()

    /// Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .white
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
