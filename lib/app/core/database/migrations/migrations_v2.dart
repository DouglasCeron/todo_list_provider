//CLASSE TESTE PARA UM VERSION 2 DO DATABASE

import 'package:sqflite/sqflite.dart';
import 'package:todo_list_provider/app/core/database/migrations/migrations.dart';

class MigrationsV2 implements Migrations {
  @override
  void create(Batch batch) {
    batch.execute('''
   create table teste(id integer)
    )
''');
  }

  @override
  void update(Batch batch) {
    batch.execute('''create table teste(id integer''');
  }
}
