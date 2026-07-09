package com.integrity.job.util;

import com.integrity.job.vo.CommandResult;
import org.apache.commons.exec.CommandLine;
import org.apache.commons.exec.DefaultExecutor;
import org.apache.commons.exec.ExecuteWatchdog;
import org.apache.commons.exec.PumpStreamHandler;

import java.io.ByteArrayOutputStream;

/**
 * Command 工具类
 *
 * @author liangli_lmj@126.com
 * @date 2024-11-28
 */
public final class CommandUtil {
    /**
     * 执行shell或python
     *
     * @param scriptPath 脚本路径
     * @param arguments  传递参数
     * @return {@link CommandResult}
     * @author liangli
     * @date 2024/11/28 11:23
     **/
    public static CommandResult exec(String executable, String scriptPath, String... arguments) {
        CommandResult commandResult = new CommandResult();
        // 创建字节数组输出流来保存标准输出和错误输出
        ByteArrayOutputStream outputStream = new ByteArrayOutputStream();
        ByteArrayOutputStream errorStream = new ByteArrayOutputStream();
        try {
            // 创建命令行
            CommandLine cmdLine = new CommandLine(executable);
            cmdLine.addArgument(scriptPath);

            for (String argument : arguments) {
                cmdLine.addArgument(argument);
            }

            // 创建PumpStreamHandler并将输出流连接到我们的字节数组输出流
            PumpStreamHandler streamHandler = new PumpStreamHandler(outputStream, errorStream);

            // 创建执行器
            DefaultExecutor executor = new DefaultExecutor();

            executor.setStreamHandler(streamHandler);

            // 设置一个看门狗（可选），以防止进程无限期挂起
            ExecuteWatchdog watchdog = new ExecuteWatchdog(-1); // 60秒超时
            executor.setWatchdog(watchdog);

            // 执行命令
            int exitValue = executor.execute(cmdLine);
            commandResult.setCode(exitValue);
            commandResult.setMessage(outputStream.toString());
        } catch (Exception e) {
            commandResult.setCode(1);
            if (errorStream.toString().contains("No such file or directory")) {
                commandResult.setMessage(errorStream.toString());
            } else if (e.getMessage().contains("Exit value: 1")) {
                commandResult.setMessage(outputStream.toString());
            } else {
                String errorMsg = e.getMessage();
                commandResult.setMessage(errorMsg);
            }
        }
        return commandResult;
    }
}
