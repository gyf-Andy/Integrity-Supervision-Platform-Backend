import java.sql.*;
import java.util.*;

// 仅替换 nacos 配置表里 *redis* 小节下的 `host: localhost` 为 `host: redis`，
// 不动 datasource/DM 等其他可能出现的 localhost 配置（早期 .dmp 把内网视为单机）。
// 用法（在宿主机执行，DM 已在本机 5236 监听）：
//   java --source 21 -cp ./DmJdbcDriver18-8.1.3.140.jar FixNacosRedis.java            # inspect
//   java --source 21 -Dmode=apply -cp ./DmJdbcDriver18-8.1.3.140.jar FixNacosRedis.java   # 真改
public class FixNacosRedis {
  public static void main(String[] a) throws Exception {
    boolean apply = "apply".equals(System.getProperty("mode", "inspect"));
    String newHost = System.getProperty("redisHost", "redis");
    String url = System.getProperty(
        "dm.url",
        "jdbc:dm://127.0.0.1:5236/INTEGRITY-CONFIG?schema=SYSDBA&compatibleMode=mysql");
    Class.forName("dm.jdbc.driver.DmDriver");

    String ptn =
        "(?m)^(\\s*host:\\s*)localhost(\\s*#.*)?$";
    String ptnRedis =
        "(?ms)^(\\s*redis:[^\\n]*\\n(?:(?:\\s+[^\\n]*\\n)*?\\s{4,}host:\\s*)localhost(\\s*#.*)?)$|(?m)^(\\s*data:[^\\n]*\\n(\\s+redis:[^\\n]*\\n(?:\\s+[^\\n]*\\n)*?\\s{4,}host:\\s*)localhost(\\s*#.*)?)$";

    try (Connection c = DriverManager.getConnection(url, "SYSDBA", "IntegritySupervision0")) {
      List<String> dataIds = Arrays.asList(
          "integrity-auth-dev.yml", "integrity-system-dev.yml", "integrity-gen-dev.yml",
          "integrity-job-dev.yml", "integrity-flow-dev.yml", "integrity-gateway-dev.yml",
          "integrity-file-dev.yml", "integrity-monitor-dev.yml", "application-dev.yml");

      for (String dataId : dataIds) {
        try (PreparedStatement p = c.prepareStatement(
            "SELECT id, gmt_modified, content FROM config_info WHERE data_id = ? ORDER BY id")) {
          p.setString(1, dataId);
          try (ResultSet r = p.executeQuery()) {
            int seen = 0, changed = 0;
            while (r.next()) {
              seen++;
              long id = r.getLong(1);
              Timestamp ts = r.getTimestamp(2);
              String content = r.getString(3);
              if (content == null) continue;
              String updated = rewriteRedisHost(content, newHost);
              if (!updated.equals(content)) {
                changed++;
                System.out.println("[" + (apply ? "APPLY" : "DRY") + "] " + dataId + " id=" + id);
                System.out.println("  before-host=" + extractRedisHost(content));
                System.out.println("  after -host=" + extractRedisHost(updated));
                if (apply) {
                  try (PreparedStatement u = c.prepareStatement(
                      "UPDATE config_info SET content = ?, gmt_modified = ? WHERE id = ?")) {
                    u.setString(1, updated);
                    u.setTimestamp(2, new Timestamp(System.currentTimeMillis()));
                    u.setLong(3, id);
                    u.executeUpdate();
                  }
                }
              }
            }
            if (seen == 0) {
              System.out.println("[skip ] " + dataId + " (no row)");
            } else if (changed == 0) {
              System.out.println("[noop ] " + dataId + " no change (" + seen + " rows)");
            }
          }
        }
      }
      if (!apply) System.out.println("\nDRY RUN. Re-run with -Dmode=apply to actually write.");
    }
  }

  // 把 redis: 块下紧跟的 host: localhost 改为 host: newHost（只改第一处，保守到 spring.data.redis 这一级缩进）
  static String rewriteRedisHost(String yaml, String newHost) {
    // 匹配形如： `redis:` 后到 `  host:` 之间的同级 host，仅替换其值
    String[] lines = yaml.split("\n", -1);
    int redisIndent = -1;
    boolean inRedis = false;
    for (int i = 0; i < lines.length; i++) {
      String line = lines[i];
      String trimmed = line.replaceAll("\\s+#.*$", "");
      // 进入 redis: 块
      if (!inRedis) {
        if (trimmed.matches("^\\s*redis:\\s*$")) {
          redisIndent = leadingSpaces(trimmed);
          inRedis = true;
        }
      } else {
        int ind = leadingSpaces(trimmed);
        // 离开 redis 块：缩进 <= redis 块的下一级或同级退出
        int hostIndent = redisIndent + 2;
        if (ind > hostIndent) continue;          // 更深的子项暂不处理
        if (ind == hostIndent && trimmed.matches("^\\s*host:\\s*(\\S+)\\s*$")) {
          lines[i] = reIndent(hostIndent, "host: " + newHost) + "\t# docker compose: internal redis";
          inRedis = false;                        // 只改 redis 块的 host
        } else if (ind <= redisIndent) {
          inRedis = false;                        // 退出 redis 块
        }
      }
    }
    return String.join("\n", lines);
  }

  static String extractRedisHost(String yaml) {
    java.util.regex.Matcher m = java.util.regex.Pattern.compile(
        "(?ms)\\n\\s*redis:\\s*\\n(?:\\s+[^\\n]*\\n)*?\\s{4,}host:\\s*(\\S+)").matcher(yaml);
    return m.find() ? m.group(1) : "<n/a>";
  }

  static int leadingSpaces(String s) {
    int n = 0;
    while (n < s.length() && s.charAt(n) == ' ') n++;
    return n;
  }

  static String reIndent(int indent, String body) {
    StringBuilder sb = new StringBuilder();
    for (int i = 0; i < indent; i++) sb.append(' ');
    sb.append(body);
    return sb.toString();
  }
}
