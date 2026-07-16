import java.sql.*;
import java.util.*;

// 把 nacos 配置里写死的 `jdbc:dm://localhost:5236` 改成可被容器环境变量覆盖
// 的 `jdbc:dm://${DM_HOST:localhost}:5236`。这样 docker compose 里注入的
// DM_HOST=host.docker.internal 生效，而本机 IDE 直跑时 fallback 仍是 localhost。
// 用法（DM 在本机 5236 监听）：
//   java --source 21 -cp ./DmJdbcDriver18-8.1.3.140.jar FixNacosDmHost.java             # 检查
//   java --source 21 -Dmode=apply -cp ./DmJdbcDriver18-8.1.3.140.jar FixNacosDmHost.java # 真改
public class FixNacosDmHost {
  public static void main(String[] a) throws Exception {
    boolean apply = "apply".equals(System.getProperty("mode", "inspect"));
    String url = System.getProperty(
        "dm.url",
        "jdbc:dm://127.0.0.1:5236/INTEGRITY-CONFIG?schema=SYSDBA&compatibleMode=mysql");
    Class.forName("dm.jdbc.driver.DmDriver");
    String ptn = "jdbc:dm://localhost:5236";
    String repl = "jdbc:dm://${DM_HOST:localhost}:5236";

    try (Connection c = DriverManager.getConnection(url, "SYSDBA", "IntegritySupervision0")) {
      List<String> dataIds = Arrays.asList(
          "integrity-system-dev.yml", "integrity-gen-dev.yml",
          "integrity-job-dev.yml", "integrity-flow-dev.yml");
      for (String dataId : dataIds) {
        try (PreparedStatement p = c.prepareStatement(
            "SELECT id, content FROM config_info WHERE data_id = ? ORDER BY id")) {
          p.setString(1, dataId);
          try (ResultSet r = p.executeQuery()) {
            int seen = 0, changed = 0;
            while (r.next()) {
              seen++;
              long id = r.getLong(1);
              String content = r.getString(2);
              if (content == null) continue;
              int hits = countOccurrences(content, ptn);
              String updated = content.replace(ptn, repl);
              if (!updated.equals(content)) {
                changed++;
                System.out.println("[" + (apply ? "APPLY" : "DRY") + "] " + dataId + " id=" + id + " hits=" + hits);
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
            if (seen == 0) System.out.println("[skip ] " + dataId + " (no row)");
            else if (changed == 0) System.out.println("[noop ] " + dataId + " no change (" + seen + " rows)");
          }
        }
      }
      if (!apply) System.out.println("\nDRY RUN. Re-run with -Dmode=apply to actually write.");
    }
  }

  static int countOccurrences(String s, String sub) {
    int n = 0, i = 0;
    while ((i = s.indexOf(sub, i)) >= 0) { n++; i += sub.length(); }
    return n;
  }
}
