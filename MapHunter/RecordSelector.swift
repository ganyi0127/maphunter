//
//  RecordSeletor.swift
//  MapHunter
//
//  Created by ganyi on 2017/5/17.
//  Copyright © 2017年 ganyi. All rights reserved.
//

import Foundation
class RecordSelector: UIView {
    
    //体重整数位
    fileprivate var weightDataList: [Int]{
        var list = [Int]()
        var udWeight = userDefaults.integer(forKey: "weight")
        if udWeight == 0{
            udWeight = 65
        }
        ((udWeight / 3)..<(udWeight * 3)).forEach{
            i in
            list.append(i)
        }
        return list
    }
    
    //体重小数位
    fileprivate var weightDotDataList: [Int]{
        var list = [Int]()
        (0..<10).forEach{
            i in
            list.append(i)
        }
        return list
    }
    
    //体重单位
    fileprivate var weightUnitDataList = ["千克", "磅"]
    
    fileprivate var type: RecordSubType!
    
    private var datePickerView: UIDatePicker?
    private var pickerView: UIPickerView?
    
    var closure: ((_ type: RecordSubType, _ value: Any?)->())?     //返回是否合法
    
    
    //当前选择的运动类型
    static fileprivate var selectedSportType: SportType?
    
    //MARK:- init **********************************************************************
    init(type: RecordSubType, frame: CGRect){
        super.init(frame: frame)
        
        self.type = type
        
        config()
        createContents()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func config(){
        isUserInteractionEnabled = true
    }
    
    //MARK:- 选择活动类型
    private var collectionView: UICollectionView?
    fileprivate var pageControl: UIPageControl?
    fileprivate var collectionCount: Int = {
        return sportTypeNameMap.count - 7  //除去新添加的心率血压等非运动类型
    }()
    fileprivate var pageCount: Int = {
        let count = sportTypeNameMap.count - 7  //除去新添加的心率血压等非运动类型
        var pages = count / 9
        if count % 9 != 0{
            pages += 1
        }
        return pages
    }()
    
    //MARK:- 选择活动强度
    fileprivate var levelImageView: UIImageView?
    fileprivate var levelMask: UIView?
    private func createContents(){
        switch type as RecordSubType {
        case .weightValue, .weightFat, .diastolicPressure, .systolicPressure, .heartrateActivityType, .heartrateValue:
            pickerView = UIPickerView(frame: frame)
            pickerView?.delegate = self
            pickerView?.dataSource = self
            addSubview(pickerView!)
        case .sportActivityType:
            //自定义选择器
            let pageContolHeight: CGFloat = 20
            if collectionView == nil{
                let layout = UICollectionViewFlowLayout()
                layout.minimumLineSpacing = 4
                layout.minimumLineSpacing = 4
                layout.scrollDirection = .horizontal        //横向移动
                
                let collectionFrame = CGRect(x: frame.origin.x, y: frame.origin.y, width: frame.width, height: frame.height - pageContolHeight)
                collectionView = UICollectionView(frame: collectionFrame, collectionViewLayout: layout)
                collectionView?.allowsMultipleSelection = false
                collectionView?.delegate = self
                collectionView?.dataSource = self
                collectionView?.register(RecordCollectionCell.self, forCellWithReuseIdentifier: "custom")
                collectionView?.isPagingEnabled = true
                collectionView?.showsVerticalScrollIndicator = false
                collectionView?.showsHorizontalScrollIndicator = false
                collectionView?.backgroundColor = .white
                collectionView?.allowsSelection = true
                addSubview(collectionView!)
            }
            
            if pageControl == nil{
                let pageControlFrame = CGRect(x: 0, y: frame.height - pageContolHeight, width: frame.width, height: pageContolHeight)
                pageControl = UIPageControl(frame: pageControlFrame)
                pageControl?.currentPage = 0
                pageControl?.numberOfPages = pageCount
                pageControl?.currentPageIndicatorTintColor = .gray
                pageControl?.pageIndicatorTintColor = separatorColor
                addSubview(pageControl!)
            }
        case .sportLevel:
            //自定义选择器
            let backImageView = UIImageView(frame: frame)
            backImageView.backgroundColor = .white
            backImageView.tintColor = separatorColor
            addSubview(backImageView)
            
            
            if levelImageView == nil{
                levelImageView = UIImageView(frame: frame)
                levelImageView?.isUserInteractionEnabled = true
                levelImageView?.backgroundColor = .white
                levelImageView?.tintColor = defaut_color
                addSubview(levelImageView!)
                
                //添加蒙版
                drawSportLevel(withProgressValue: 0.5)
            }
            //设置为强度背景
            if let sportType = RecordSelector.selectedSportType{
                if let name = sportTypeNameMap[sportType]{
                    let length: CGFloat = min(levelImageView!.bounds.width, levelImageView!.bounds.height) * 0.8
                    levelImageView?.image = UIImage(named: "resource/sporticons/bigicon/" + name)?.transfromImage(size: CGSize(width: length, height: length))?.withRenderingMode(.alwaysTemplate)
                    backImageView.image = UIImage(named: "resource/sporticons/bigicon/" + name)?.transfromImage(size: CGSize(width: length, height: length))?.withRenderingMode(.alwaysTemplate)
                }
            }
        case .sportStartDate:
            datePickerView = UIDatePicker(frame: frame)
            datePickerView?.datePickerMode = .dateAndTime
            datePickerView?.addTarget(self, action: #selector(selectDate(sender:)), for: .valueChanged)
            datePickerView?.maximumDate = Date()
            datePickerView?.minimumDate = Date(timeIntervalSinceNow: -2 * 60 * 60 * 24)     //两天前
            addSubview(datePickerView!)
        case .sleepDate, .wakeDate, .weightDate, .pressureDate, .heartrateDate:
            datePickerView = UIDatePicker(frame: frame)
            datePickerView?.datePickerMode = .dateAndTime
            datePickerView?.addTarget(self, action: #selector(selectDate(sender:)), for: .valueChanged)
            datePickerView?.maximumDate = Date()
            datePickerView?.minimumDate = Date(timeIntervalSinceNow: -1 * 60 * 60 * 24)     //1天前
            addSubview(datePickerView!)
        case .sportDuration:
            datePickerView = UIDatePicker(frame: frame)
            datePickerView?.datePickerMode = .countDownTimer
            datePickerView?.addTarget(self, action: #selector(selectDate(sender:)), for: .valueChanged)
            datePickerView?.maximumDate = Date()
            datePickerView?.minimumDate = Date(timeIntervalSinceNow: -1 * 60 * 60 * 24)     //24小时
            addSubview(datePickerView!)
        default:
            break
        }
    }
    
    //MARK:- 日期选择器回调
    @objc private func selectDate(sender: UIDatePicker){
        switch type as RecordSubType {
        case .sportDuration:
            closure?(type, sender.countDownDuration)
        default:
            closure?(type, sender.date)
        }
    }
    
    //MARK:- 活动强度绘制 0~1
    private var levelMaskView: UIView?
    fileprivate var sportLevel: Int?    //0..<5
    fileprivate func drawSportLevel(withProgressValue progressValue: CGFloat){
        
        //绘制
        if levelMaskView == nil {
            levelMaskView = UIView(frame: levelImageView!.frame)
            levelMaskView?.backgroundColor = .white
            addSubview(levelMaskView!)
            levelImageView?.mask = levelMaskView
        }
        
        var value = progressValue
        if value > 1{
            value = 1
        }else if value < 0{
            value = 0
        }
        
        if value >= 0 && value < 0.15{
            sportLevel = 0
        }else if value >= 0.15 && value < 0.45{
            sportLevel = 1
        }else if value >= 0.45 && value < 0.75{
            sportLevel = 2
        }else if value >= 0.75 && value < 1{
            sportLevel = 3
        }else{
            sportLevel = 4
        }
        
        //动画
        let moveAnim = CABasicAnimation(keyPath: "position.y")
        moveAnim.toValue = levelImageView!.bounds.height * (1 - value) + levelImageView!.bounds.height / 2
        moveAnim.duration = 1.5
        moveAnim.fillMode = kCAFillModeBoth
        moveAnim.isRemovedOnCompletion = false
        levelMaskView?.layer.add(moveAnim, forKey: nil)
    }
}

//MARK:- 触摸事件
extension RecordSelector{
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if type == RecordSubType.sportLevel, let touch = touches.first, let imageView = levelImageView {
            let curLocation = touch.location(in: imageView)
            let currentProgressValue = (imageView.bounds.height - curLocation.y) / imageView.bounds.height
            drawSportLevel(withProgressValue: currentProgressValue)
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if type == RecordSubType.sportLevel, let level = sportLevel, RecordSelector.selectedSportType != nil {
            closure?(RecordSubType.sportLevel, level)
        }
    }
}

//MARK:- picker选择器回调
extension RecordSelector: UIPickerViewDelegate, UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        switch type as RecordSubType {
        case .weightFat, .diastolicPressure, .systolicPressure, .heartrateActivityType, .heartrateValue:
            return 1
        case .weightValue:
            return 3
        default:
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch type as RecordSubType {
        case .weightFat:
            return 100
        case .diastolicPressure:
            return 40
        case .systolicPressure:
            return 40
        case .heartrateActivityType:
            return 2
        case .heartrateValue:
            return 250
        case .weightValue:
            switch component {
            case 0:
                return weightDataList.count
            case 1:
                return weightDotDataList.count
            default:
                return weightUnitDataList.count
            }
            return weightDataList.count
        default:
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        
        switch type as RecordSubType {
        case .weightFat, .diastolicPressure, .systolicPressure, .heartrateActivityType, .heartrateValue:
            return frame.width
        case .weightValue:
            return frame.width / 3
        default:
            return frame.width
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch type as RecordSubType {
        case .weightFat:
            return "\(row)"
        case .diastolicPressure:
            return "\(row)"
        case .systolicPressure:
            return "\(row)"
        case .heartrateActivityType:
            return "\(row)"
        case .heartrateValue:
            return "\(row)"
        case .sportDuration:
            return "\(row)"
        case .weightValue:
            switch component {
            case 0:
                return "\(weightDataList[row])"
            case 1:
                return ".\(weightDotDataList[row])"
            default:
                return weightUnitDataList[row]
            }
        default:
            return ""
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        var selectedValue: Any?
        switch type as RecordSubType {
        case .weightFat:
            selectedValue = 44
        case .diastolicPressure:
            selectedValue = 44
        case .systolicPressure:
            selectedValue = 44
        case .heartrateActivityType:
            selectedValue = 44
        case .heartrateValue:
            selectedValue = 44
        case .sportDuration:
            selectedValue = 44
        case .weightValue:
            selectedValue = 44
        default:
            selectedValue = nil
        }
        closure?(type, selectedValue)
    }
}

//Collection delegate
extension RecordSelector: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    //dataSource
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pageCount * 9
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let row = indexPath.row
        let identifier = "custom"
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! RecordCollectionCell
        
        if row >= collectionCount{
            cell.type = nil
            return cell
        }
        
        let rawValue = Int16(row)
        if let sportType = SportType(rawValue: rawValue){
            cell.type = sportType
        }
        
        return cell
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        pageControl?.currentPage = Int(scrollView.contentOffset.x) / Int(frame.width) //indexPath.row
    }
    
    func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    //flow layout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //返回等同于窗口大小的尺寸
        return CGSize(width: frame.width / 3, height: (frame.height - 20) / 3)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .zero //UIEdgeInsets(top: 3, left: 3, bottom: 3, right: 3)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize.zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    //    func collectionView(_ collectionView: UICollectionView, transitionLayoutForOldLayout fromLayout: UICollectionViewLayout, newLayout toLayout: UICollectionViewLayout) -> UICollectionViewTransitionLayout {
    //
    //    }
    
    //delegate
    func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        let row = indexPath.row
        if row >= collectionCount {
            return false
        }
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let row = indexPath.row
        if row < collectionCount{
            //选择回调
            let cell = collectionView.cellForItem(at: indexPath) as! RecordCollectionCell
            RecordSelector.selectedSportType = cell.type
            if let cellType = cell.type{
                closure?(type, cellType)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return true
    }
}
