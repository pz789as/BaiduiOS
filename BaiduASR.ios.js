import React, { Component } from 'react';
import {
  AppRegistry,
  StyleSheet,
  Text,
  NativeModules,
} from 'react-native';

import PracticeInterface from './PracticeInterface';

var BaiduReact = NativeModules.BaiduReact;
import RCTDeviceEventEmitter from 'RCTDeviceEventEmitter';

var AppID = "3407383";
var AppKey = "9oI5nu0IRWnt8Eq8QuGyEoMP";
var SecretKey = "Aw7w385DGFkEmU5YE82tx1lP7DASkxl5";
var ModelType = "TEST";

export default class BaiduASR extends Component{
  constructor(props){
    super(props);
    this.listener = null;
    this.speechStatus = BaiduReact.SPEECH_STOP;
  }
  componentDidMount(){
    BaiduReact.setInfo({
      "needVadFlag":"YES",
      "onlineWaitTime":5,
      "licenseMode":ModelType,
      "AppID":AppID,
      "API_KEY":AppKey,
      "SECRET_KEY":SecretKey,
    });
    this.listener = RCTDeviceEventEmitter.addListener('recognitionCallback', this.asrCallback.bind(this))
  }
  componentWillUnmount(){
    this.listener.remove();
  }
  asrCallback(data){
    if (data.code == BaiduReact.CB_CODE_RESULT){
      this.refs.child.asrCallback(data.result);
      this.refs.child.setTips('点击话筒开始说话');
      this.speechStatus = BaiduReact.SPEECH_STOP;
    }
    else if (data.code == BaiduReact.CB_CODE_ERROR){
      this.refs.child.setTips(data.result);
      this.speechStatus = BaiduReact.SPEECH_STOP;
    }
    else if (data.code == BaiduReact.CB_CODE_STATUS){
      if (data.result == BaiduReact.SPEECH_START){
        this.refs.child.setTips('正在倾听...');
      }else if (data.result == BaiduReact.SPEECH_WORK){
        this.refs.child.setTips('正在倾听...');
      }else if (data.result == BaiduReact.SPEECH_STOP){
        this.refs.child.setTips('点击话筒开始说话');
      }else if (data.result == BaiduReact.SPEECH_RECOG){
        this.refs.child.setTips('正在分析...');
      }
      this.speechStatus = data.result;
      console.log(data.result, BaiduReact.SPEECH_RECOG);
    }
    else {
      console.log(data.result);
    }
  }
  Start(){
    console.log('ios start');
    if (this.speechStatus == BaiduReact.SPEECH_STOP){
      this.refs.child.setTips('正在倾听...');
      BaiduReact.start();
    }else if (this.speechStatus == BaiduReact.SPEECH_WORK){
      this.refs.child.setTips('正在分析...');
      BaiduReact.finish();
    }else if (this.speechStatus == BaiduReact.SPEECH_START){
      this.Cancel();
    }else if (this.speechStatus == BaiduReact.SPEECH_RECOG){
      this.refs.child.setTips('正在分析...');
      BaiduReact.finish();
    }
  }
  Cancel(){
    if (this.speechStatus != BaiduReact.SPEECH_STOP){
      this.refs.child.setTips('点击话筒开始说话');
      BaiduReact.cancenl();
      this.speechStatus = BaiduReact.SPEECH_STOP;
    }
  }
  render(){
    return (
      <PracticeInterface arc={this} ref='child'></PracticeInterface>
    );
  }
}
