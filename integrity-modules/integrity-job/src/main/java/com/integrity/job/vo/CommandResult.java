package com.integrity.job.vo;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.ToString;

/**
 * 命令结果
 *
 * @author liangli_lmj@126.com
 * @date 2024-11-28
 */
@Data
@ToString
@AllArgsConstructor
@NoArgsConstructor
public class CommandResult {
    private int code;

    private String message;

    public static CommandResult success(String message) {
        CommandResult commandResult = new CommandResult();
        commandResult.setCode(0);
        commandResult.setMessage(message);
        return commandResult;
    }

    public static CommandResult success() {
        return success("成功");
    }

    public static CommandResult fail(String message) {
        CommandResult commandResult = new CommandResult();
        commandResult.setCode(1);
        commandResult.setMessage(message);
        return commandResult;
    }
}
