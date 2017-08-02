//
//  iRSymbolBoardLeftControlView.swift
//  iRime
//
//  Created by 王宇 on 2017/7/18.
//  Copyright © 2017年 jimmy54. All rights reserved.
//  左侧控制条view

import UIKit

@objc protocol iRSymbolBoardLeftControlViewProtocol:NSObjectProtocol {
    func didSelectedOneCell(modelSelected:iRsymbolsItemModel,indexPath:NSIndexPath) -> Void
}


class iRSymbolBoardLeftControlView: UIView,UITableViewDataSource,UITableViewDelegate {

    var modelItemPreviousSelected:iRsymbolsItemModel?
    var indexPathPreviousSelected:NSIndexPath?
    weak var delegateCallBack:iRSymbolBoardLeftControlViewProtocol?
    
    var modelMain:iRsymbolsModel?
    lazy var tableView = {()->UITableView in
        let tableView:UITableView = UITableView.init(frame: CGRect.null, style: UITableViewStyle.plain)
        tableView.register(iRSymbolBoardLeftControlViewCell.classForCoder(), forCellReuseIdentifier: "iRSymbolBoardLeftControlViewCell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        
        return tableView
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.randomColor
        
        createSubViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK: 创建view
    func createSubViews() -> Void {
        //1.tableVeiw
        self.addSubview(tableView)
        //--约束布局
        tableView.mas_makeConstraints { (make:MASConstraintMaker!) in
            make.edges.equalTo()(self)
        }
    }
    // MARK: - tableView数据源方法
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return (modelMain?.arrayModels?.count)!
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "iRSymbolBoardLeftControlViewCell") as! iRSymbolBoardLeftControlViewCell
        
        let modelSymbolItem:iRsymbolsItemModel = (modelMain?.arrayModels?[indexPath.row])!
        cell.modelSymbolItem = modelSymbolItem
        if modelSymbolItem.isSelected && modelItemPreviousSelected == nil{
            modelItemPreviousSelected = modelSymbolItem;
            indexPathPreviousSelected = indexPath as NSIndexPath;
        }
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return iRSymbolBoardContentView.height_line_iRSymbolBoardLeftControlView
    }
    
    //MARK:talbeveiw 代理
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let modelSymbolItem:iRsymbolsItemModel = (modelMain?.arrayModels?[indexPath.row])!
        
        
        if modelItemPreviousSelected?.name == modelSymbolItem.name {
            return
        }
        
        modelItemPreviousSelected?.isSelected = false
        modelSymbolItem.isSelected = true
       
        var arrayNeed:[NSIndexPath]?
        if (indexPathPreviousSelected != nil) {
             arrayNeed = [indexPath as NSIndexPath,indexPathPreviousSelected!]
        }
        else
        {
             arrayNeed = [indexPath as NSIndexPath]
        }
        
        tableView.reloadRows(at: arrayNeed! as [IndexPath], with: UITableViewRowAnimation.none)
        
        if (self.delegateCallBack?.responds(to: #selector(iRSymbolBoardLeftControlViewProtocol.didSelectedOneCell(modelSelected:indexPath:))))!
        {
            self.delegateCallBack?.didSelectedOneCell(modelSelected: modelSymbolItem, indexPath: indexPath as NSIndexPath)
        }
        modelItemPreviousSelected = modelSymbolItem
        indexPathPreviousSelected = indexPath as NSIndexPath
    }
    
}
































