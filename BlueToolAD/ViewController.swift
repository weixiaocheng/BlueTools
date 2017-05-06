//
//  ViewController.swift
//  BlueToolAD
//
//  Created by user on 17/4/27.
//  Copyright © 2017年 loda. All rights reserved.
//

import UIKit
import CoreBluetooth
let TRANSFER_SERVICE_UUID = "E20A39F4-73F5-4BC4-A12F-17D1AD07A961"
let TRANSFER_CHARACTERISTIC_UUID  =  "08590F7E-DB05-467E-8757-72F6FAEB13D4"

class ViewController: UIViewController {

    //中心管理者
    var  cMgr : CBCentralManager?
    
    //连接到的外设
    var peripheral : CBPeripheral?
    
   
    // 显示TextView 和 发送按钮
    let  textView : UITextView? = UITextView()
    
    let senderBrn  = UIButton()
    
    var dataaaaa : NSMutableData? = NSMutableData()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white;
        self.title = "广播模式";
        setUpview();
        setUpBlueToos();
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
/*
 搭建一个简单的界面
 */
extension ViewController{
    func setUpview()  {
        let leftBarButtom : UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: #selector(ViewController.scanperipheral));
        
        self.navigationItem.leftBarButtonItem = leftBarButtom;
        
        let rightBarButtom : UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.cancel, target: self, action: #selector(ViewController.cancelScan));
        
        self.navigationItem.rightBarButtonItem = rightBarButtom;
        self.textView?.frame = CGRect(x: 30, y: 64 + 15, width: KSCREENWIDTH - 60, height: 200)
        self.textView?.layer.borderWidth = 1;
        self.textView?.layer.borderColor = UIColor.black.cgColor;
        self.textView?.layer.cornerRadius = 10;
        
        
        
        //添加输入框
        self.view.addSubview(self.textView!)
        
        //添加 发送按钮 
        self.senderBrn.frame = CGRect(x: 30, y: (self.textView?.frame.maxY)! + 30, width: KSCREENWIDTH - 60 , height: 40)
        self.senderBrn.setTitle("发送", for: UIControlState.normal);
        self.senderBrn.setTitleColor(UIColor.black, for: UIControlState.normal);
        self.senderBrn.layer.cornerRadius = 10;
        self.senderBrn.layer.borderColor = UIColor.black.cgColor;
        self.senderBrn.layer.borderWidth = 1;
        self.view.addSubview(self.senderBrn)
        
  
        
    }
    
    //扫描 
    func scanperipheral()  {
//      self.cMgr?.scanForPeripherals(withServices: nil, options: nil)
        /* [CBUUID(string: TRANSFER_SERVICE_UUID)]*/
        self.cMgr?.scanForPeripherals(withServices: [CBUUID(string: TRANSFER_SERVICE_UUID)], options: [CBCentralManagerScanOptionAllowDuplicatesKey : true])
        HFLog(message: "Scanning started")
    }
    
    //取消扫描
    func cancelScan()  {
        self.cMgr?.stopScan()
    }
    
    
    //文字输入框 
    
    
    
    
    
    
    
    
    
}



/*
 我需要在这里开启  蓝牙通讯
 */
extension ViewController : CBCentralManagerDelegate{
    func setUpBlueToos()  { //判断蓝牙是否 开启 如果没有 就提示用户开启蓝牙 服务
        cMgr = CBCentralManager(delegate: self, queue: nil);
        
    }
    
    
    
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
    
        if #available(iOS 10.0, *) {
            switch central.state {
            case CBManagerState.unknown:
                HFLog(message: "状态未知");
                break
                
            case CBManagerState.resetting:
                
                HFLog(message: "状态 resetting");
                break
            case CBManagerState.unsupported:
                HFLog(message: "状态 不支持")
                break
                
            case CBManagerState.unauthorized:
                
                HFLog(message: "状态没有授权 ")
                break
                
            case CBManagerState.poweredOff:
                HFLog(message: "请开启蓝牙")
                break
                
            case CBManagerState.poweredOn:
                HFLog(message: "蓝牙开启")
                self.scanperipheral();
                break
                
          
                
            }
        } else {
       
            HFLog(message: "不支持 蓝牙状态 方法\n \(central.state)")
            
            
        }
        
        
        
        
        
    }
    
    
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        HFLog(message: "didConnect  \n外围设备: \(peripheral)");
        self.cMgr?.stopScan()
        
        self.dataaaaa?.length = 0;
        
        
        peripheral.delegate = self;
        
        peripheral.discoverServices([CBUUID(string: TRANSFER_SERVICE_UUID)])
    }
    
    func centralManager(_ central: CBCentralManager, willRestoreState dict: [String : Any]) {
          HFLog(message: "willRestoreState  \n外围设备: \(dict)");
    }
    
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
         HFLog(message: "didFailToConnect \n外围设备: \(peripheral)");
    }
    
    
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        HFLog(message: "didDisconnectPeripheral \n外围设备: \(peripheral)");
        self.peripheral = nil;
