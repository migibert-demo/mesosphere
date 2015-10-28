import sys

def main():
    zoo_id = 1
    with open('inventory', 'w') as inventory_file:
        for line in sys.stdin:
            splitted_line = line.split(': ')
            group = splitted_line[0]
            hosts = splitted_line[1].replace('\n', '').split(',')
            options = {}

            for host in hosts:
                if group == 'mesos_primaries': 
                    consul_bootstrap = True if zoo_id == 1 else False
                    options[host.replace('.', '')] = 'zoo_id=%s consul_bootstrap=%s' % (zoo_id, consul_bootstrap)
                    zoo_id = zoo_id + 1
                else:
                   options[host.replace('.', '')] = ''

            inventory = '[%s]\n' % group
            for host in hosts:
                inventory = inventory + '%s %s\n' % (host, options[host.replace('.', '')])
            
            inventory_file.write(inventory + '\n')

if __name__ == '__main__':
    main()

