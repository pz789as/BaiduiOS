import React, { Component } from 'react';
import {
  AppRegistry,
  StyleSheet,
  Text,
} from 'react-native';

import PracticeInterface from './PracticeInterface';

export default class BaiduASR extends Component{
  constructor(props){
    super(props);
  }
  componentWillUnmount(){
    this.timer && clearTimeout(this.timer);
  }
  Start(){
    console.log('android start');
    this.timer && clearTimeout(this.timer);
    this.timer = setTimeout(this.listenerCallback.bind(this), 3000);
  }
  listenerCallback(){
    this.refs.child.getResult('80分');
    this.timer && clearTimeout(this.timer);
  }
  render(){
    return (
      <PracticeInterface arc={this} ref='child'></PracticeInterface>
    );
  }
}
