#!/bin/bash
# 这是一个示例Shell脚本，它根据输入参数执行不同的操作并返回相应的状态码

# 检查是否提供了参数
if [ $# -eq 0 ]; then
    echo "没有提供参数！"
    exit 1 # 返回非零值表示错误
fi

# 假设我们有一个非常简单的逻辑：如果第一个参数是"success"，则成功退出；否则失败退出。
if [ "$1" == "success" ]; then
    echo "操作成功！"
    exit 0 # 返回0表示成功
else
    echo "操作失败！"
    exit 1 # 返回非零值表示失败
fi