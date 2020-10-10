package edu.hbuas.programmer.util;

import java.text.SimpleDateFormat;
import java.util.Date;
 
/**
 * 日期格式化工具类
 * @author Shixf
 * @date 2018年5月4日
 */
public class DateUtil {
     
    /**
     * 将Date转换成String
     * @param date
     * @return
     */
    public static String date2String(Date date) {
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        String dateStr = sdf.format(date);
        return dateStr;
    }
}
