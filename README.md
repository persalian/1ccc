# 1CCacheCleaner

Требование: Powershell

Скрипт определяет локальных пользователей и проверяет размер каталогов

%userprofile%\AppData\Roaming\1C\1cv8

%userprofile%\AppData\Local\1C\1cv8

выводит объем временых файлов по каждому пользователю и суммарный объем.

Использование:
        
1ccc.ps1 [-allusers | -user username ] [-deletetemp] [-help]

-allusers - processing caches of all user profiles (default)

-user username - processing caches username

-deletetemp - clear caches

-help - this help message

