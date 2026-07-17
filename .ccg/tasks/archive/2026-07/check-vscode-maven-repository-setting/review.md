# Review

## Result

- Confirmed that `.vscode/settings.json` points Maven to `D:\environment\maven\apache-maven-3.9.9\conf\settings.xml`.
- Confirmed that this `settings.xml` sets `<localRepository>D:/environment/maven/maven-repository</localRepository>`.
- The earlier offline bundle used the default `~/.m2/repository`, which was incorrect for this workspace.

## Fix Applied

- Added the correct Maven repository archive to the offline bundle:
  - `D:\offline-bundles\integrity-docker-offline-20260717\maven\maven-repository.tar.gz`
- Copied the active Maven settings file into the offline bundle:
  - `D:\offline-bundles\integrity-docker-offline-20260717\maven\settings.xml`
- Updated `docker/OFFLINE-DEV-GUIDE.md` to restore Maven cache under `D:\environment\maven\maven-repository`.
- Updated the offline bundle `MANIFEST.txt`, source snapshot zip and SHA256 checksums.

## Verification

- `mvn -o -DskipTests validate` succeeded using the configured Maven repository.
- Offline bundle now lists `maven/maven-repository.tar.gz` and `maven/settings.xml` as the Maven files to use.

## Note

- The previous `maven/m2-repository.zip` remains in the bundle directory because deletion was blocked by the local tool policy. It is not referenced by the updated guide or manifest and can be ignored.
