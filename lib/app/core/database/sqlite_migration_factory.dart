import 'package:todo_list_provider/app/core/database/migrations/migrations.dart';
import 'package:todo_list_provider/app/core/database/migrations/migrations_v1.dart';
import 'package:todo_list_provider/app/core/database/migrations/migrations_v3.dart';

import 'migrations/migrations_v2.dart';

class SqliteMigrationFactory {
  List<Migrations> getCreateMigration() => [
        MigrationsV1(),
        MigrationsV2(),
        MigrationsV3(),
      ];

  List<Migrations> getUpgradeMigratioon(int version) {
    var migrations = <Migrations>[];

    if (version == 1) {
      migrations.add(MigrationsV2());
      migrations.add(MigrationsV3());
    }
    if (version == 2) {
      migrations.add(MigrationsV3());
    }

    return migrations;
  }
}
