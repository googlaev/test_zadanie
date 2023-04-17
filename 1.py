import socket
import subprocess

servers = ['example.com', '192.168.1.1', 'google.com', 'invalid.server']

# Разделение списка серверов на три группы
unresolved = []
unreachable = []
reachable = []

for server in servers:
    try:
        ip_address = socket.gethostbyname(server)
    except socket.gaierror:
        unresolved.append(server)
    else:
        ping = subprocess.run(['ping', '-c', '1', '-W', '1', ip_address], stdout=subprocess.PIPE, stderr=subprocess.PIPE)
        if ping.returncode == 0:
            reachable.append((server, ip_address))
        else:
            unreachable.append((server, ip_address))

# Вывод результатов
print('## 1, нельзя разрешить dns имя ##')
for server in unresolved:
    print(server)

print('## 2, имя разрешилось, но сервер не пингуется ##')
for server, ip_address in unreachable:
    print(f'{server}, {ip_address}')

print('## 3, имя разрешилось, сервер пингуется ##')
for server, ip_address in reachable:
    print(f'{server}, {ip_address}')