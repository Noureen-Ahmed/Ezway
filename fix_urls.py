import os
import re

files_to_update = [
    r'lib\screens\auth\verification_page.dart',
    r'lib\screens\auth\reset_password_screen.dart',
    r'lib\repositories\schedule_repository.dart',
    r'lib\repositories\course_repository.dart',
    r'lib\repositories\api_user_database.dart',
    r'lib\repositories\api_task_database.dart',
    r'lib\providers\advising_provider.dart',
    r'lib\repositories\api_service.dart',
    r'lib\repositories\announcement_repository.dart',
    r'lib\repositories\api_notification_service.dart',
]

for filepath in files_to_update:
    path = os.path.join(r'd:\Ezway', filepath)
    if not os.path.exists(path):
        continue
    with open(path, 'r', encoding='utf-8') as f:
        content = f.read()
    
    if 'advising_provider.dart' in filepath:
        content = content.replace("final String _baseUrl = 'https://ezway-production.up.railway.app/api/advising';", "final String _baseUrl = '${ApiConfig.baseUrl}/advising';")
    else:
        content = re.sub(r"static const String _?baseUrl = 'https://ezway-production\.up\.railway\.app/api';", "static const String _baseUrl = ApiConfig.baseUrl;", content)
        content = re.sub(r"static const String baseUrl = 'https://ezway-production\.up\.railway\.app/api';", "static const String baseUrl = ApiConfig.baseUrl;", content)

    if 'ApiConfig.baseUrl' in content and 'api_config.dart' not in content:
        import_stmt = "import '../../core/api_config.dart';"
        if r'lib\repositories' in filepath or 'lib/repositories' in filepath or r'lib\providers' in filepath:
            import_stmt = "import '../core/api_config.dart';"
        
        last_import_idx = content.rfind('import ')
        if last_import_idx != -1:
            end_of_line = content.find('\n', last_import_idx)
            content = content[:end_of_line+1] + import_stmt + '\n' + content[end_of_line+1:]
        else:
            content = import_stmt + '\n\n' + content

    with open(path, 'w', encoding='utf-8') as f:
        f.write(content)
print('Replaced URLs to use ApiConfig')
