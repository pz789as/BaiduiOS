/**
 * Sample React Native App
 * https://github.com/facebook/react-native
 */

import React, { Component } from 'react';
import {
  AppRegistry,
  StyleSheet,
  Text,
  View,
  Image,
  TextInput,
  TouchableOpacity,
  PixelRatio,
} from 'react-native';

var faceIcon = [
  require('./img/1.png'),
  require('./img/2.png'),
  require('./img/3.png'),
];

var fileData = require('./data/data.json');

export default class PracticeInterface extends Component {
  arc: null;
  readIndex:0;
  constructor(props){
    console.log("data length: " + fileData.length);
    super(props);
    this.arc = props.arc;
    this.readIndex = 0;
    this.state = {
      read:fileData[this.readIndex].Msg,
      result:'识别结果',
      score:'',
      iconIdx:0,
      message:'点击话筒说话',
      isRecog:false,
      isInput:false,
    };
  }
  render() {
    return (
      <View style={styles.body}>
        <View style={styles.base}>
          <Text style={styles.title}>练习模式</Text>

          <View style={[styles.colDiv,styles.colDivRow]}>
            <View style={styles.cp}>
              {
                this.state.isInput ?
                <TextInput style={styles.input}
                  onChangeText={(text)=>this.setState({read:text})}
                  multiline={true}
                  selectTextOnFocus={true}
                  onEndEditing={this.MenuBack.bind(this)}></TextInput> :
                <Text style={styles.p}>{this.state.read}</Text>
              }
            </View>
            <View style={styles.img}>
              <TouchableOpacity onPress={this.PlayDemo.bind(this)}>
                <Image style={[styles.borderImg]}
                     source={require('./img/speak.png')}
                     resizeMode='contain' />
              </TouchableOpacity>
            </View>
          </View>

          <View style={styles.clear}></View>

          <View style={styles.colDiv}>
            <View style={styles.cp}>
              <Text style={styles.p}>{this.state.result}</Text>
            </View>
          </View>

          <View style={styles.clear}></View>

          <View style={[styles.colDiv, styles.colDivRow, styles.view_result_height]}>
            <View style={styles.view_result}>
              <Text style={styles.score}>评分结果：</Text>
              <Text style={styles.score_n}>{this.state.score}</Text>
            </View>
            <View style={styles.img}>
              {
                this.state.isRecog ?
                <Image style={[styles.faceImg,styles.borderBottom]}
                   source={faceIcon[this.state.iconIdx]}
                   resizeMode='contain' /> :
                <Text></Text>
              }
            </View>
          </View>

          <View style={styles.record}>
            <TouchableOpacity onPress={this.Start.bind(this)}>
              <View style={styles.record_back}>
                <Image style={styles.record_img}
                     source={require('./img/record.png')}
                     resizeMode='contain' />
              </View>
            </TouchableOpacity>
            <Text style={styles.message}>{this.state.message}</Text>
          </View>

          <View style={[styles.colDiv, styles.bottom, styles.colDivRow]}>
            <TouchableOpacity onPress={this.LastDemo.bind(this)}>
              <Image style={[styles.bottom_img, styles.floatLeft, styles.borderBottom]}
                   source={require('./img/left.png')}
                   resizeMode='contain'/>
            </TouchableOpacity>
            <TouchableOpacity onPress={this.MenuBack.bind(this)}>
              <Image style={[styles.bottom_img, styles.borderBottom]}
                   source={require('./img/menu.png')}
                   resizeMode='contain'/>
            </TouchableOpacity>
            <TouchableOpacity onPress={this.NextDemo.bind(this)}>
              <Image style={[styles.bottom_img, styles.floatRight, styles.borderBottom]}
                  source={require('./img/right.png')}
                  resizeMode='contain'/>
            </TouchableOpacity>
          </View>
        </View>
      </View>
    );
  }
  Start(){
    this.setState({
      score:'',
      isRecog:false,
    });
    this.arc.Start();
  }
  PlayDemo(){
  }
  LastDemo(){
    this.readIndex--;
    if (this.readIndex >= 0){
      this.setState({
        read:fileData[this.readIndex].Msg,
        result:'识别结果',
        score:'',
        isRecog:false,
      })
      this.arc.Cancel();
    }else {
      this.readIndex = 0;
    }
  }
  NextDemo(){
    this.readIndex++;
    if (this.readIndex < fileData.length){
      this.setState({
        read:fileData[this.readIndex].Msg,
        result:'识别结果',
        score:'',
        isRecog:false,
      })
      this.arc.Cancel();
    }else {
      this.readIndex = fileData.length - 1;
    }
  }
  MenuBack(){
    var input = !this.state.isInput;
    this.setState({
      isInput:input,
    });
  }
  asrCallback(result){
    var icon = 0;
    var score = this.Levenshtein(result, this.state.read) * 100;
    console.log("score:" + score);
    if (score >= 80){
      icon = 2;
    }else if (score >= 60){
      icon = 1;
    }else {
      icon = 0;
    }
    var scoreText = parseInt(score).toString() + "分";
    this.setState({
      iconIdx:icon,
      result:result,
      isRecog:true,
      score:scoreText,
    });
  }
  setTips(tips){
    this.setState({
      message:tips,
    });
  }
  Levenshtein(src, tgt){
    var strSrc = src.replace(/[`~!@#$%^&*()+=|{}':;',.<>/?~！@#¥%⋯⋯& amp;*（）——+|{}【】‘；：”“’。，、？|-]/g,"");
    var strTgt = tgt.replace(/[`~!@#$%^&*()+=|{}':;',.<>/?~！@#¥%⋯⋯& amp;*（）——+|{}【】‘；：”“’。，、？|-]/g,"");
    var bounds = { Height : strSrc.length + 1, Width : strTgt.length + 1 };
    var matrix = new Array(bounds.Height);
    for (var height = 0; height < bounds.Height; height++)
    {
        matrix[height] = new Array(bounds.Width);
        matrix[height][0] = height;
    }
    for (var width = 0; width < bounds.Width; width++)
    {
        matrix[0][width] = width;
    }

    for (var height = 1; height < bounds.Height; height++)
    {
        for (var width = 1; width < bounds.Width; width++)
        {
            var cost = (strSrc[height - 1] == strTgt[width - 1]) ? 0 : 1;
            var insertion = matrix[height][width - 1] + 1;
            var deletion = matrix[height - 1][width] + 1;
            var substitution = matrix[height - 1][width - 1] + cost;

            var distance = Math.min(insertion, Math.min(deletion, substitution));

            if (height > 1 && width > 1 && strSrc[height - 1] == strTgt[width - 2] && strSrc[height - 2] == strTgt[width - 1])
            {
                distance = Math.min(distance, matrix[height - 2][width - 2] + cost);
            }
            matrix[height][width] = distance;
        }
    }
    return 1 - matrix[bounds.Height - 1][bounds.Width - 1] / Math.max(strSrc.length, strTgt.length);
  }
}

const styles = StyleSheet.create({
  input:{
    flex:1,
    padding:5*PixelRatio.get(),
    fontSize:15*PixelRatio.get(),
  },
  bottom:{
    height:36*PixelRatio.get(),
    marginBottom:8*PixelRatio.get(),
    alignItems:'center',
    justifyContent:'space-between',
  },
  floatLeft:{
    marginLeft:10*PixelRatio.get(),
  },
  bottom_img:{
    width:30*PixelRatio.get(),
    height:30*PixelRatio.get(),
  },
  floatRight:{
    marginRight:10*PixelRatio.get(),
  },
  body:{
    flex:1,
    backgroundColor:'#eeeeee'
  },
  base:{
    flex:1,
    backgroundColor:'cornsilk',
    margin:10*PixelRatio.get(),
    borderRadius:10*PixelRatio.get(),
    borderWidth:5*PixelRatio.get(),
    borderColor:'#376a9c'
  },
  title:{
    padding:5*PixelRatio.get(),
    textAlign:'center',
    fontSize:25*PixelRatio.get(),
    color:'#5e5e5e',
    backgroundColor:'transparent',
  },
  colDiv:{
    backgroundColor:'#4183c4',
  },
  colDivRow:{
    flexDirection:'row',
  },
  cp:{
    backgroundColor:'#ddd',
    borderRadius:5*PixelRatio.get(),
    margin:5*PixelRatio.get(),
    flex:1,
  },
  p:{
    padding:5*PixelRatio.get(),
    backgroundColor:'transparent',
    fontSize:15*PixelRatio.get(),
  },
  img:{
    marginTop:2*PixelRatio.get(),
    marginBottom:2*PixelRatio.get(),
    marginRight:5*PixelRatio.get(),
    justifyContent: 'center',
  },
  width60:{
    width:60*PixelRatio.get(),
  },
  borderImg:{
    width:50*PixelRatio.get(),
    height:50*PixelRatio.get(),
    borderRadius:25*PixelRatio.get(),
  },
  borderBottom:{
    borderRadius:15*PixelRatio.get(),
  },
  clear:{
    height: 8*PixelRatio.get(),
  },
  faceImg:{
    width:30*PixelRatio.get(),
    height:30*PixelRatio.get(),
    marginRight:30*PixelRatio.get(),
  },
  view_result:{
    flex:1,
    flexDirection:'row',
  },
  view_result_height:{
    height:35*PixelRatio.get(),
  },
  score:{
    fontSize:20*PixelRatio.get(),
    width:100*PixelRatio.get(),
    margin:5*PixelRatio.get(),
    marginLeft:30*PixelRatio.get(),
  },
  score_n:{
    fontSize:20*PixelRatio.get(),
    width:60*PixelRatio.get(),
    marginTop:5*PixelRatio.get(),
    marginBottom:5*PixelRatio.get(),
  },
  record:{
    flex:1,
    justifyContent:'center',
    alignItems:'center',
  },
  record_back:{
    height:130*PixelRatio.get(),
    width:120*PixelRatio.get(),
    borderRadius:60*PixelRatio.get(),
    borderWidth:1*PixelRatio.get(),
    borderColor:'saddlebrown',
    backgroundColor:'white',
    justifyContent:'center',
    alignItems:'center',
  },
  record_img:{
    backgroundColor:'transparent',
    height:120*PixelRatio.get(),
    width:110*PixelRatio.get(),
    borderRadius:55*PixelRatio.get(),
  },
  message:{
    color:'#909090',
    fontSize:15*PixelRatio.get(),
    marginTop:5*PixelRatio.get(),
  },
});