//        self.scanperipheral();
     
        
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        if (RSSI.intValue > -15) {
            return;
        }
        
        // Reject if the signal strength is too low to be close enough (Close is around -22dB)
        if (RSSI.intValue < -35) {
            return;
        }
       
        
         HFLog(message: " 信号强度\(RSSI)");
    
        
        
        
        if self.peripheral != peripheral {
            
            self.peripheral = peripheral;
            
            self.cMgr?.connect(peripheral, options: nil);
            
        }
        
    
    }
        
    
    
    
    
    
    
    
}


extension ViewController : CBPeripheralDelegate{
    //更新外设的名称
    func peripheralDidUpdateName(_ peripheral: CBPeripheral) {
        
    }
    //发现外设
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        HFLog(message: "didDiscoverServices \n外围设备: \(peripheral)");
        
        if (error != nil) {
            HFLog(message: error?.localizedDescription)
            return
        }
        
        if peripheral.services != nil {
            for service  in peripheral.services! {
                peripheral.discoverCharacteristics([CBUUID(string: TRANSFER_CHARACTERISTIC_UUID)], for: service);
            }
        }
        
        
        
    }
    
    func peripheral(_ peripheral: CBPeripheral, didReadRSSI RSSI: NSNumber, error: Error?) {
         HFLog(message: "didReadRSSI \n外围设备: \(peripheral) \n 距离\(RSSI)");
    }
    
    func peripheral(_ peripheral: CBPeripheral, didModifyServices invalidatedServices: [CBService]) {
          HFLog(message: "didModifyServices \n外围设备: \(invalidatedServices)");
    }
    
    func peripheral(_ peripheral: CBPeripheral, didWriteValueFor descriptor: CBDescriptor, error: Error?) {
        HFLog(message: "didWriteValueFor \n外围设备: \(descriptor)");
    }
    
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor descriptor: CBDescriptor, error: Error?) {
        HFLog(message: "didUpdateValueFor \n外围设备: \(descriptor)");
    }
    
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        HFLog(message: "didDiscoverCharacteristicsFor \n外围设备: \(service)");
        
        for characteris:CBCharacteristic in service.characteristics! {
            
            if characteris.uuid.isEqual(CBUUID(string: TRANSFER_CHARACTERISTIC_UUID)) {
                peripheral.setNotifyValue(true, for: characteris);
            }
            
        }
        
    }
    
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverIncludedServicesFor service: CBService, error: Error?) {
         HFLog(message: "didDiscoverIncludedServicesFor \n外围设备: \(service)");
    }
    
    
    func peripheral(_ peripheral: CBPeripheral, didWriteValueFor characteristic: CBCharacteristic, error: Error?) {
        HFLog(message: "didWriteValueFor \n外围设备: \(characteristic)");
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        HFLog(message: "characteristic \n外围设备: \(characteristic)");
        
        let stringfromData : String = String(data: characteristic.value!, encoding: String.Encoding.utf8)!
        
        if stringfromData == "EOM" {
            
            self.textView?.text = String(data: self.dataaaaa! as Data, encoding: String.Encoding.utf8);
            
            peripheral.setNotifyValue(false, for: characteristic);
            
            self.cMgr?.cancelPeripheralConnection(peripheral);
        }
        
        self.dataaaaa?.append(characteristic.value!);
        HFLog(message: "\(self.textView?.text) \n 这里放置 self.data : \(self.dataaaaa)")
        
        
    }
    
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverDescriptorsFor characteristic: CBCharacteristic, error: Error?) {
        HFLog(message: "didDiscoverDescriptorsFor \n外围设备: \(characteristic)");
    }
    
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateNotificationStateFor characteristic: CBCharacteristic, error: Error?) {
         HFLog(message: "didUpdateNotificationStateFor \n外围设备: \(characteristic)");
    }
    
    
}


