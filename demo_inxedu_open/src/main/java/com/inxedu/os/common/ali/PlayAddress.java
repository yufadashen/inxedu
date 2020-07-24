package com.inxedu.os.common.ali;

import com.aliyuncs.DefaultAcsClient;
import com.aliyuncs.profile.DefaultProfile;
import com.aliyuncs.profile.IClientProfile;
import com.aliyuncs.vod.model.v20170321.GetPlayInfoRequest;
import com.aliyuncs.vod.model.v20170321.GetPlayInfoResponse;

import java.util.List;

/**
 * @author 余发
 * @version : v1
 * @description : 获取视频播放地址
 */
public class PlayAddress {

    /*以下为调用示例*/
    public static String getPlayAddress(String videourl) {
        DefaultAcsClient client = initVodClient();
        GetPlayInfoResponse response = new GetPlayInfoResponse();
        try {
            GetPlayInfoRequest request = new GetPlayInfoRequest();
            request.setVideoId(videourl);
            response = client.getAcsResponse(request);
            List<GetPlayInfoResponse.PlayInfo> playInfoList = response.getPlayInfoList();
            //播放地址
            for (GetPlayInfoResponse.PlayInfo playInfo : playInfoList) {
                System.out.print("播放地址 = " + playInfo.getPlayURL() + "\n");
                return playInfo.getPlayURL();
            }
            //Base信息
            System.out.print("Base信息 = " + response.getVideoBase().getTitle() + "\n");
        } catch (Exception e) {
            System.out.print("ErrorMessage = " + e.getLocalizedMessage());
        }
        System.out.print("RequestId = " + response.getRequestId() + "\n");
        return null;
    }


    /*获取播放地址函数*/
    public static GetPlayInfoResponse getPlayInfo(DefaultAcsClient client) throws Exception {
        GetPlayInfoRequest request = new GetPlayInfoRequest();
        request.setVideoId("ce2f61cfd5664e1b8c90b052a3992594*");
        return client.getAcsResponse(request);
    }

    public static DefaultAcsClient initVodClient()
    {
        // 点播服务接入区域
        String regionId = "cn-shanghai";
        IClientProfile profile = DefaultProfile.getProfile(regionId,"LTAI4G5TCYCdybuM2btJ9RXd*", "UFK0TIeB0xdVa1IAZtoBkUK9N76LqU*");
        return new DefaultAcsClient(profile);
    }
}
