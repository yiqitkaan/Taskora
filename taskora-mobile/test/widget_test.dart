import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:taskora_mobile/data/task_data.dart';
import 'package:taskora_mobile/data/user_data.dart';
import 'package:taskora_mobile/main.dart';
import 'package:taskora_mobile/models/app_user.dart';
import 'package:taskora_mobile/models/task.dart';
import 'package:taskora_mobile/pages/task_list_page.dart';

const testUser = AppUser(
  id: 1,
  name: 'Test Kullanıcı',
  email: 'test@taskora.app',
  password: '123456',
);

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  const storageChannel = MethodChannel('com.yigitkaan.taskora/storage');
  final localStore = <String, String>{};

  setUp(() {
    localStore.clear();
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(storageChannel, (call) async {
          final arguments = Map<String, dynamic>.from(call.arguments as Map);
          final key = arguments['key'] as String;
          return switch (call.method) {
            'read' => localStore[key],
            'write' => () {
              localStore[key] = arguments['value'] as String;
              return null;
            }(),
            _ => throw MissingPluginException(),
          };
        });
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(storageChannel, null);
  });

  test('Kullanıcı JSON dönüşümü ve kimlik kontrolü çalışır', () {
    final user = AppUser.fromJson({
      'id': 2,
      'name': 'Demo Kullanıcı',
      'email': 'demo@taskora.app',
      'password': '123456',
    });
    expect(user.toJson()['email'], 'demo@taskora.app');
    expect(user.matches('DEMO@TASKORA.APP', '123456'), isTrue);
    expect(user.matches('demo@taskora.app', 'yanlis'), isFalse);
  });

  test('Task JSON dönüşümü alanları korur', () {
    final task = Task.fromJson({
      'id': 7,
      'title': 'Test görevi',
      'description': 'Model testi',
      'projectName': 'Taskora',
      'priority': 'Yüksek',
      'status': 'Bekliyor',
      'assignee': 'Yiğit Kaan Bilir',
      'dueDate': '20 Ekim 2026',
      'imagePath': 'assets/images/tasks/task-mobile.png',
    });
    expect(task.toJson()['title'], 'Test görevi');
    expect(task.copyWith(status: 'Tamamlandı').status, 'Tamamlandı');
    expect(task.copyWith(title: 'Güncel görev').title, 'Güncel görev');
    expect(task.toJson()['imagePath'], 'assets/images/tasks/task-mobile.png');
  });

  test('Kullanıcı ve görev listeleri yerel JSON deposunda korunur', () async {
    const task = Task(
      id: 11,
      title: 'Kalıcı görev',
      description: 'Yerel JSON testi',
      projectName: 'Taskora',
      priority: 'Orta',
      status: 'Bekliyor',
      assignee: 'Test Kullanıcı',
      dueDate: '30 Ekim 2026',
      imagePath: 'assets/images/tasks/task-roadmap.png',
    );
    await TaskData.saveTasks([task]);
    await UserData.saveUsers([testUser]);

    final tasks = await TaskData.loadTasks();
    final users = await UserData.loadUsers();
    expect(tasks.single.toJson(), task.toJson());
    expect(users.single.toJson(), testUser.toJson());
  });

  testWidgets('Görevler yüklenir, aranır ve detay sayfası açılır', (
    tester,
  ) async {
    await tester.pumpWidget(const TaskoraApp(initialUser: testUser));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));
    expect(find.text('Görev Listesi'), findsOneWidget);
    expect(find.text('Mobil görev ekranını hazırla'), findsOneWidget);
    expect(
      find.image(const AssetImage('assets/images/taskora_banner.png')),
      findsOneWidget,
    );
    expect(find.byKey(const ValueKey('task-grid')), findsOneWidget);

    await tester.tap(find.widgetWithText(ChoiceChip, 'Tamamlandı'));
    await tester.pump();
    expect(find.text("Proje roadmap'ini hazırla"), findsOneWidget);
    expect(find.text('Mobil görev ekranını hazırla'), findsNothing);

    await tester.tap(find.widgetWithText(ChoiceChip, 'Tümü'));
    await tester.pump();
    await tester.enterText(find.byType(TextField), 'SQL');
    await tester.pump();
    expect(find.text('SQL sorgularını doğrula'), findsOneWidget);
    expect(find.text('Mobil görev ekranını hazırla'), findsNothing);

    await tester.enterText(find.byType(TextField), '');
    await tester.pump();
    await tester.tap(find.text('Liste'));
    await tester.pump();
    expect(find.byKey(const ValueKey('task-grid')), findsNothing);

    await tester.tap(find.text('Mobil görev ekranını hazırla'));
    await tester.pumpAndSettle();
    expect(find.text('Görev Detayı'), findsOneWidget);
    expect(find.text('Yiğit Kaan Bilir'), findsOneWidget);
    expect(find.byKey(const ValueKey('task-detail-image')), findsOneWidget);
    expect(
      find.image(const AssetImage('assets/images/tasks/task-mobile.png')),
      findsOneWidget,
    );
    await tester.drag(find.byType(ListView).last, const Offset(0, -800));
    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey('advance-status-button')), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('advance-status-button')));
    await tester.pumpAndSettle();
    expect(find.text('Görev Detayı'), findsNothing);
    expect(find.text('Tamamlandı'), findsWidgets);
    expect(localStore['tasks'], contains('"status":"Tamamlandı"'));
  });

  testWidgets('Kart ve liste görünümleri dar ekranda taşma üretmez', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(390, 844));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    const testTask = Task(
      id: 1,
      title: 'Dar ekran görev kartı',
      description: 'Kart ve liste yerleşimi kontrol edilecek.',
      projectName: 'Taskora Mobile',
      priority: 'Yüksek',
      status: 'Devam Ediyor',
      assignee: 'Yiğit Kaan Bilir',
      dueDate: '20 Ekim 2026',
      imagePath: 'assets/images/tasks/task-mobile.png',
    );
    await tester.pumpWidget(
      const MaterialApp(home: TaskListPage(initialTasks: [testTask])),
    );
    await tester.pump();
    await tester.scrollUntilVisible(
      find.text('Dar ekran görev kartı'),
      200,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.byKey(const ValueKey('task-grid')), findsOneWidget);
    expect(tester.takeException(), isNull);

    await tester.drag(find.byType(ListView).first, const Offset(0, 500));
    await tester.pump(const Duration(milliseconds: 300));
    await tester.tap(find.text('Liste'));
    await tester.pump(const Duration(milliseconds: 300));
    expect(find.byKey(const ValueKey('task-grid')), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Yeni görev eklenir ve detay ekranından düzenlenir', (
    tester,
  ) async {
    const initialTask = Task(
      id: 1,
      title: 'Başlangıç görevi',
      description: 'Ekleme testi için başlangıç kaydı.',
      projectName: 'Taskora',
      priority: 'Orta',
      status: 'Bekliyor',
      assignee: 'Yiğit Kaan Bilir',
      dueDate: '25 Ekim 2026',
      imagePath: 'assets/images/tasks/task-roadmap.png',
    );
    await tester.pumpWidget(
      const TaskoraApp(initialTasks: [initialTask], initialUser: testUser),
    );
    await tester.pump();

    await tester.tap(find.byKey(const ValueKey('add-task-button')));
    await tester.pumpAndSettle();
    expect(find.text('Yeni Görev'), findsOneWidget);

    await tester.ensureVisible(find.byKey(const ValueKey('save-task-button')));
    await tester.pump();
    await tester.tap(find.byKey(const ValueKey('save-task-button')));
    await tester.pump();
    await tester.ensureVisible(find.byKey(const ValueKey('task-title-field')));
    await tester.pump();
    expect(find.text('Bu alan zorunludur.'), findsWidgets);

    await tester.enterText(
      find.byKey(const ValueKey('task-title-field')),
      'Sunum görevini hazırla',
    );
    await tester.enterText(
      find.byKey(const ValueKey('task-description-field')),
      'Mobil proje sunum akışını tamamla.',
    );
    await tester.ensureVisible(
      find.byKey(const ValueKey('task-due-date-field')),
    );
    await tester.pump();
    await tester.enterText(
      find.byKey(const ValueKey('task-due-date-field')),
      '28 Ekim 2026',
    );
    tester.testTextInput.hide();
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.byKey(const ValueKey('save-task-button')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('save-task-button')));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField).first, 'Sunum görevini');
    await tester.pump();
    await tester.scrollUntilVisible(
      find.text('Sunum görevini hazırla'),
      200,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(find.text('Sunum görevini hazırla'));
    await tester.pumpAndSettle();

    await tester.drag(find.byType(ListView).last, const Offset(0, -800));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('edit-task-button')));
    await tester.pumpAndSettle();
    expect(find.text('Görevi Düzenle'), findsWidgets);
    await tester.enterText(
      find.byKey(const ValueKey('task-title-field')),
      'Sunum görevini güncelle',
    );
    tester.testTextInput.hide();
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.byKey(const ValueKey('save-task-button')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('save-task-button')));
    await tester.pumpAndSettle();

    expect(find.text('Görev Listesi'), findsOneWidget);
    expect(find.text('Sunum görevini güncelle'), findsOneWidget);
  });

  testWidgets(
    'Demo kullanıcı giriş yapar, hatalı giriş reddedilir ve çıkış yapar',
    (tester) async {
      await tester.pumpWidget(const TaskoraApp(initialUsers: [testUser]));
      await tester.pumpAndSettle();
      expect(find.text('Tekrar hoş geldin'), findsOneWidget);

      await tester.enterText(
        find.byKey(const ValueKey('auth-email-field')),
        testUser.email,
      );
      await tester.enterText(
        find.byKey(const ValueKey('auth-password-field')),
        'yanlis-sifre',
      );
      await tester.ensureVisible(
        find.byKey(const ValueKey('auth-submit-button')),
      );
      await tester.tap(find.byKey(const ValueKey('auth-submit-button')));
      await tester.pump();
      expect(find.text('E-posta veya şifre hatalı.'), findsOneWidget);

      await tester.enterText(
        find.byKey(const ValueKey('auth-password-field')),
        testUser.password,
      );
      await tester.tap(find.byKey(const ValueKey('auth-submit-button')));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));
      expect(find.text('Görev Listesi'), findsOneWidget);

      await tester.tap(find.byKey(const ValueKey('logout-button')));
      await tester.pump();
      expect(find.text('Tekrar hoş geldin'), findsOneWidget);
    },
  );

  testWidgets(
    'Yeni kullanıcı kayıt olur ve aynı oturumda yeniden giriş yapar',
    (tester) async {
      await tester.pumpWidget(const TaskoraApp(initialUsers: []));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Kayıt Ol'));
      await tester.pumpAndSettle();
      expect(find.text('Taskora hesabını oluştur'), findsOneWidget);

      await tester.ensureVisible(
        find.byKey(const ValueKey('auth-submit-button')),
      );
      await tester.tap(find.byKey(const ValueKey('auth-submit-button')));
      await tester.pump();
      expect(find.text('Bu alan zorunludur.'), findsWidgets);

      await tester.enterText(
        find.byKey(const ValueKey('auth-name-field')),
        'Yeni Kullanıcı',
      );
      await tester.enterText(
        find.byKey(const ValueKey('auth-email-field')),
        'yeni@taskora.app',
      );
      await tester.enterText(
        find.byKey(const ValueKey('auth-password-field')),
        '654321',
      );
      await tester.enterText(
        find.byKey(const ValueKey('auth-confirm-field')),
        '654321',
      );
      tester.testTextInput.hide();
      await tester.pumpAndSettle();
      await tester.ensureVisible(
        find.byKey(const ValueKey('auth-submit-button')),
      );
      await tester.tap(find.byKey(const ValueKey('auth-submit-button')));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));
      expect(find.text('Görev Listesi'), findsOneWidget);
      expect(localStore['users'], contains('yeni@taskora.app'));

      await tester.tap(find.byKey(const ValueKey('logout-button')));
      await tester.pump();
      await tester.enterText(
        find.byKey(const ValueKey('auth-email-field')),
        'yeni@taskora.app',
      );
      await tester.enterText(
        find.byKey(const ValueKey('auth-password-field')),
        '654321',
      );
      await tester.ensureVisible(
        find.byKey(const ValueKey('auth-submit-button')),
      );
      await tester.tap(find.byKey(const ValueKey('auth-submit-button')));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));
      expect(find.text('Görev Listesi'), findsOneWidget);
    },
  );
}
