import sys

def main():
    if len(sys.argv) != 3:
        print("Usage: python example.py param1 param2")
        sys.exit(1)

    param1 = sys.argv[1]
    param2 = sys.argv[2]

    print(f"Parameter 1: {param1}")
    print(f"Parameter 2: {param2}")
    print("Script output message")

    # 返回退出状态码
    sys.exit(0)

if __name__ == "__main__":
    main()