//
//  ProcessState.h
//  DoodleTee
//
//  Created by xieyajie on 13-6-26.
//  Copyright (c) 2013年 XD. All rights reserved.
//

#ifndef DoodleTee_ProcessState_h
#define DoodleTee_ProcessState_h

const typedef enum{
    XDProcessStateNormal = 0,  //原始状态
    XDProcessStateBlackAndWhite, //黑白
    XDProcessStateLomo,    //lomo
    XDProcessStateBlues,   //蓝调
    XDProcessStateGothic,  //哥特
    XDProcessStateSharpen, //锐化
    XDProcessStateVintage, //复古
    XDProcessStateHalo,    //光晕
    XDProcessStateDream,   //梦幻
    XDProcessStateDarlness,//夜色
    XDProcessStateRomantic,//浪漫
    XDProcessStateQuietly, //淡雅
    XDProcessStateClaret,  //酒红
}XDProcessState;

#endif
